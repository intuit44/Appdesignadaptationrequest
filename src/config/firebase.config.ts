/**
 * FibroSkin Beauty Academy - Firebase Configuration
 * 
 * Instrucciones:
 * 1. Crea un proyecto en Firebase Console (https://console.firebase.google.com)
 * 2. Activa Authentication con Email/Password y Sign in with Apple
 * 3. Crea una base de datos Firestore
 * 4. Activa Firebase Storage
 * 5. Copia las credenciales aquí o usa variables de entorno
 */

export const firebaseConfig = {
  // TODO: Reemplazar con tus credenciales de Firebase
  apiKey: import.meta.env.VITE_FIREBASE_API_KEY || "YOUR_API_KEY",
  authDomain: import.meta.env.VITE_FIREBASE_AUTH_DOMAIN || "fibroskin-beauty-academy.firebaseapp.com",
  projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID || "fibroskin-beauty-academy",
  storageBucket: import.meta.env.VITE_FIREBASE_STORAGE_BUCKET || "fibroskin-beauty-academy.appspot.com",
  messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID || "YOUR_SENDER_ID",
  appId: import.meta.env.VITE_FIREBASE_APP_ID || "YOUR_APP_ID",
  measurementId: import.meta.env.VITE_FIREBASE_MEASUREMENT_ID || "YOUR_MEASUREMENT_ID",
};

/**
 * Apple Sign In Configuration
 * 
 * Instrucciones:
 * 1. Crea un Service ID en Apple Developer Console
 * 2. Configura el redirect URL en Apple
 * 3. Descarga la private key
 */
export const appleSignInConfig = {
  clientId: import.meta.env.VITE_APPLE_CLIENT_ID || "com.fibroskin.beautyacademy.signin",
  redirectURL: import.meta.env.VITE_APPLE_REDIRECT_URL || "https://fibroskin-beauty-academy.firebaseapp.com/__/auth/handler",
  scope: ['email', 'fullName'],
};

/**
 * Firestore Collections
 */
export const COLLECTIONS = {
  USERS: 'users',
  COURSES: 'courses',
  PRODUCTS: 'products',
  ORDERS: 'orders',
  REVIEWS: 'reviews',
  ENROLLMENTS: 'enrollments',
  PROGRESS: 'progress',
} as const;

/**
 * Storage Paths
 */
export const STORAGE_PATHS = {
  COURSE_THUMBNAILS: 'courses/thumbnails',
  COURSE_VIDEOS: 'courses/videos',
  PRODUCT_IMAGES: 'products/images',
  USER_AVATARS: 'users/avatars',
  CERTIFICATES: 'certificates',
} as const;
