import { useState } from 'react';
import { ProductCard } from '../components/product/ProductCard';
import { SearchBar } from '../components/base/SearchBar';
import { CategoryChip } from '../components/base/CategoryChip';
import { Filter, SlidersHorizontal } from 'lucide-react';
import { toast } from 'sonner';
import { useSearch } from '../../hooks/useSearch';
import { Product } from '../../types/product.types';

export default function Products() {
  const [selectedCategory, setSelectedCategory] = useState('all');
  const [showFilters, setShowFilters] = useState(false);

  // Mock products data
  const allProducts: Product[] = [
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
      description: 'Hidratación profunda con ácido hialurónico de bajo y alto peso molecular',
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
      description: 'Kit completo con todo lo necesario para microblading profesional',
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
      description: '12 tonos nude esenciales con acabados mate y shimmer',
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
      description: 'Fórmula avanzada con retinol para reducir líneas y arrugas',
    },
    {
      id: '5',
      name: 'Base de Maquillaje HD Pro',
      price: 44.99,
      image: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=800&h=800&fit=crop',
      rating: 4.6,
      reviews: 2341,
      category: 'Makeup',
      brand: 'Make Up For Ever',
      inStock: true,
      description: 'Cobertura media-alta con acabado natural y larga duración',
    },
    {
      id: '6',
      name: 'Aceite Facial de Rosa Mosqueta',
      price: 34.99,
      originalPrice: 49.99,
      image: 'https://images.unsplash.com/photo-1608248597279-f99d160bfcbc?w=800&h=800&fit=crop',
      rating: 4.8,
      reviews: 876,
      category: 'Skincare',
      brand: 'Pai Skincare',
      inStock: true,
      description: '100% orgánico, regenerador y nutritivo para todo tipo de piel',
    },
    {
      id: '7',
      name: 'Kit de Brochas Profesional 12 pzs',
      price: 159.99,
      image: 'https://images.unsplash.com/photo-1596704017254-9b121068ec31?w=800&h=800&fit=crop',
      rating: 4.9,
      reviews: 445,
      category: 'Herramientas',
      brand: 'Morphe',
      inStock: true,
      description: 'Set completo de brochas premium con cerdas sintéticas',
    },
    {
      id: '8',
      name: 'Máscara de Pestañas Volumizadora',
      price: 28.99,
      image: 'https://images.unsplash.com/photo-1631214524020-7e18db7f27d4?w=800&h=800&fit=crop',
      rating: 4.5,
      reviews: 3421,
      category: 'Makeup',
      brand: 'Benefit',
      inStock: true,
      description: 'Volumen extremo sin grumos, resistente al agua',
    },
  ];

  const categories = [
    { id: 'all', label: 'Todos', icon: '✨' },
    { id: 'Skincare', label: 'Skincare', icon: '💧' },
    { id: 'Makeup', label: 'Makeup', icon: '💄' },
    { id: 'Herramientas', label: 'Herramientas', icon: '🛠️' },
  ];

  const { query, setQuery, filteredItems } = useSearch(allProducts, ['name', 'brand', 'category']);

  const displayProducts = selectedCategory === 'all'
    ? filteredItems
    : filteredItems.filter(p => p.category === selectedCategory);

  const handleAddToCart = (productId: string) => {
    toast.success('Producto agregado al carrito');
  };

  const handleToggleFavorite = (productId: string) => {
    toast.info('Agregado a favoritos');
  };

  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="relative py-16 gradient-subtle border-b border-gray-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-8">
            <h1 className="gradient-text mb-4">Productos Profesionales</h1>
            <p className="text-gray-600 text-lg max-w-2xl mx-auto">
              Encuentra los mejores productos de belleza profesional de marcas líderes mundiales
            </p>
          </div>

          {/* Search Bar */}
          <div className="max-w-2xl mx-auto">
            <SearchBar
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder="Buscar productos, marcas, categorías..."
            />
          </div>

          {/* Stats */}
          <div className="grid grid-cols-3 gap-6 mt-12 max-w-3xl mx-auto">
            <div className="text-center">
              <div className="text-3xl font-bold gradient-text">500+</div>
              <div className="text-sm text-gray-600">Productos</div>
            </div>
            <div className="text-center">
              <div className="text-3xl font-bold gradient-text">50+</div>
              <div className="text-sm text-gray-600">Marcas Premium</div>
            </div>
            <div className="text-center">
              <div className="text-3xl font-bold gradient-text">4.8★</div>
              <div className="text-sm text-gray-600">Valoración</div>
            </div>
          </div>
        </div>
      </section>

      {/* Filters Section */}
      <section className="py-6 bg-white border-b border-gray-100 sticky top-16 z-40 backdrop-blur-lg bg-white/95">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between mb-4">
            <h2 className="font-semibold text-gray-900">Categorías</h2>
            <button
              onClick={() => setShowFilters(!showFilters)}
              className="flex items-center gap-2 px-4 py-2 text-sm font-medium text-gray-700 bg-gray-100 rounded-xl hover:bg-gray-200 transition-colors lg:hidden"
            >
              <SlidersHorizontal className="h-4 w-4" />
              Filtros
            </button>
          </div>
          
          <div className="flex items-center gap-3 overflow-x-auto pb-2 scrollbar-hide">
            {categories.map((category) => (
              <CategoryChip
                key={category.id}
                label={category.label}
                icon={category.icon}
                active={selectedCategory === category.id}
                onClick={() => setSelectedCategory(category.id)}
              />
            ))}
          </div>
        </div>
      </section>

      {/* Products Grid */}
      <section className="py-12 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between mb-8">
            <p className="text-gray-600">
              Mostrando <span className="font-semibold">{displayProducts.length}</span> productos
            </p>
            <select className="px-4 py-2 bg-gray-100 border-0 rounded-xl text-sm font-medium text-gray-700 focus:ring-2 focus:ring-pink-300">
              <option>Más Populares</option>
              <option>Precio: Menor a Mayor</option>
              <option>Precio: Mayor a Menor</option>
              <option>Mejor Valorados</option>
              <option>Más Recientes</option>
            </select>
          </div>

          {displayProducts.length > 0 ? (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
              {displayProducts.map((product) => (
                <ProductCard
                  key={product.id}
                  {...product}
                  onAddToCart={handleAddToCart}
                  onToggleFavorite={handleToggleFavorite}
                />
              ))}
            </div>
          ) : (
            <div className="text-center py-20">
              <div className="w-24 h-24 mx-auto mb-6 gradient-subtle rounded-full flex items-center justify-center">
                <Filter className="h-12 w-12 text-pink-400" />
              </div>
              <h3 className="font-semibold text-gray-900 mb-2">No se encontraron productos</h3>
              <p className="text-gray-600 mb-6">
                Intenta ajustar tus filtros o búsqueda
              </p>
              <button
                onClick={() => {
                  setQuery('');
                  setSelectedCategory('all');
                }}
                className="px-6 py-3 gradient-primary text-white rounded-xl hover:scale-105 transition-transform"
              >
                Limpiar Filtros
              </button>
            </div>
          )}
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-16 gradient-subtle border-t border-gray-100">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="font-bold text-gray-900 mb-4">
            ¿Necesitas Asesoría Personalizada?
          </h2>
          <p className="text-gray-600 mb-8 text-lg max-w-2xl mx-auto">
            Nuestro equipo de expertos está listo para ayudarte a encontrar los productos perfectos para tu negocio o práctica profesional.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <a
              href="#"
              className="px-8 py-4 gradient-primary text-white rounded-2xl font-semibold hover:scale-105 transition-transform shadow-glow"
            >
              Contactar Asesor
            </a>
            <a
              href="/courses"
              className="px-8 py-4 bg-white text-pink-500 border-2 border-pink-200 rounded-2xl font-semibold hover:border-pink-300 transition-colors"
            >
              Ver Cursos Relacionados
            </a>
          </div>
        </div>
      </section>

      <style>{`
        .scrollbar-hide::-webkit-scrollbar {
          display: none;
        }
        .scrollbar-hide {
          -ms-overflow-style: none;
          scrollbar-width: none;
        }
      `}</style>
    </div>
  );
}