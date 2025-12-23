export interface Course {
  id: string;
  title: string;
  description: string;
  instructor: string;
  duration: string;
  level: 'Principiante' | 'Intermedio' | 'Avanzado';
  price: number;
  thumbnail: string;
  rating: number;
  students: number;
  category: string;
  loomUrl?: string;
}

export interface Product {
  id: string;
  name: string;
  description: string;
  price: number;
  category: 'Productos' | 'Supplies' | 'Equipos';
  image: string;
  brand: string;
  stock: number;
  rating: number;
  featured: boolean;
}

export interface User {
  id: string;
  email: string;
  name: string;
  photoURL?: string;
  enrolledCourses: string[];
  purchasedProducts: string[];
}
