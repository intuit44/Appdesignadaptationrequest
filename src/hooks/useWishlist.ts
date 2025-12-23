import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface WishlistState {
  items: string[];
  addItem: (productId: string) => void;
  removeItem: (productId: string) => void;
  toggleItem: (productId: string) => void;
  isInWishlist: (productId: string) => boolean;
  clearWishlist: () => void;
}

export const useWishlist = create<WishlistState>()(
  persist(
    (set, get) => ({
      items: [],

      addItem: (productId) => {
        const { items } = get();
        if (!items.includes(productId)) {
          set({ items: [...items, productId] });
        }
      },

      removeItem: (productId) => {
        set({ items: get().items.filter((id) => id !== productId) });
      },

      toggleItem: (productId) => {
        const { items } = get();
        if (items.includes(productId)) {
          get().removeItem(productId);
        } else {
          get().addItem(productId);
        }
      },

      isInWishlist: (productId) => {
        return get().items.includes(productId);
      },

      clearWishlist: () => {
        set({ items: [] });
      },
    }),
    {
      name: 'fibroskin-wishlist',
    }
  )
);
