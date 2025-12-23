import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { Product, CartItem, ShoppingCart } from '../types/product.types';

interface CartState extends ShoppingCart {
  addItem: (product: Product, quantity?: number) => void;
  removeItem: (productId: string) => void;
  updateQuantity: (productId: string, quantity: number) => void;
  clearCart: () => void;
  calculateTotals: () => void;
}

const TAX_RATE = 0.08; // 8% tax
const SHIPPING_RATE = 10; // $10 flat rate

export const useCart = create<CartState>()(
  persist(
    (set, get) => ({
      items: [],
      subtotal: 0,
      shipping: 0,
      tax: 0,
      total: 0,

      addItem: (product, quantity = 1) => {
        const { items } = get();
        const existingItem = items.find((item) => item.product.id === product.id);

        if (existingItem) {
          set({
            items: items.map((item) =>
              item.product.id === product.id
                ? { ...item, quantity: item.quantity + quantity }
                : item
            ),
          });
        } else {
          set({ items: [...items, { product, quantity }] });
        }
        get().calculateTotals();
      },

      removeItem: (productId) => {
        set({ items: get().items.filter((item) => item.product.id !== productId) });
        get().calculateTotals();
      },

      updateQuantity: (productId, quantity) => {
        if (quantity <= 0) {
          get().removeItem(productId);
          return;
        }
        set({
          items: get().items.map((item) =>
            item.product.id === productId ? { ...item, quantity } : item
          ),
        });
        get().calculateTotals();
      },

      clearCart: () => {
        set({ items: [], subtotal: 0, shipping: 0, tax: 0, total: 0 });
      },

      calculateTotals: () => {
        const { items } = get();
        const subtotal = items.reduce(
          (sum, item) => sum + item.product.price * item.quantity,
          0
        );
        const shipping = items.length > 0 ? SHIPPING_RATE : 0;
        const tax = subtotal * TAX_RATE;
        const total = subtotal + shipping + tax;

        set({ subtotal, shipping, tax, total });
      },
    }),
    {
      name: 'fibroskin-cart',
    }
  )
);
