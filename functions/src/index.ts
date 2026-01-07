/**
 * Cloud Functions para Fibro Academy
 * Integración de Gemini AI con datos en tiempo real de WooCommerce y Agent CRM
 */

import { onCall, HttpsError, CallableRequest } from "firebase-functions/v2/https";
import { initializeApp } from "firebase-admin/app";
import { VertexAI, FunctionDeclaration, FunctionDeclarationSchemaType, Part } from "@google-cloud/vertexai";
import { WooCommerceAPI } from "./services/woocommerce";
import { AgentCRMAPI } from "./services/agent-crm";

initializeApp();

// Interfaces para tipado
interface ChatMessage {
  role: string;
  content: string;
}

interface ChatRequest {
  message: string;
  conversationHistory?: ChatMessage[];
}

interface ProductsRequest {
  category?: string;
  search?: string;
  limit?: number;
}

interface CoursesRequest {
  category?: string;
  search?: string;
  limit?: number;
}

// Inicializar Vertex AI (Gemini)
const vertexAI = new VertexAI({
  project: "eng-gate-453810-h3",
  location: "us-central1",
});

// Instancias de APIs
const wooCommerce = new WooCommerceAPI();
const agentCRM = new AgentCRMAPI();

// Definición de las funciones que Gemini puede llamar
const functionDeclarations: FunctionDeclaration[] = [
  {
    name: "getProducts",
    description: "Obtiene la lista de productos disponibles en la tienda de Fibro Academy. Usa esto cuando el usuario pregunte sobre productos, cremas, equipos, o qué hay disponible para comprar.",
    parameters: {
      type: FunctionDeclarationSchemaType.OBJECT,
      properties: {
        category: {
          type: FunctionDeclarationSchemaType.STRING,
          description: "Categoría de productos: fibroskin-jelly-mask, dm-cell, co2, collagen, lendan, numbing-cream, accesorios, equipos",
        },
        search: {
          type: FunctionDeclarationSchemaType.STRING,
          description: "Término de búsqueda para filtrar productos",
        },
        limit: {
          type: FunctionDeclarationSchemaType.NUMBER,
          description: "Número máximo de productos a retornar (default: 10)",
        },
      },
    },
  },
  {
    name: "getProductDetails",
    description: "Obtiene detalles específicos de un producto por su ID o nombre. Usa esto cuando el usuario pregunte sobre un producto específico, su precio, descripción o disponibilidad.",
    parameters: {
      type: FunctionDeclarationSchemaType.OBJECT,
      properties: {
        productId: {
          type: FunctionDeclarationSchemaType.NUMBER,
          description: "ID del producto en WooCommerce",
        },
        productName: {
          type: FunctionDeclarationSchemaType.STRING,
          description: "Nombre del producto para buscar",
        },
      },
    },
  },
  {
    name: "getCourses",
    description: "Obtiene la lista de cursos disponibles en Fibro Academy. Usa esto cuando el usuario pregunte sobre cursos, talleres, capacitaciones, o qué puede aprender.",
    parameters: {
      type: FunctionDeclarationSchemaType.OBJECT,
      properties: {
        category: {
          type: FunctionDeclarationSchemaType.STRING,
          description: "Categoría de cursos: talleres, cursos-corporales, estetica-medica, talleres-cosmeticos",
        },
        search: {
          type: FunctionDeclarationSchemaType.STRING,
          description: "Término de búsqueda para filtrar cursos",
        },
        limit: {
          type: FunctionDeclarationSchemaType.NUMBER,
          description: "Número máximo de cursos a retornar (default: 10)",
        },
      },
    },
  },
  {
    name: "getCourseDetails",
    description: "Obtiene detalles específicos de un curso por su ID o nombre. Usa esto cuando el usuario pregunte sobre un curso específico, su precio, duración o contenido.",
    parameters: {
      type: FunctionDeclarationSchemaType.OBJECT,
      properties: {
        courseId: {
          type: FunctionDeclarationSchemaType.STRING,
          description: "ID del curso en Agent CRM",
        },
        courseName: {
          type: FunctionDeclarationSchemaType.STRING,
          description: "Nombre del curso para buscar",
        },
      },
    },
  },
  {
    name: "getUpcomingEvents",
    description: "Obtiene los próximos eventos, talleres presenciales o fechas de cursos. Usa esto cuando el usuario pregunte sobre fechas, horarios, o cuándo hay cursos disponibles.",
    parameters: {
      type: FunctionDeclarationSchemaType.OBJECT,
      properties: {
        limit: {
          type: FunctionDeclarationSchemaType.NUMBER,
          description: "Número máximo de eventos a retornar (default: 5)",
        },
      },
    },
  },
  {
    name: "checkProductAvailability",
    description: "Verifica la disponibilidad de un producto específico. Usa esto cuando el usuario pregunte si hay stock o si un producto está disponible.",
    parameters: {
      type: FunctionDeclarationSchemaType.OBJECT,
      properties: {
        productId: {
          type: FunctionDeclarationSchemaType.NUMBER,
          description: "ID del producto",
        },
        productName: {
          type: FunctionDeclarationSchemaType.STRING,
          description: "Nombre del producto",
        },
      },
      required: [],
    },
  },
  {
    name: "getContactInfo",
    description: "Obtiene información de contacto de Fibro Academy. Usa esto cuando el usuario pregunte cómo contactar, dónde está ubicada la academia, teléfono, email, etc.",
    parameters: {
      type: FunctionDeclarationSchemaType.OBJECT,
      properties: {},
    },
  },
];

// Ejecutar las funciones cuando Gemini las llame
async function executeFunctionCall(
  functionName: string,
  args: Record<string, unknown>
): Promise<unknown> {
  console.log(`Ejecutando función: ${functionName}`, args);

  switch (functionName) {
    case "getProducts":
      return await wooCommerce.getProducts({
        category: args.category as string | undefined,
        search: args.search as string | undefined,
        limit: (args.limit as number) || 10,
      });

    case "getProductDetails":
      if (args.productId) {
        return await wooCommerce.getProductById(args.productId as number);
      } else if (args.productName) {
        return await wooCommerce.searchProduct(args.productName as string);
      }
      return { error: "Se requiere productId o productName" };

    case "getCourses":
      return await agentCRM.getCourses({
        category: args.category as string | undefined,
        search: args.search as string | undefined,
        limit: (args.limit as number) || 10,
      });

    case "getCourseDetails":
      if (args.courseId) {
        return await agentCRM.getCourseById(args.courseId as string);
      } else if (args.courseName) {
        return await agentCRM.searchCourse(args.courseName as string);
      }
      return { error: "Se requiere courseId o courseName" };

    case "getUpcomingEvents":
      return await agentCRM.getUpcomingEvents((args.limit as number) || 5);

    case "checkProductAvailability":
      if (args.productId) {
        return await wooCommerce.checkAvailability(args.productId as number);
      } else if (args.productName) {
        const product = await wooCommerce.searchProduct(args.productName as string);
        if (product) {
          return {
            available: product.stock_status === "instock",
            stock_quantity: product.stock_quantity,
            name: product.name,
          };
        }
      }
      return { error: "Producto no encontrado" };

    case "getContactInfo":
      return {
        nombre: "Fibro Academy USA",
        direccion: "2684 NW 97th Ave, Doral, FL 33172",
        telefono: "(305) 632-4630",
        email: "hello@fibroacademyusa.com",
        website: "https://fibroacademyusa.com",
        horario: "Lunes a Viernes: 9:00 AM - 6:00 PM, Sábados: 10:00 AM - 2:00 PM",
        redes_sociales: {
          instagram: "@fibroacademyusa",
          facebook: "FibroAcademyUSA",
        },
      };

    default:
      return { error: `Función desconocida: ${functionName}` };
  }
}

// System prompt para Gemini
const SYSTEM_PROMPT = `Eres el asistente virtual de Fibro Academy USA, una academia de estética y belleza ubicada en Doral, Miami, Florida.

Tu misión es ayudar a los usuarios con:
- Información sobre cursos y talleres de estética
- Productos profesionales para el cuidado de la piel
- Precios, disponibilidad y fechas de cursos
- Información de contacto y ubicación

DIRECTRICES:
- Responde en español por defecto, o en inglés si el usuario escribe en inglés
- Sé amable, profesional y entusiasta sobre la estética
- USA LAS FUNCIONES DISPONIBLES para obtener datos reales cuando el usuario pregunte sobre productos, cursos, precios o disponibilidad
- Si no encuentras información específica, ofrece alternativas o sugiere contactar directamente
- Destaca los beneficios de certificarse con Fibro Academy
- Para compras y reservas complejas, sugiere usar la app o el sitio web

CATEGORÍAS DE PRODUCTOS:
- FibroSkin Jelly Masks - Máscaras faciales profesionales
- Línea DM.Cell - Skincare profesional coreano
- Línea CO2 - Carboxiterapia
- Colágeno - Hilos PDO y threads
- Lendan - Vitamina C profesional
- Anestésicos - Cremas numbing
- Accesorios - Herramientas profesionales
- Equipos - Maquinaria de estética

CATEGORÍAS DE CURSOS:
- Talleres: Mesoterapia, Hydra Gloss, Microblading, Enzimas, Masaje Reductivo, PDO Threads, Skincare, Limpieza Facial
- Cursos Corporales: Fibrolight, Butt Lift, Body Contour
- Estética Médica: Plasma Rico, Ácido Hialurónico, Botox, Microblading Avanzado
- Talleres Cosméticos: Formulación Cosmética, Skincare Pro

RESTRICCIONES:
- No proporciones consejos médicos específicos
- No menciones competidores
- No inventes información que no puedas verificar con las funciones disponibles`;

/**
 * Cloud Function principal para el chatbot
 * Recibe mensajes y responde usando Gemini con Function Calling
 */
export const chat = onCall(async (request: CallableRequest<ChatRequest>) => {
  const { message, conversationHistory = [] } = request.data;

  if (!message) {
    throw new HttpsError(
      "invalid-argument",
      "Se requiere un mensaje"
    );
  }

  try {
    // Inicializar el modelo con Function Calling
    const model = vertexAI.getGenerativeModel({
      model: "gemini-2.0-flash-exp",
      tools: [{ functionDeclarations }],
      systemInstruction: SYSTEM_PROMPT,
    });

    // Construir el historial de conversación
    const contents = [
      ...conversationHistory.map((msg: { role: string; content: string }) => ({
        role: msg.role,
        parts: [{ text: msg.content }],
      })),
      {
        role: "user",
        parts: [{ text: message }],
      },
    ];

    // Iniciar chat
    const chatSession = model.startChat({ history: contents.slice(0, -1) });

    // Enviar mensaje
    let response = await chatSession.sendMessage(message);
    let functionCallResult = response.response.candidates?.[0]?.content?.parts?.find(
      (part: Part) => part.functionCall
    );

    // Loop para manejar múltiples function calls si es necesario
    while (functionCallResult?.functionCall) {
      const { name, args } = functionCallResult.functionCall;

      console.log(`Gemini solicitó función: ${name}`, args);

      // Ejecutar la función
      const result = await executeFunctionCall(name, args as Record<string, unknown>);

      console.log(`Resultado de ${name}:`, JSON.stringify(result).substring(0, 500));

      // Enviar el resultado de vuelta a Gemini
      response = await chatSession.sendMessage([
        {
          functionResponse: {
            name,
            response: { result },
          },
        },
      ]);

      // Verificar si hay más function calls
      functionCallResult = response.response.candidates?.[0]?.content?.parts?.find(
        (part: Part) => part.functionCall
      );
    }

    // Obtener la respuesta final de texto
    const textResponse = response.response.candidates?.[0]?.content?.parts
      ?.filter((part: Part) => part.text)
      ?.map((part: Part) => part.text)
      ?.join("") || "Lo siento, no pude procesar tu solicitud.";

    return {
      success: true,
      response: textResponse,
      conversationHistory: [
        ...conversationHistory,
        { role: "user", content: message },
        { role: "model", content: textResponse },
      ],
    };
  } catch (error) {
    console.error("Error en chat:", error);
    throw new HttpsError(
      "internal",
      "Error procesando el mensaje"
    );
  }
});

/**
 * Cloud Function para obtener productos (acceso directo sin chat)
 */
export const getProducts = onCall(async (request: CallableRequest<ProductsRequest>) => {
  const { category, search, limit } = request.data;

  try {
    const products = await wooCommerce.getProducts({ category, search, limit });
    return { success: true, products };
  } catch (error) {
    console.error("Error obteniendo productos:", error);
    throw new HttpsError("internal", "Error obteniendo productos");
  }
});

/**
 * Cloud Function para obtener cursos (acceso directo sin chat)
 */
export const getCourses = onCall(async (request: CallableRequest<CoursesRequest>) => {
  const { category, search, limit } = request.data;

  try {
    const courses = await agentCRM.getCourses({ category, search, limit });
    return { success: true, courses };
  } catch (error) {
    console.error("Error obteniendo cursos:", error);
    throw new HttpsError("internal", "Error obteniendo cursos");
  }
});
