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
      // Retornar datos estáticos si la API falla
      return this.getStaticCourses(params);
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
      return this.getStaticEvents(limit);
    }
  }

  /**
   * Datos estáticos de cursos como fallback
   */
  private getStaticCourses(params: GetCoursesParams): Course[] {
    const allCourses: Course[] = [
      // Talleres
      { id: "taller-mesoterapia", name: "Taller de Mesoterapia", description: "Aprende técnicas avanzadas de mesoterapia facial y corporal", price: 450, priceFormatted: "$450.00", category: "Talleres", imageUrl: null, duration: "8 horas", availability: "Disponible" },
      { id: "taller-hydragloss", name: "Taller Hydra Gloss", description: "Técnica de hidratación profunda con efecto glass skin", price: 350, priceFormatted: "$350.00", category: "Talleres", imageUrl: null, duration: "6 horas", availability: "Disponible" },
      { id: "taller-microblading", name: "Taller de Microblading", description: "Certificación completa en microblading de cejas", price: 800, priceFormatted: "$800.00", category: "Talleres", imageUrl: null, duration: "2 días", availability: "Disponible" },
      { id: "taller-pdo-threads", name: "Taller PDO Threads", description: "Hilos tensores para rejuvenecimiento facial", price: 600, priceFormatted: "$600.00", category: "Talleres", imageUrl: null, duration: "8 horas", availability: "Disponible" },
      { id: "taller-skincare", name: "Taller de Skincare", description: "Fundamentos del cuidado profesional de la piel", price: 300, priceFormatted: "$300.00", category: "Talleres", imageUrl: null, duration: "6 horas", availability: "Disponible" },
      // Cursos Corporales
      { id: "curso-fibrolight", name: "Curso Fibrolight", description: "Técnica exclusiva de tratamiento corporal con luz", price: 500, priceFormatted: "$500.00", category: "Cursos Corporales", imageUrl: null, duration: "8 horas", availability: "Disponible" },
      { id: "curso-butt-lift", name: "Curso Butt Lift", description: "Técnicas de levantamiento de glúteos no invasivo", price: 450, priceFormatted: "$450.00", category: "Cursos Corporales", imageUrl: null, duration: "6 horas", availability: "Disponible" },
      { id: "curso-body-contour", name: "Curso Body Contour", description: "Moldeo corporal profesional", price: 550, priceFormatted: "$550.00", category: "Cursos Corporales", imageUrl: null, duration: "8 horas", availability: "Disponible" },
      // Estética Médica
      { id: "curso-plasma-rico", name: "Curso Plasma Rico (PRP)", description: "Tratamiento con plasma rico en plaquetas", price: 700, priceFormatted: "$700.00", category: "Estética Médica", imageUrl: null, duration: "8 horas", availability: "Disponible" },
      { id: "curso-acido-hialuronico", name: "Curso Ácido Hialurónico", description: "Aplicación de rellenos dérmicos", price: 900, priceFormatted: "$900.00", category: "Estética Médica", imageUrl: null, duration: "2 días", availability: "Disponible" },
      { id: "curso-botox", name: "Curso de Botox", description: "Certificación en aplicación de toxina botulínica", price: 1000, priceFormatted: "$1,000.00", category: "Estética Médica", imageUrl: null, duration: "2 días", availability: "Disponible" },
    ];

    let filtered = allCourses;

    if (params.category) {
      filtered = filtered.filter((c) => this.matchCourseCategory(c.name, params.category!));
    }

    if (params.search) {
      const searchLower = params.search.toLowerCase();
      filtered = filtered.filter(
        (c) =>
          c.name.toLowerCase().includes(searchLower) ||
          c.description.toLowerCase().includes(searchLower)
      );
    }

    return filtered.slice(0, params.limit || 10);
  }

  /**
   * Eventos estáticos como fallback
   */
  private getStaticEvents(limit: number): Event[] {
    const now = new Date();
    const events: Event[] = [];

    // Generar eventos para las próximas semanas
    const eventTypes = [
      { title: "Taller de Mesoterapia", type: "Taller" },
      { title: "Curso PDO Threads", type: "Curso" },
      { title: "Taller Skincare Profesional", type: "Taller" },
      { title: "Curso de Body Contour", type: "Curso" },
    ];

    for (let i = 0; i < limit; i++) {
      const eventDate = new Date(now);
      eventDate.setDate(eventDate.getDate() + (i + 1) * 7); // Cada semana
      const eventType = eventTypes[i % eventTypes.length];

      events.push({
        id: `event-${i}`,
        title: eventType.title,
        description: `${eventType.type} presencial en Fibro Academy USA`,
        startTime: `${eventDate.toISOString().split("T")[0]}T09:00:00`,
        endTime: `${eventDate.toISOString().split("T")[0]}T17:00:00`,
        location: "Fibro Academy USA - 2684 NW 97th Ave, Doral, FL",
        type: eventType.type,
      });
    }

    return events;
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
