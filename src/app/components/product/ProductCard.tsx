import { Heart, ShoppingCart } from 'lucide-react';
import { useState } from 'react';
import { GradientCard } from '../base/GradientCard';
import { RatingStars } from '../base/RatingStars';
import { BadgeTag } from '../base/BadgeTag';
import { ImageWithFallback } from '../figma/ImageWithFallback';
import { cn } from '../ui/utils';

interface ProductCardProps {
  id: string;
  name: string;
  price: number;
  originalPrice?: number;
  image: string;
  rating: number;
  reviews: number;
  category: string;
  brand?: string;
  inStock?: boolean;
  onAddToCart?: (id: string) => void;
  onToggleFavorite?: (id: string) => void;
}

export function ProductCard({
  id,
  name,
  price,
  originalPrice,
  image,
  rating,
  reviews,
  category,
  brand,
  inStock = true,
  onAddToCart,
  onToggleFavorite,
}: ProductCardProps) {
  const [isFavorite, setIsFavorite] = useState(false);
  const [imageLoaded, setImageLoaded] = useState(false);

  const handleToggleFavorite = (e: React.MouseEvent) => {
    e.stopPropagation();
    setIsFavorite(!isFavorite);
    onToggleFavorite?.(id);
  };

  const handleAddToCart = (e: React.MouseEvent) => {
    e.stopPropagation();
    onAddToCart?.(id);
  };

  const discount = originalPrice ? Math.round(((originalPrice - price) / originalPrice) * 100) : 0;

  return (
    <GradientCard className="group relative overflow-hidden">
      {/* Favorite Button */}
      <button
        onClick={handleToggleFavorite}
        className="absolute top-4 right-4 z-10 p-2 bg-white/90 backdrop-blur-sm rounded-full shadow-md hover:scale-110 transition-transform"
      >
        <Heart
          className={cn(
            'h-5 w-5 transition-colors',
            isFavorite ? 'fill-pink-500 text-pink-500' : 'text-gray-400'
          )}
        />
      </button>

      {/* Badges */}
      <div className="absolute top-4 left-4 z-10 flex flex-col gap-2">
        {discount > 0 && <BadgeTag label={`-${discount}%`} variant="warning" size="sm" />}
        {!inStock && <BadgeTag label="Agotado" variant="default" size="sm" />}
      </div>

      {/* Product Image */}
      <div className="relative aspect-square mb-4 rounded-2xl overflow-hidden bg-gray-100">
        {!imageLoaded && (
          <div className="absolute inset-0 animate-pulse bg-gray-200" />
        )}
        <ImageWithFallback
          src={image}
          alt={name}
          className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
          onLoad={() => setImageLoaded(true)}
        />
      </div>

      {/* Product Info */}
      <div className="space-y-2">
        {brand && <p className="text-xs font-medium text-pink-500 uppercase tracking-wide">{brand}</p>}
        
        <h3 className="font-semibold text-gray-900 line-clamp-2 min-h-[3rem]">{name}</h3>
        
        <div className="flex items-center gap-2">
          <BadgeTag label={category} variant="default" size="sm" />
        </div>

        <RatingStars rating={rating} size="sm" showNumber={false} />
        <p className="text-xs text-gray-500">{reviews} reseñas</p>

        {/* Price and Add to Cart */}
        <div className="flex items-center justify-between pt-2">
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold gradient-text">${price.toFixed(2)}</span>
            {originalPrice && (
              <span className="text-sm text-gray-400 line-through">${originalPrice.toFixed(2)}</span>
            )}
          </div>
          
          <button
            onClick={handleAddToCart}
            disabled={!inStock}
            className={cn(
              'p-2 rounded-xl transition-all',
              inStock
                ? 'gradient-primary text-white hover:scale-110 shadow-glow'
                : 'bg-gray-200 text-gray-400 cursor-not-allowed'
            )}
          >
            <ShoppingCart className="h-5 w-5" />
          </button>
        </div>
      </div>
    </GradientCard>
  );
}
