import { Sparkles, Palette, Scissors, Heart } from 'lucide-react';
import { CategoryChip } from '../base/CategoryChip';
import { useState } from 'react';

const categories = [
  { id: 'all', label: 'Todos', icon: '✨' },
  { id: 'skincare', label: 'Cuidado de la Piel', icon: '💧' },
  { id: 'makeup', label: 'Maquillaje', icon: '💄' },
  { id: 'hair', label: 'Cabello', icon: '💇' },
  { id: 'nails', label: 'Uñas', icon: '💅' },
  { id: 'spa', label: 'Spa & Wellness', icon: '🧖' },
];

interface CategorySectionProps {
  onCategoryChange?: (categoryId: string) => void;
}

export function CategorySection({ onCategoryChange }: CategorySectionProps) {
  const [activeCategory, setActiveCategory] = useState('all');

  const handleCategoryClick = (categoryId: string) => {
    setActiveCategory(categoryId);
    onCategoryChange?.(categoryId);
  };

  return (
    <section className="py-8 border-b border-gray-100">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center gap-2 mb-6">
          <Sparkles className="h-5 w-5 text-pink-500" />
          <h2 className="font-bold text-gray-900">Categorías</h2>
        </div>
        
        <div className="flex items-center gap-3 overflow-x-auto pb-2 scrollbar-hide">
          {categories.map((category) => (
            <CategoryChip
              key={category.id}
              label={category.label}
              icon={category.icon}
              active={activeCategory === category.id}
              onClick={() => handleCategoryClick(category.id)}
            />
          ))}
        </div>
      </div>

      <style>{`
        .scrollbar-hide::-webkit-scrollbar {
          display: none;
        }
        .scrollbar-hide {
          -ms-overflow-style: none;
          scrollbar-width: none;
        }
      `}</style>
    </section>
  );
}
