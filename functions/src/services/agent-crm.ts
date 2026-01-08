/**
 * Servicio para conectar con Agent CRM Pro (Go High Level)
 * Obtiene cursos, calendarios, eventos, etc.
 */

import axios, { AxiosInstance } from "axios";

interface AgentCRMConfig {
  baseUrl: string;
  apiKey: string;
  locationId: string;
  apiVersion: string;
}

interface Course {
  id: string;
  name: string;
  description: string;
  price: number;
  priceFormatted: string;
  category: string;
  imageUrl: string | null;
  duration: string | null;
  availability: string;
}

interface Event {
  id: string;
  title: string;
  description: string;
  startTime: string;
  endTime: string;
  location: string;
  type: string;
}

interface GetCoursesParams {
  category?: string;
  search?: string;
  limit?: number;
}

export class AgentCRMAPI {
  private client: AxiosInstance;
  private config: AgentCRMConfig;

  constructor() {
    // Credenciales desde variables de entorno de Firebase
    this.config = {
      baseUrl: process.env.AGENT_CRM_BASE_URL || "https://services.leadconnectorhq.com",
      apiKey: process.env.AGENT_CRM_API_KEY || "",
      locationId: process.env.AGENT_CRM_LOCATION_ID || "",
      apiVersion: process.env.AGENT_CRM_API_VERSION || "2021-07-28",
    };

    this.client = axios.create({
      baseURL: this.config.baseUrl,
      headers: {
        Authorization: `Bearer ${this.config.apiKey}`,
        Version: this.config.apiVersion,
        "Content-Type": "application/json",
      },
      timeout: 15000,
    });
  }

  /**
   * Obtiene lista de cursos/productos del CRM
   */
  async getCourses(params: GetCoursesParams): Promise<Course[]> {
    try {
      const response = await this.client.get("/products/", {
        params: {
          locationId: this.config.locationId,
          limit: params.limit || 10,
        },
      });

      let courses = response.data?.products || [];

      // Filtrar por categoría si se especifica
      if (params.category) {
        courses = courses.filter(
          (course: { productType?: string; name?: string }) =>
            course.productType?.toLowerCase().includes(params.category!.toLowerCase()) ||
            this.matchCourseCategory(course.name || "", params.category!)
        );
      }

      // Filtrar por búsqueda si se especifica
      if (params.search) {
        const searchLower = params.search.toLowerCase();
        courses = courses.filter(
          (course: { name?: string; description?: string }) =>
            course.name?.toLowerCase().includes(searchLower) ||
            course.description?.toLowerCase().includes(searchLower)
        );
      }

      return courses.slice(0, params.limit || 10).map((course: Record<string, unknown>) => ({
        id: course._id || course.id,
        name: course.name,
        description: this.stripHtml((course.description as string) || ""),
        price: (course.prices as Record<string, unknown>)?.amount || course.amount || 0,
        priceFormatted: this.formatPrice(
          ((course.prices as Record<string, unknown>)?.amount as number) || (course.amount as number) || 0,
          ((course.prices as Record<string, unknown>)?.currency as string) || "USD"
        ),
        category: this.detectCourseCategory((course.name as string) || ""),
        imageUrl: course.imageUrl || course.image || null,
        duration: course.duration || null,
        availability: "Disponible",
      }));
    } catch (error) {
      console.error("AgentCRM getCourses error:", error);
      // NO devolver datos estáticos - solo datos reales
      throw error;
    }
  }

  /**
   * Obtiene un curso específico por ID
   */
  async getCourseById(courseId: string): Promise<Course | null> {
    try {
      const response = await this.client.get(`/products/${courseId}`);
      const course = response.data;

      return {
        id: course._id || course.id,
        name: course.name,
        description: this.stripHtml(course.description || ""),
        price: course.prices?.amount || course.amount || 0,
        priceFormatted: this.formatPrice(
          course.prices?.amount || course.amount || 0,
          course.prices?.currency || "USD"
        ),
        category: this.detectCourseCategory(course.name || ""),
        imageUrl: course.imageUrl || course.image || null,
        duration: course.duration || null,
        availability: "Disponible",
      };
    } catch (error) {
      console.error(`AgentCRM getCourseById(${courseId}) error:`, error);
      return null;
    }
  }

  /**
   * Busca un curso por nombre
   */
  async searchCourse(courseName: string): Promise<Course | null> {
    try {
      const courses = await this.getCourses({ search: courseName, limit: 1 });
      return courses.length > 0 ? courses[0] : null;
    } catch (error) {
      console.error(`AgentCRM searchCourse(${courseName}) error:`, error);
      return null;
    }
  }

  /**
   * Obtiene próximos eventos del calendario
   */
  async getUpcomingEvents(limit: number = 5): Promise<Event[]> {
    try {
      // Primero obtener los calendarios
      const calendarsResponse = await this.client.get("/calendars/", {
        params: { locationId: this.config.locationId },
      });

      const calendars = calendarsResponse.data?.calendars || [];
      if (calendars.length === 0) {
        return this.getStaticEvents(limit);
      }

      // Obtener eventos de los próximos 30 días
      const now = new Date();
      const endDate = new Date();
      endDate.setDate(endDate.getDate() + 30);

      const allEvents: Event[] = [];

      for (const calendar of calendars.slice(0, 3)) {
        try {
          const slotsResponse = await this.client.get(`/calendars/${calendar.id}/free-slots`, {
            params: {
              startDate: now.toISOString().split("T")[0],
              endDate: endDate.toISOString().split("T")[0],
            },
          });

          const slots = slotsResponse.data?.slots || {};

          for (const [date, times] of Object.entries(slots)) {
            const timeSlots = times as string[];
            if (timeSlots.length > 0) {
              allEvents.push({
                id: `${calendar.id}-${date}`,
                title: calendar.name || "Evento",
                description: calendar.description || "",
                startTime: `${date}T${timeSlots[0]}`,
                endTime: `${date}T${timeSlots[timeSlots.length - 1]}`,
                location: "Fibro Academy USA - 2684 NW 97th Ave, Doral, FL",
                type: calendar.eventType || "Taller",
              });
            }
          }
        } catch {
          // Ignorar errores de calendarios individuales
        }
      }

      return allEvents.slice(0, limit);
    } catch (error) {
      console.error("AgentCRM getUpcomingEvents error:", error);
      // NO devolver datos estáticos - solo datos reales
      throw error;
    }
  }

  /**
   * Detecta la categoría de un curso basándose en su nombre
   */
  private detectCourseCategory(name: string): string {
    const nameLower = name.toLowerCase();

    if (nameLower.includes("corporal") || nameLower.includes("body") ||
        nameLower.includes("butt") || nameLower.includes("fibrolight")) {
      return "Cursos Corporales";
    }

    if (nameLower.includes("plasma") || nameLower.includes("botox") ||
        nameLower.includes("hialurónico") || nameLower.includes("hyaluronic")) {
      return "Estética Médica";
    }

    if (nameLower.includes("cosmético") || nameLower.includes("formulación")) {
      return "Talleres Cosméticos";
    }

    return "Talleres";
  }

  /**
   * Verifica si un curso pertenece a una categoría
   */
  private matchCourseCategory(courseName: string, category: string): boolean {
    const categoryLower = category.toLowerCase();
    const nameLower = courseName.toLowerCase();

    const categoryMapping: Record<string, string[]> = {
      talleres: ["taller", "mesoterapia", "microblading", "skincare", "limpieza", "hydra", "pdo", "enzimas"],
      "cursos-corporales": ["corporal", "body", "butt", "fibrolight", "contour", "reductivo"],
      "estetica-medica": ["plasma", "botox", "hialurónico", "hyaluronic", "médica", "avanzado"],
      "talleres-cosmeticos": ["cosmético", "formulación", "skincare pro"],
    };

    const keywords = categoryMapping[categoryLower] || [];
    return keywords.some((keyword) => nameLower.includes(keyword));
  }

  /**
   * Formatea precio
   */
  private formatPrice(amount: number, currency: string = "USD"): string {
    return new Intl.NumberFormat("en-US", {
      style: "currency",
      currency,
    }).format(amount / 100); // Asume centavos
  }

  /**
   * Elimina tags HTML
   */
  private stripHtml(html: string): string {
    if (!html) return "";
    return html.replace(/<[^>]*>/g, "").trim();
  }
}
