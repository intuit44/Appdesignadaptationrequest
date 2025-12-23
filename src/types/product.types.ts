export interface Product {
  id: string;
  name: string;
  description?: string;
  price: number;
  originalPrice?: number;
  image: string;
  images?: string[];
  rating: number;
  reviews: number;
  category: string;
  brand?: string;
  inStock?: boolean;
  stockQuantity?: number;
  sku?: string;
  tags?: string[];
  ingredients?: string[];
  features?: string[];
  createdAt?: Date;
  updatedAt?: Date;
}

export interface CartItem {
  product: Product;
  quantity: number;
}

export interface ShoppingCart {
  items: CartItem[];
  subtotal: number;
  shipping: number;
  tax: number;
  total: number;
}

export interface ProductFilter {
  category?: string;
  brand?: string;
  minPrice?: number;
  maxPrice?: number;
  minRating?: number;
  inStock?: boolean;
  tags?: string[];
  sortBy?: 'price-asc' | 'price-desc' | 'rating' | 'newest' | 'popular';
}
