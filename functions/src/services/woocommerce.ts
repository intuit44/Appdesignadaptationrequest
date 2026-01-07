/**
 * Servicio para conectar con WooCommerce REST API
 * Obtiene productos, categorías, stock, etc.
 */

import axios, { AxiosInstance } from "axios";

interface WooCommerceConfig {
  url: string;
  consumerKey: string;
  consumerSecret: string;
}

interface Product {
  id: number;
  name: string;
  slug: string;
  price: string;
  regular_price: string;
  sale_price: string;
  description: string;
  short_description: string;
  categories: Array<{ id: number; name: string; slug: string }>;
  images: Array<{ id: number; src: string; alt: string }>;
  stock_status: string;
  stock_quantity: number | null;
  on_sale: boolean;
  featured: boolean;
  average_rating: string;
  rating_count: number;
}

interface GetProductsParams {
  category?: string;
  search?: string;
  limit?: number;
  featured?: boolean;
  on_sale?: boolean;
}

export class WooCommerceAPI {
  private client: AxiosInstance;
  private config: WooCommerceConfig;

  constructor() {
    // Usar los MISMOS nombres de variables que el .env principal
    this.config = {
      url: process.env.WC_BASE_URL || "https://fibroacademyusa.com",
      consumerKey: process.env.WC_CONSUMER_KEY || "",
      consumerSecret: process.env.WC_CONSUMER_SECRET || "",
    };

    this.client = axios.create({
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
  async getProducts(params: GetProductsParams): Promise<Product[]> {
    try {
      const queryParams: Record<string, unknown> = {
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

      return response.data.map((product: Product) => ({
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
    } catch (error) {
      console.error("WooCommerce getProducts error:", error);
      throw error;
    }
  }

  /**
   * Obtiene un producto específico por ID
   */
  async getProductById(productId: number): Promise<Product | null> {
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
    } catch (error) {
      console.error(`WooCommerce getProductById(${productId}) error:`, error);
      return null;
    }
  }

  /**
   * Busca un producto por nombre
   */
  async searchProduct(productName: string): Promise<Product | null> {
    try {
      const products = await this.getProducts({ search: productName, limit: 1 });
      return products.length > 0 ? products[0] : null;
    } catch (error) {
      console.error(`WooCommerce searchProduct(${productName}) error:`, error);
      return null;
    }
  }

  /**
   * Verifica disponibilidad de un producto
   */
  async checkAvailability(productId: number): Promise<{
    available: boolean;
    stock_quantity: number | null;
    stock_status: string;
    name: string;
  } | null> {
    try {
      const product = await this.getProductById(productId);
      if (!product) return null;

      return {
        available: product.stock_status === "instock",
        stock_quantity: product.stock_quantity,
        stock_status: product.stock_status,
        name: product.name,
      };
    } catch (error) {
      console.error(`WooCommerce checkAvailability(${productId}) error:`, error);
      return null;
    }
  }

  /**
   * Obtiene categorías de productos
   */
  async getCategories(parent?: number): Promise<Array<{
    id: number;
    name: string;
    slug: string;
    count: number;
    image: string | null;
  }>> {
    try {
      const params: Record<string, unknown> = {
        per_page: 100,
        hide_empty: true,
      };

      if (parent !== undefined) {
        params.parent = parent;
      }

      const response = await this.client.get("/products/categories", { params });

      return response.data.map((cat: {
        id: number;
        name: string;
        slug: string;
        count: number;
        image?: { src: string };
      }) => ({
        id: cat.id,
        name: cat.name,
        slug: cat.slug,
        count: cat.count,
        image: cat.image?.src || null,
      }));
    } catch (error) {
      console.error("WooCommerce getCategories error:", error);
      return [];
    }
  }

  /**
   * Obtiene órdenes de un cliente
   */
  async getOrders(customerId: number, page = 1, limit = 10): Promise<Array<{
    id: number;
    status: string;
    total: string;
    currency: string;
    dateCreated: string;
    lineItems: Array<{ name: string; quantity: number; total: string }>;
  }>> {
    try {
      const response = await this.client.get("/orders", {
        params: {
          customer: customerId,
          page,
          per_page: limit,
          orderby: "date",
          order: "desc",
        },
      });

      return response.data.map((order: {
        id: number;
        status: string;
        total: string;
        currency: string;
        date_created: string;
        line_items: Array<{ name: string; quantity: number; total: string }>;
      }) => ({
        id: order.id,
        status: order.status,
        total: order.total,
        currency: order.currency,
        dateCreated: order.date_created,
        lineItems: order.line_items.map((item) => ({
          name: item.name,
          quantity: item.quantity,
          total: item.total,
        })),
      }));
    } catch (error) {
      console.error("WooCommerce getOrders error:", error);
      return [];
    }
  }

  /**
   * Crea una nueva orden
   */
  async createOrder(data: {
    customerId?: number;
    lineItems: Array<{
      productId: number;
      quantity: number;
      variationId?: number;
    }>;
    billing?: Record<string, string>;
    shipping?: Record<string, string>;
  }): Promise<{ id: number; status: string; total: string } | null> {
    try {
      const orderData: Record<string, unknown> = {
        payment_method: "cod",
        payment_method_title: "Pago en la app",
        set_paid: false,
        line_items: data.lineItems.map((item) => ({
          product_id: item.productId,
          quantity: item.quantity,
          ...(item.variationId && { variation_id: item.variationId }),
        })),
      };

      if (data.customerId) {
        orderData.customer_id = data.customerId;
      }

      if (data.billing) {
        orderData.billing = data.billing;
      }

      if (data.shipping) {
        orderData.shipping = data.shipping;
      }

      const response = await this.client.post("/orders", orderData);

      return {
        id: response.data.id,
        status: response.data.status,
        total: response.data.total,
      };
    } catch (error) {
      console.error("WooCommerce createOrder error:", error);
      return null;
    }
  }

  /**
   * Busca cliente por email
   */
  async getCustomerByEmail(email: string): Promise<{
    id: number;
    email: string;
    firstName: string;
    lastName: string;
  } | null> {
    try {
      const response = await this.client.get("/customers", {
        params: { email },
      });

      if (response.data.length > 0) {
        const customer = response.data[0];
        return {
          id: customer.id,
          email: customer.email,
          firstName: customer.first_name,
          lastName: customer.last_name,
        };
      }
      return null;
    } catch (error) {
      console.error("WooCommerce getCustomerByEmail error:", error);
      return null;
    }
  }

  /**
   * Crea un nuevo cliente
   */
  async createCustomer(data: {
    email: string;
    firstName: string;
    lastName: string;
    billing?: Record<string, string>;
  }): Promise<{
    id: number;
    email: string;
    firstName: string;
    lastName: string;
  } | null> {
    try {
      const response = await this.client.post("/customers", {
        email: data.email,
        first_name: data.firstName,
        last_name: data.lastName,
        billing: data.billing || {},
      });

      return {
        id: response.data.id,
        email: response.data.email,
        firstName: response.data.first_name,
        lastName: response.data.last_name,
      };
    } catch (error) {
      console.error("WooCommerce createCustomer error:", error);
      return null;
    }
  }

  /**
   * Obtiene el ID de categoría por su slug
   */
  private async getCategoryIdBySlug(slug: string): Promise<number | null> {
    try {
      const response = await this.client.get("/products/categories", {
        params: { slug },
      });

      if (response.data.length > 0) {
        return response.data[0].id;
      }
      return null;
    } catch (error) {
      console.error(`WooCommerce getCategoryIdBySlug(${slug}) error:`, error);
      return null;
    }
  }

  /**
   * Elimina tags HTML de un string
   */
  private stripHtml(html: string): string {
    if (!html) return "";
    return html.replace(/<[^>]*>/g, "").trim();
  }
}
