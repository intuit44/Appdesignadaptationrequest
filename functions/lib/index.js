"use strict";
/**
 * Cloud Functions para Fibro Academy
 * Integración de Gemini AI con datos en tiempo real de WooCommerce y Agent CRM
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.getCourses = exports.getProducts = exports.chat = void 0;
const https_1 = require("firebase-functions/v2/https");
const app_1 = require("firebase-admin/app");
const vertexai_1 = require("@google-cloud/vertexai");
const woocommerce_1 = require("./services/woocommerce");
const agent_crm_1 = require("./services/agent-crm");
(0, app_1.initializeApp)();
// Inicializar Vertex AI (Gemini)
const vertexAI = new vertexai_1.VertexAI({
    project: "eng-gate-453810-h3",
    location: "us-central1",
});
// Instancias de APIs
const wooCommerce = new woocommerce_1.WooCommerceAPI();
const agentCRM = new agent_crm_1.AgentCRMAPI();
// Definición de las funciones que Gemini puede llamar
const functionDeclarations = [
    {
        name: "getProducts",
        description: "Obtiene la lista de productos disponibles en la tienda de Fibro Academy. Usa esto cuando el usuario pregunte sobre productos, cremas, equipos, o qué hay disponible para comprar.",
        parameters: {
            type: vertexai_1.FunctionDeclarationSchemaType.OBJECT,
            properties: {
                category: {
                    type: vertexai_1.FunctionDeclarationSchemaType.STRING,
                    description: "Categoría de productos: fibroskin-jelly-mask, dm-cell, co2, collagen, lendan, numbing-cream, accesorios, equipos",
                },
                search: {
                    type: vertexai_1.FunctionDeclarationSchemaType.STRING,
                    description: "Término de búsqueda para filtrar productos",
                },
                limit: {
                    type: vertexai_1.FunctionDeclarationSchemaType.NUMBER,
                    description: "Número máximo de productos a retornar (default: 10)",
                },
            },
        },
    },
    {
        name: "getProductDetails",
        description: "Obtiene detalles específicos de un producto por su ID o nombre. Usa esto cuando el usuario pregunte sobre un producto específico, su precio, descripción o disponibilidad.",
        parameters: {
            type: vertexai_1.FunctionDeclarationSchemaType.OBJECT,
            properties: {
                productId: {
                    type: vertexai_1.FunctionDeclarationSchemaType.NUMBER,
                    description: "ID del producto en WooCommerce",
                },
                productName: {
                    type: vertexai_1.FunctionDeclarationSchemaType.STRING,
                    description: "Nombre del producto para buscar",
                },
            },
        },
    },
    {
        name: "getCourses",
        description: "Obtiene la lista de cursos disponibles en Fibro Academy. Usa esto cuando el usuario pregunte sobre cursos, talleres, capacitaciones, o qué puede aprender.",
        parameters: {
            type: vertexai_1.FunctionDeclarationSchemaType.OBJECT,
            properties: {
                category: {
                    type: vertexai_1.FunctionDeclarationSchemaType.STRING,
                    description: "Categoría de cursos: talleres, cursos-corporales, estetica-medica, talleres-cosmeticos",
                },
                search: {
                    type: vertexai_1.FunctionDeclarationSchemaType.STRING,
                    description: "Término de búsqueda para filtrar cursos",
                },
                limit: {
                    type: vertexai_1.FunctionDeclarationSchemaType.NUMBER,
                    description: "Número máximo de cursos a retornar (default: 10)",
                },
            },
        },
    },
    {
        name: "getCourseDetails",
        description: "Obtiene detalles específicos de un curso por su ID o nombre. Usa esto cuando el usuario pregunte sobre un curso específico, su precio, duración o contenido.",
        parameters: {
            type: vertexai_1.FunctionDeclarationSchemaType.OBJECT,
            properties: {
                courseId: {
                    type: vertexai_1.FunctionDeclarationSchemaType.STRING,
                    description: "ID del curso en Agent CRM",
                },
                courseName: {
                    type: vertexai_1.FunctionDeclarationSchemaType.STRING,
                    description: "Nombre del curso para buscar",
                },
            },
        },
    },
    {
        name: "getUpcomingEvents",
        description: "Obtiene los próximos eventos, talleres presenciales o fechas de cursos. Usa esto cuando el usuario pregunte sobre fechas, horarios, o cuándo hay cursos disponibles.",
        parameters: {
            type: vertexai_1.FunctionDeclarationSchemaType.OBJECT,
            properties: {
                limit: {
                    type: vertexai_1.FunctionDeclarationSchemaType.NUMBER,
                    description: "Número máximo de eventos a retornar (default: 5)",
                },
            },
        },
    },
    {
        name: "checkProductAvailability",
        description: "Verifica la disponibilidad de un producto específico. Usa esto cuando el usuario pregunte si hay stock o si un producto está disponible.",
        parameters: {
            type: vertexai_1.FunctionDeclarationSchemaType.OBJECT,
            properties: {
                productId: {
                    type: vertexai_1.FunctionDeclarationSchemaType.NUMBER,
                    description: "ID del producto",
                },
                productName: {
                    type: vertexai_1.FunctionDeclarationSchemaType.STRING,
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
            type: vertexai_1.FunctionDeclarationSchemaType.OBJECT,
            properties: {},
        },
    },
];
// Ejecutar las funciones cuando Gemini las llame
async function executeFunctionCall(functionName, args) {
    console.log(`Ejecutando función: ${functionName}`, args);
    switch (functionName) {
        case "getProducts":
            return await wooCommerce.getProducts({
                category: args.category,
                search: args.search,
                limit: args.limit || 10,
            });
        case "getProductDetails":
            if (args.productId) {
                return await wooCommerce.getProductById(args.productId);
            }
            else if (args.productName) {
                return await wooCommerce.searchProduct(args.productName);
            }
            return { error: "Se requiere productId o productName" };
        case "getCourses":
            return await agentCRM.getCourses({
                category: args.category,
                search: args.search,
                limit: args.limit || 10,
            });
        case "getCourseDetails":
            if (args.courseId) {
                return await agentCRM.getCourseById(args.courseId);
            }
            else if (args.courseName) {
                return await agentCRM.searchCourse(args.courseName);
            }
            return { error: "Se requiere courseId o courseName" };
        case "getUpcomingEvents":
            return await agentCRM.getUpcomingEvents(args.limit || 5);
        case "checkProductAvailability":
            if (args.productId) {
                return await wooCommerce.checkAvailability(args.productId);
            }
            else if (args.productName) {
                const product = await wooCommerce.searchProduct(args.productName);
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
exports.chat = (0, https_1.onCall)(async (request) => {
    const { message, conversationHistory = [] } = request.data;
    if (!message) {
        throw new https_1.HttpsError("invalid-argument", "Se requiere un mensaje");
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
            ...conversationHistory.map((msg) => ({
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
        let functionCallResult = response.response.candidates?.[0]?.content?.parts?.find((part) => part.functionCall);
        // Loop para manejar múltiples function calls si es necesario
        while (functionCallResult?.functionCall) {
            const { name, args } = functionCallResult.functionCall;
            console.log(`Gemini solicitó función: ${name}`, args);
            // Ejecutar la función
            const result = await executeFunctionCall(name, args);
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
            functionCallResult = response.response.candidates?.[0]?.content?.parts?.find((part) => part.functionCall);
        }
        // Obtener la respuesta final de texto
        const textResponse = response.response.candidates?.[0]?.content?.parts
            ?.filter((part) => part.text)
            ?.map((part) => part.text)
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
    }
    catch (error) {
        console.error("Error en chat:", error);
        throw new https_1.HttpsError("internal", "Error procesando el mensaje");
    }
});
/**
 * Cloud Function para obtener productos (acceso directo sin chat)
 */
exports.getProducts = (0, https_1.onCall)(async (request) => {
    const { category, search, limit } = request.data;
    try {
        const products = await wooCommerce.getProducts({ category, search, limit });
        return { success: true, products };
    }
    catch (error) {
        console.error("Error obteniendo productos:", error);
        throw new https_1.HttpsError("internal", "Error obteniendo productos");
    }
});
/**
 * Cloud Function para obtener cursos (acceso directo sin chat)
 */
exports.getCourses = (0, https_1.onCall)(async (request) => {
    const { category, search, limit } = request.data;
    try {
        const courses = await agentCRM.getCourses({ category, search, limit });
        return { success: true, courses };
    }
    catch (error) {
        console.error("Error obteniendo cursos:", error);
        throw new https_1.HttpsError("internal", "Error obteniendo cursos");
    }
});
//# sourceMappingURL=index.js.map