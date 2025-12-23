import { create } from 'zustand';
import { 
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  signOut as firebaseSignOut,
  onAuthStateChanged,
  User
} from 'firebase/auth';
import { auth } from '../lib/firebase';

interface AuthState {
  user: User | null;
  loading: boolean;
  setUser: (user: User | null) => void;
  signIn: (email: string, password: string) => Promise<void>;
  signUp: (email: string, password: string) => Promise<void>;
  signOut: () => Promise<void>;
}

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  loading: true,
  
  setUser: (user) => set({ user, loading: false }),
  
  signIn: async (email, password) => {
    await signInWithEmailAndPassword(auth, email, password);
  },
  
  signUp: async (email, password) => {
    await createUserWithEmailAndPassword(auth, email, password);
  },
  
  signOut: async () => {
    await firebaseSignOut(auth);
  },
}));

// Listener para cambios de autenticación
onAuthStateChanged(auth, (user) => {
  useAuthStore.getState().setUser(user);
});
