import { Course, Product } from '../types';

export const mockCourses: Course[] = [
  {
    id: '1',
    title: 'Micropigmentación Profesional',
    description: 'Domina las técnicas más avanzadas de micropigmentación para cejas, labios y ojos.',
    instructor: 'Dra. María González',
    duration: '8 semanas',
    level: 'Intermedio',
    price: 599,
    thumbnail: 'https://images.unsplash.com/photo-1560869713-7d0a29430803?w=800',
    rating: 4.9,
    students: 1250,
    category: 'Micropigmentación',
    loomUrl: 'https://www.loom.com/share/'
  },
  {
    id: '2',
    title: 'Tratamientos Faciales Avanzados',
    description: 'Aprende los protocolos más efectivos de tratamientos faciales anti-edad y rejuvenecimiento.',
    instructor: 'Lic. Ana Martínez',
    duration: '6 semanas',
    level: 'Principiante',
    price: 449,
    thumbnail: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=800',
    rating: 4.8,
    students: 890,
    category: 'Tratamientos Faciales',
    loomUrl: 'https://www.loom.com/share/'
  },
  {
    id: '3',
    title: 'Fibroblast Plasma: Técnica Completa',
    description: 'Conviértete en experto en Fibroblast Plasma para lifting sin cirugía y rejuvenecimiento.',
    instructor: 'Dra. Laura Rodríguez',
    duration: '10 semanas',
    level: 'Avanzado',
    price: 799,
    thumbnail: 'https://images.unsplash.com/photo-1552693673-1bf958298935?w=800',
    rating: 5.0,
    students: 650,
    category: 'Fibroblast',
    loomUrl: 'https://www.loom.com/share/'
  },
  {
    id: '4',
    title: 'Maquillaje Permanente Profesional',
    description: 'Técnicas avanzadas de maquillaje permanente y semi-permanente para resultados naturales.',
    instructor: 'Est. Carolina Pérez',
    duration: '8 semanas',
    level: 'Intermedio',
    price: 549,
    thumbnail: 'https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?w=800',
    rating: 4.7,
    students: 1100,
    category: 'Maquillaje Permanente'
  },
  {
    id: '5',
    title: 'Depilación Láser Certificada',
    description: 'Domina las técnicas y protocolos de depilación láser para diferentes tipos de piel.',
    instructor: 'Dr. Roberto Sánchez',
    duration: '5 semanas',
    level: 'Principiante',
    price: 399,
    thumbnail: 'https://images.unsplash.com/photo-1516975080664-ed2fc6a32937?w=800',
    rating: 4.6,
    students: 720,
    category: 'Depilación'
  },
  {
    id: '6',
    title: 'Masaje Relajante y Terapéutico',
    description: 'Aprende técnicas de masaje profesional para bienestar y relajación profunda.',
    instructor: 'Ter. Isabel Torres',
    duration: '4 semanas',
    level: 'Principiante',
    price: 299,
    thumbnail: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=800',
    rating: 4.9,
    students: 1450,
    category: 'Masajes'
  }
];

export const mockProducts: Product[] = [
  {
    id: '1',
    name: 'Suero Ácido Hialurónico Premium',
    description: 'Suero concentrado de ácido hialurónico de triple peso molecular para hidratación profunda.',
    price: 89.99,
    category: 'Productos',
    image: 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=800',
    brand: 'FibroSkin Professional',
    stock: 45,
    rating: 4.8,
    featured: true
  },
  {
    id: '2',
    name: 'Máquina Fibroblast Plasma Pro',
    description: 'Equipo profesional de última generación para tratamientos de lifting sin cirugía.',
    price: 2499.99,
    category: 'Equipos',
    image: 'https://images.unsplash.com/photo-1612817288484-6f916006741a?w=800',
    brand: 'MediBeauty',
    stock: 8,
    rating: 5.0,
    featured: true
  },
  {
    id: '3',
    name: 'Kit Micropigmentación Completo',
    description: 'Set profesional con dermógrafo, agujas, pigmentos y accesorios para micropigmentación.',
    price: 599.99,
    category: 'Supplies',
    image: 'https://images.unsplash.com/photo-1583241800698-b7b60503eeec?w=800',
    brand: 'BeautyTech Pro',
    stock: 15,
    rating: 4.9,
    featured: true
  },
  {
    id: '4',
    name: 'Crema Reafirmante Facial',
    description: 'Fórmula avanzada con péptidos y colágeno para reafirmar y tensar la piel.',
    price: 69.99,
    category: 'Productos',
    image: 'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=800',
    brand: 'DermaLux',
    stock: 60,
    rating: 4.7,
    featured: false
  },
  {
    id: '5',
    name: 'Lámpara LED Fotobiomodulación',
    description: 'Sistema profesional de luz LED para tratamientos faciales anti-edad y cicatrización.',
    price: 1899.99,
    category: 'Equipos',
    image: 'https://images.unsplash.com/photo-1570554886111-e80fcca6a029?w=800',
    brand: 'LightTherapy Pro',
    stock: 5,
    rating: 4.8,
    featured: false
  },
  {
    id: '6',
    name: 'Set Masaje Profesional',
    description: 'Kit completo de aceites, piedras calientes y herramientas para masaje terapéutico.',
    price: 149.99,
    category: 'Supplies',
    image: 'https://images.unsplash.com/photo-1600334129128-685c5582fd35?w=800',
    brand: 'Spa Essentials',
    stock: 30,
    rating: 4.6,
    featured: false
  },
  {
    id: '7',
    name: 'Peeling Químico Profesional',
    description: 'Solución de ácido glicólico al 70% para tratamientos profesionales de renovación cutánea.',
    price: 129.99,
    category: 'Productos',
    image: 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=800',
    brand: 'ChemPeel Pro',
    stock: 25,
    rating: 4.9,
    featured: true
  },
  {
    id: '8',
    name: 'Dermapen Microneedling',
    description: 'Dispositivo de microneedling automático para tratamientos de rejuvenecimiento y cicatrices.',
    price: 899.99,
    category: 'Equipos',
    image: 'https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?w=800',
    brand: 'MicroDerm Tech',
    stock: 12,
    rating: 5.0,
    featured: true
  }
];
