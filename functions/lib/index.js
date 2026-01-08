"use strict";
/**
 * Cloud Functions para Fibro Academy
 * Integración de Gemini AI con datos en tiempo real de WooCommerce y Agent CRM
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.getMentors = exports.getAgentCRMProducts = exports.getTutorials = exports.getContactInfo = exports.getOrCreateCustomer = exports.createOrder = exports.getOrders = exports.getUpcomingEvents = exports.getCourseDetail = exports.getCourses = exports.checkAvailability = exports.getCategories = exports.getProductDetail = exports.getProducts = exports.chat = void 0;
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
exports.chat = (0, https_1.onCall)({ enforceAppCheck: false }, async (request) => {
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
// ==================== PRODUCTOS ====================
/**
 * Cloud Function para obtener productos
 */
exports.getProducts = (0, https_1.onCall)({ enforceAppCheck: false }, async (request) => {
    const { category, search, limit = 20 } = request.data || {};
    try {
        const products = await wooCommerce.getProducts({
            category,
            search,
            limit
        });
        return { success: true, products };
    }
    catch (error) {
        console.error("Error obteniendo productos:", error);
        throw new https_1.HttpsError("internal", "Error obteniendo productos");
    }
});
/**
 * Cloud Function para obtener detalle de un producto
 */
exports.getProductDetail = (0, https_1.onCall)({ enforceAppCheck: false }, async (request) => {
    const { productId, productSlug } = request.data || {};
    try {
        let product;
        if (productId) {
            product = await wooCommerce.getProductById(productId);
        }
        else if (productSlug) {
            product = await wooCommerce.searchProduct(productSlug);
        }
        else {
            throw new https_1.HttpsError("invalid-argument", "Se requiere productId o productSlug");
        }
        return { success: true, product };
    }
    catch (error) {
        console.error("Error obteniendo producto:", error);
        throw new https_1.HttpsError("internal", "Error obteniendo producto");
    }
});
/**
 * Cloud Function para obtener categorías de productos
 */
exports.getCategories = (0, https_1.onCall)({ enforceAppCheck: false }, async (request) => {
    const { parent } = request.data || {};
    try {
        const categories = await wooCommerce.getCategories(parent);
        return { success: true, categories };
    }
    catch (error) {
        console.error("Error obteniendo categorías:", error);
        throw new https_1.HttpsError("internal", "Error obteniendo categorías");
    }
});
/**
 * Cloud Function para verificar disponibilidad de producto
 */
exports.checkAvailability = (0, https_1.onCall)({ enforceAppCheck: false }, async (request) => {
    const { productId } = request.data || {};
    if (!productId) {
        throw new https_1.HttpsError("invalid-argument", "Se requiere productId");
    }
    try {
        const availability = await wooCommerce.checkAvailability(productId);
        return { success: true, availability };
    }
    catch (error) {
        console.error("Error verificando disponibilidad:", error);
        throw new https_1.HttpsError("internal", "Error verificando disponibilidad");
    }
});
// ==================== CURSOS ====================
/**
 * Cloud Function para obtener cursos
 */
exports.getCourses = (0, https_1.onCall)({ enforceAppCheck: false }, async (request) => {
    const { category, search, limit = 20 } = request.data || {};
    try {
        const courses = await agentCRM.getCourses({ category, search, limit });
        return { success: true, courses };
    }
    catch (error) {
        console.error("Error obteniendo cursos:", error);
        throw new https_1.HttpsError("internal", "Error obteniendo cursos");
    }
});
/**
 * Cloud Function para obtener detalle de un curso
 */
exports.getCourseDetail = (0, https_1.onCall)({ enforceAppCheck: false }, async (request) => {
    const { courseId, courseName } = request.data || {};
    try {
        let course;
        if (courseId) {
            course = await agentCRM.getCourseById(courseId);
        }
        else if (courseName) {
            course = await agentCRM.searchCourse(courseName);
        }
        else {
            throw new https_1.HttpsError("invalid-argument", "Se requiere courseId o courseName");
        }
        return { success: true, course };
    }
    catch (error) {
        console.error("Error obteniendo curso:", error);
        throw new https_1.HttpsError("internal", "Error obteniendo curso");
    }
});
/**
 * Cloud Function para obtener próximos eventos
 */
exports.getUpcomingEvents = (0, https_1.onCall)({ enforceAppCheck: false }, async (request) => {
    const { limit = 10 } = request.data || {};
    try {
        const events = await agentCRM.getUpcomingEvents(limit);
        return { success: true, events };
    }
    catch (error) {
        console.error("Error obteniendo eventos:", error);
        throw new https_1.HttpsError("internal", "Error obteniendo eventos");
    }
});
// ==================== ÓRDENES ====================
/**
 * Cloud Function para obtener órdenes de un cliente
 */
exports.getOrders = (0, https_1.onCall)({ enforceAppCheck: false }, async (request) => {
    const { customerId, page = 1, limit = 10 } = request.data || {};
    if (!customerId) {
        throw new https_1.HttpsError("invalid-argument", "Se requiere customerId");
    }
    try {
        const orders = await wooCommerce.getOrders(customerId, page, limit);
        return { success: true, orders };
    }
    catch (error) {
        console.error("Error obteniendo órdenes:", error);
        throw new https_1.HttpsError("internal", "Error obteniendo órdenes");
    }
});
/**
 * Cloud Function para crear una orden
 */
exports.createOrder = (0, https_1.onCall)({ enforceAppCheck: false }, async (request) => {
    const { customerId, lineItems, billing, shipping } = request.data || {};
    if (!lineItems || lineItems.length === 0) {
        throw new https_1.HttpsError("invalid-argument", "Se requieren productos en la orden");
    }
    try {
        const order = await wooCommerce.createOrder({
            customerId,
            lineItems,
            billing,
            shipping,
        });
        return { success: true, order };
    }
    catch (error) {
        console.error("Error creando orden:", error);
        throw new https_1.HttpsError("internal", "Error creando orden");
    }
});
// ==================== CLIENTES ====================
/**
 * Cloud Function para obtener o crear cliente
 */
exports.getOrCreateCustomer = (0, https_1.onCall)({ enforceAppCheck: false }, async (request) => {
    const { email, firstName, lastName, billing } = request.data || {};
    if (!email) {
        throw new https_1.HttpsError("invalid-argument", "Se requiere email");
    }
    try {
        // Primero buscar si existe
        let customer = await wooCommerce.getCustomerByEmail(email);
        if (!customer && firstName && lastName) {
            // Crear nuevo cliente
            customer = await wooCommerce.createCustomer({
                email,
                firstName,
                lastName,
                billing,
            });
        }
        return { success: true, customer };
    }
    catch (error) {
        console.error("Error con cliente:", error);
        throw new https_1.HttpsError("internal", "Error procesando cliente");
    }
});
/**
 * Cloud Function para obtener información de contacto
 */
exports.getContactInfo = (0, https_1.onCall)({ enforceAppCheck: false }, async () => {
    return {
        success: true,
        contact: {
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
        },
    };
});
/**
 * Cloud Function para obtener tutoriales
 * Combina videos de Agent CRM con datos estáticos de la academia
 */
exports.getTutorials = (0, https_1.onCall)({ enforceAppCheck: false }, async (request) => {
    const { category } = request.data || {};
    try {
        // Obtener cursos de Agent CRM que pueden tener videos
        const courses = await agentCRM.getCourses({ limit: 50 });
        // Categorías de tutoriales
        const tutorialCategories = [
            {
                id: "getting-started",
                title: "Primeros Pasos",
                icon: "play_circle_outline",
                color: "#FF5722",
                tutorials: [
                    {
                        id: "welcome",
                        title: "Bienvenida a Fibroskin Academy",
                        description: "Conoce nuestra academia y lo que aprenderás.",
                        duration: "5:30",
                        videoUrl: "https://www.youtube.com/watch?v=fibro-welcome",
                        thumbnailUrl: null,
                        category: "getting-started",
                        isAvailable: true,
                    },
                    {
                        id: "navigation",
                        title: "Cómo navegar la app",
                        description: "Guía rápida de todas las funciones de la aplicación.",
                        duration: "3:45",
                        videoUrl: null,
                        thumbnailUrl: null,
                        category: "getting-started",
                        isAvailable: true,
                    },
                    {
                        id: "first-purchase",
                        title: "Tu primera compra",
                        description: "Paso a paso para comprar tus primeros productos.",
                        duration: "4:20",
                        videoUrl: null,
                        thumbnailUrl: null,
                        category: "getting-started",
                        isAvailable: true,
                    },
                ],
            },
            {
                id: "basic-techniques",
                title: "Técnicas Básicas",
                icon: "school_outlined",
                color: "#26A69A",
                tutorials: courses
                    .filter((c) => c.category?.toLowerCase().includes("taller") ||
                    c.name?.toLowerCase().includes("básico") ||
                    c.name?.toLowerCase().includes("basico"))
                    .slice(0, 5)
                    .map((c) => ({
                    id: c.id,
                    title: c.name,
                    description: c.description || "Aprende técnicas fundamentales de estética.",
                    duration: c.duration || "Variable",
                    videoUrl: c.imageUrl || null,
                    thumbnailUrl: c.imageUrl || null,
                    category: "basic-techniques",
                    isAvailable: true,
                })),
            },
            {
                id: "advanced-techniques",
                title: "Técnicas Avanzadas",
                icon: "auto_awesome",
                color: "#9C27B0",
                tutorials: courses
                    .filter((c) => c.category?.toLowerCase().includes("avanzado") ||
                    c.name?.toLowerCase().includes("master") ||
                    c.name?.toLowerCase().includes("microblading"))
                    .slice(0, 5)
                    .map((c) => ({
                    id: c.id,
                    title: c.name,
                    description: c.description || "Técnicas avanzadas de micropigmentación.",
                    duration: c.duration || "Variable",
                    videoUrl: c.imageUrl || null,
                    thumbnailUrl: c.imageUrl || null,
                    category: "advanced-techniques",
                    isAvailable: true,
                })),
            },
            {
                id: "business-marketing",
                title: "Negocio y Marketing",
                icon: "business_center_outlined",
                color: "#FFA000",
                tutorials: [
                    {
                        id: "portfolio",
                        title: "Crea tu portafolio profesional",
                        description: "Fotografía tus trabajos profesionalmente.",
                        duration: "10:00",
                        videoUrl: null,
                        thumbnailUrl: null,
                        category: "business-marketing",
                        isAvailable: true,
                    },
                    {
                        id: "social-media",
                        title: "Marketing en redes sociales",
                        description: "Estrategias para atraer más clientes.",
                        duration: "14:30",
                        videoUrl: null,
                        thumbnailUrl: null,
                        category: "business-marketing",
                        isAvailable: true,
                    },
                    {
                        id: "pricing",
                        title: "Precios y presupuestos",
                        description: "Cómo establecer tus tarifas competitivamente.",
                        duration: "8:00",
                        videoUrl: null,
                        thumbnailUrl: null,
                        category: "business-marketing",
                        isAvailable: true,
                    },
                ],
            },
        ];
        // Agregar tutoriales adicionales basados en cursos que tengan videos
        const videoCourses = courses.filter((c) => c.imageUrl);
        if (videoCourses.length > 0) {
            tutorialCategories.push({
                id: "featured-courses",
                title: "Cursos Destacados",
                icon: "star_outline",
                color: "#2196F3",
                tutorials: videoCourses.slice(0, 6).map((c) => ({
                    id: c.id,
                    title: c.name,
                    description: c.description || `Curso profesional: ${c.name}`,
                    duration: c.duration || "Consultar",
                    videoUrl: c.imageUrl,
                    thumbnailUrl: c.imageUrl,
                    category: "featured-courses",
                    isAvailable: true,
                })),
            });
        }
        // Filtrar por categoría si se especifica
        let result = tutorialCategories;
        if (category) {
            result = tutorialCategories.filter((c) => c.id === category);
        }
        return {
            success: true,
            categories: result,
            totalTutorials: result.reduce((sum, c) => sum + c.tutorials.length, 0),
        };
    }
    catch (error) {
        console.error("Error obteniendo tutoriales:", error);
        // Retornar tutoriales estáticos de fallback
        return {
            success: true,
            categories: [
                {
                    id: "getting-started",
                    title: "Primeros Pasos",
                    icon: "play_circle_outline",
                    color: "#FF5722",
                    tutorials: [
                        {
                            id: "welcome",
                            title: "Bienvenida a Fibroskin Academy",
                            description: "Conoce nuestra academia y lo que aprenderás.",
                            duration: "5:30",
                            videoUrl: null,
                            thumbnailUrl: null,
                            category: "getting-started",
                            isAvailable: false,
                        },
                    ],
                },
            ],
            totalTutorials: 1,
        };
    }
});
// ==================== PRODUCTOS AGENT CRM ====================
/**
 * Cloud Function para obtener productos de Agent CRM (cursos/membresías)
 */
exports.getAgentCRMProducts = (0, https_1.onCall)({ enforceAppCheck: false }, async (request) => {
    const { type, limit = 50 } = request.data || {};
    try {
        const products = await agentCRM.getCourses({ limit });
        let result = products;
        // Filtrar por tipo si se especifica
        if (type === "courses") {
            result = products.filter((p) => !p.name?.toLowerCase().includes("membresía"));
        }
        else if (type === "memberships") {
            result = products.filter((p) => p.name?.toLowerCase().includes("membresía"));
        }
        return {
            success: true,
            products: result,
            total: result.length,
        };
    }
    catch (error) {
        console.error("Error obteniendo productos de Agent CRM:", error);
        throw new https_1.HttpsError("internal", "Error obteniendo productos de Agent CRM");
    }
});
/**
 * Cloud Function para obtener información de mentores/instructores
 */
exports.getMentors = (0, https_1.onCall)({ enforceAppCheck: false }, async () => {
    // Mentores/instructores de Fibro Academy
    const mentors = [
        {
            id: "1",
            name: "Fibro Academy Team",
            title: "Equipo de Instructores",
            bio: "Nuestro equipo de instructores certificados con años de experiencia en micropigmentación, estética facial y corporal.",
            imageUrl: null,
            specialties: ["Microblading", "Micropigmentación", "Estética Facial", "Tratamientos Corporales"],
            socialLinks: {
                instagram: "@fibroacademyusa",
            },
        },
        {
            id: "2",
            name: "Master Trainer",
            title: "Instructor Principal",
            bio: "Especialista en técnicas avanzadas de micropigmentación con certificaciones internacionales.",
            imageUrl: null,
            specialties: ["Microblading Avanzado", "Powder Brows", "Lip Blushing", "Correcciones"],
            socialLinks: {
                instagram: "@fibroacademyusa",
            },
        },
        {
            id: "3",
            name: "Beauty Expert",
            title: "Especialista en Skincare",
            bio: "Experta en tratamientos faciales y protocolos de skincare profesional.",
            imageUrl: null,
            specialties: ["Skincare Profesional", "Faciales", "Peelings", "Hidratación"],
            socialLinks: {
                instagram: "@fibroacademyusa",
            },
        },
    ];
    return {
        success: true,
        mentors,
        total: mentors.length,
    };
});
//# sourceMappingURL=index.js.map