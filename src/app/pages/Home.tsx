import { useState } from 'react';
import { HeroSection } from '../components/sections/HeroSection';
import { CategorySection } from '../components/sections/CategorySection';
import { CourseCard } from '../components/course/CourseCard';
import { ProductCard } from '../components/product/ProductCard';
import { SearchBar } from '../components/base/SearchBar';
import { Sparkles, TrendingUp } from 'lucide-react';
import { toast } from 'sonner';

export default function Home() {
  const [selectedCategory, setSelectedCategory] = useState('all');

  // Featured Courses Data
  const featuredCourses = [
    {
      id: '1',
      title: 'Técnicas Avanzadas de Microblading',
      instructor: 'María García',
      thumbnail: 'https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?w=800&h=600&fit=crop',
      duration: '8 horas',
      students: 1250,
      lessons: 24,
      rating: 4.9,
      reviews: 342,
      price: 299,
      level: 'Avanzado' as const,
      category: 'Cejas & Pestañas',
    },
    {
      id: '2',
      title: 'Introducción al Cuidado de la Piel',
      instructor: 'Dr. Carlos Ruiz',
      thumbnail: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&h=600&fit=crop',
      duration: '12 horas',
      students: 3420,
      lessons: 36,
      rating: 4.8,
      reviews: 856,
      price: 199,
      level: 'Principiante' as const,
      category: 'Skincare',
    },
    {
      id: '3',
      title: 'Maquillaje Profesional para Eventos',
      instructor: 'Laura Martínez',
      thumbnail: 'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=800&h=600&fit=crop',
      duration: '10 horas',
      students: 2180,
      lessons: 28,
      rating: 4.9,
      reviews: 521,
      price: 249,
      level: 'Intermedio' as const,
      category: 'Maquillaje',
    },
  ];

  // Featured Products Data
  const featuredProducts = [
    {
      id: '1',
      name: 'Sérum de Ácido Hialurónico Premium',
      price: 89.99,
      originalPrice: 129.99,
      image: 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=800&h=800&fit=crop',
      rating: 4.8,
      reviews: 1234,
      category: 'Skincare',
      brand: 'The Ordinary',
      inStock: true,
    },
    {
      id: '2',
      name: 'Kit Profesional de Microblading',
      price: 399.99,
      image: 'https://images.unsplash.com/photo-1596755389378-c31d21fd1273?w=800&h=800&fit=crop',
      rating: 4.9,
      reviews: 567,
      category: 'Herramientas',
      brand: 'FibroSkin Pro',
      inStock: true,
    },
    {
      id: '3',
      name: 'Paleta de Sombras Nude Luxe',
      price: 54.99,
      originalPrice: 79.99,
      image: 'https://images.unsplash.com/photo-1583241800634-efc3b8f14b8c?w=800&h=800&fit=crop',
      rating: 4.7,
      reviews: 892,
      category: 'Makeup',
      brand: 'Urban Decay',
      inStock: true,
    },
    {
      id: '4',
      name: 'Crema Facial Anti-Edad Retinol',
      price: 119.99,
      image: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=800&h=800&fit=crop',
      rating: 4.9,
      reviews: 1567,
      category: 'Skincare',
      brand: 'CeraVe',
      inStock: true,
    },
  ];

  const handleEnroll = (courseId: string) => {
    toast.success('¡Inscripción exitosa! Bienvenida al curso.');
  };

  const handleAddToCart = (productId: string) => {
    toast.success('Producto agregado al carrito');
  };

  const handleToggleFavorite = (productId: string) => {
    toast.info('Agregado a favoritos');
  };

  return (
    <div className="flex flex-col">
      {/* Hero Section */}
      <HeroSection />

      {/* Search Section */}
      <section className="py-8 bg-white border-b border-gray-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <SearchBar placeholder="Busca cursos, productos, categorías..." />
        </div>
      </section>

      {/* Category Section */}
      <CategorySection onCategoryChange={setSelectedCategory} />

      {/* Featured Courses Section */}
      <section className="py-16 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between mb-8">
            <div className="flex items-center gap-3">
              <Sparkles className="h-6 w-6 text-pink-500" />
              <h2 className="font-bold text-gray-900">Cursos Destacados</h2>
            </div>
            <a href="/courses" className="text-pink-500 hover:text-pink-600 font-medium transition-colors">
              Ver todos →
            </a>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {featuredCourses.map((course) => (
              <CourseCard
                key={course.id}
                {...course}
                onEnroll={handleEnroll}
              />
            ))}
          </div>
        </div>
      </section>

      {/* Featured Products Section */}
      <section className="py-16 gradient-subtle">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between mb-8">
            <div className="flex items-center gap-3">
              <TrendingUp className="h-6 w-6 text-pink-500" />
              <h2 className="font-bold text-gray-900">Productos Más Vendidos</h2>
            </div>
            <a href="/products" className="text-pink-500 hover:text-pink-600 font-medium transition-colors">
              Ver todos →
            </a>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {featuredProducts.map((product) => (
              <ProductCard
                key={product.id}
                {...product}
                onAddToCart={handleAddToCart}
                onToggleFavorite={handleToggleFavorite}
              />
            ))}
          </div>
        </div>
      </section>

      {/* Social Proof Section */}
      <section className="py-16 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="font-bold text-gray-900 mb-4">Únete a Nuestra Comunidad</h2>
          <p className="text-gray-600 mb-12 max-w-2xl mx-auto">
            Miles de profesionales de la belleza ya están transformando sus carreras con FibroSkin Academy
          </p>

          <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
            <div className="space-y-2">
              <div className="text-4xl font-bold gradient-text">10K+</div>
              <div className="text-sm text-gray-600">Estudiantes Activos</div>
            </div>
            <div className="space-y-2">
              <div className="text-4xl font-bold gradient-text">50+</div>
              <div className="text-sm text-gray-600">Cursos Profesionales</div>
            </div>
            <div className="space-y-2">
              <div className="text-4xl font-bold gradient-text">500+</div>
              <div className="text-sm text-gray-600">Productos Premium</div>
            </div>
            <div className="space-y-2">
              <div className="text-4xl font-bold gradient-text">4.9★</div>
              <div className="text-sm text-gray-600">Valoración Promedio</div>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="relative overflow-hidden py-20">
        <div className="absolute inset-0 gradient-primary opacity-90" />
        
        {/* Decorative circles */}
        <div className="absolute top-10 right-10 w-64 h-64 bg-white rounded-full opacity-10 blur-3xl" />
        <div className="absolute bottom-10 left-10 w-64 h-64 bg-white rounded-full opacity-10 blur-3xl" />
        
        <div className="relative max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="font-bold text-white mb-4">
            ¿Lista para Comenzar tu Transformación?
          </h2>
          <p className="text-pink-100 mb-8 text-lg max-w-2xl mx-auto">
            Accede a cursos exclusivos, productos profesionales y una comunidad de expertos. 
            Todo lo que necesitas en un solo lugar.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <a
              href="/register"
              className="px-8 py-4 bg-white text-pink-500 rounded-2xl font-semibold hover:scale-105 transition-transform shadow-xl"
            >
              Crear Cuenta Gratis
            </a>
            <a
              href="/courses"
              className="px-8 py-4 bg-white/10 backdrop-blur-sm text-white border-2 border-white rounded-2xl font-semibold hover:bg-white/20 transition-colors"
            >
              Explorar Cursos
            </a>
          </div>
        </div>
      </section>
    </div>
  );
}