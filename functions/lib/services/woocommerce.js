"use strict";
/**
 * Servicio para conectar con WooCommerce REST API
 * Obtiene productos, categorías, stock, etc.
 */
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.WooCommerceAPI = void 0;
const axios_1 = __importDefault(require("axios"));
class WooCommerceAPI {
    constructor() {
        // Credenciales desde variables de entorno de Firebase
        this.config = {
            url: process.env.WOOCOMMERCE_URL || "https://fibroacademyusa.com",
            consumerKey: process.env.WOOCOMMERCE_KEY || "",
            consumerSecret: process.env.WOOCOMMERCE_SECRET || "",
        };
        this.client = axios_1.default.create({
            baseURL: `${this.config.url}/wp-json/wc/v3`,
            auth: {
                username: this.config.consumerKey,
                password: this.config.consumerSecret,
            },
            timeout: 15000,
        });
    }
    /**
     * Obtiene lista de productos con filtros opcionales
     */
    async getProducts(params) {
        try {
            const queryParams = {
                per_page: params.limit || 10,
                status: "publish",
            };
            if (params.category) {
                // Buscar categoría por slug
                const categoryId = await this.getCategoryIdBySlug(params.category);
                if (categoryId) {
                    queryParams.category = categoryId;
                }
            }
            if (params.search) {
                queryParams.search = params.search;
            }
            if (params.featured !== undefined) {
                queryParams.featured = params.featured;
            }
            if (params.on_sale !== undefined) {
                queryParams.on_sale = params.on_sale;
            }
            const response = await this.client.get("/products", { params: queryParams });
            return response.data.map((product) => ({
                id: product.id,
                name: product.name,
                price: product.price,
                regular_price: product.regular_price,
                sale_price: product.sale_price,
                description: this.stripHtml(product.short_description || product.description),
                categories: product.categories.map((c) => c.name),
                image: product.images?.[0]?.src || null,
                stock_status: product.stock_status,
                stock_quantity: product.stock_quantity,
                on_sale: product.on_sale,
                featured: product.featured,
                rating: product.average_rating,
                rating_count: product.rating_count,
            }));
        }
        catch (error) {
            console.error("WooCommerce getProducts error:", error);
            throw error;
        }
    }
    /**
     * Obtiene un producto específico por ID
     */
    async getProductById(productId) {
        try {
            const response = await this.client.get(`/products/${productId}`);
            const product = response.data;
            return {
                id: product.id,
                name: product.name,
                slug: product.slug,
                price: product.price,
                regular_price: product.regular_price,
                sale_price: product.sale_price,
                description: this.stripHtml(product.description),
                short_description: this.stripHtml(product.short_description),
                categories: product.categories,
                images: product.images,
                stock_status: product.stock_status,
                stock_quantity: product.stock_quantity,
                on_sale: product.on_sale,
                featured: product.featured,
                average_rating: product.average_rating,
                rating_count: product.rating_count,
            };
        }
        catch (error) {
            console.error(`WooCommerce getProductById(${productId}) error:`, error);
            return null;
        }
    }
    /**
     * Busca un producto por nombre
     */
    async searchProduct(productName) {
        try {
            const products = await this.getProducts({ search: productName, limit: 1 });
            return products.length > 0 ? products[0] : null;
        }
        catch (error) {
            console.error(`WooCommerce searchProduct(${productName}) error:`, error);
            return null;
        }
    }
    /**
     * Verifica disponibilidad de un producto
     */
    async checkAvailability(productId) {
        try {
            const product = await this.getProductById(productId);
            if (!product)
                return null;
            return {
                available: product.stock_status === "instock",
                stock_quantity: product.stock_quantity,
                stock_status: product.stock_status,
                name: product.name,
            };
        }
        catch (error) {
            console.error(`WooCommerce checkAvailability(${productId}) error:`, error);
            return null;
        }
    }
    /**
     * Obtiene el ID de categoría por su slug
     */
    async getCategoryIdBySlug(slug) {
        try {
            const response = await this.client.get("/products/categories", {
                params: { slug },
            });
            if (response.data.length > 0) {
                return response.data[0].id;
            }
            return null;
        }
        catch (error) {
            console.error(`WooCommerce getCategoryIdBySlug(${slug}) error:`, error);
            return null;
        }
    }
    /**
     * Elimina tags HTML de un string
     */
    stripHtml(html) {
        if (!html)
            return "";
        return html.replace(/<[^>]*>/g, "").trim();
    }
}
exports.WooCommerceAPI = WooCommerceAPI;
//# sourceMappingURL=woocommerce.js.map