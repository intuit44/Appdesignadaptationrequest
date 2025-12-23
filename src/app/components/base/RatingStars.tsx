import { Star } from 'lucide-react';
import { cn } from '../ui/utils';

interface RatingStarsProps {
  rating: number;
  maxRating?: number;
  size?: 'sm' | 'md' | 'lg';
  showNumber?: boolean;
  className?: string;
}

export function RatingStars({
  rating,
  maxRating = 5,
  size = 'md',
  showNumber = true,
  className,
}: RatingStarsProps) {
  const sizeClasses = {
    sm: 'h-3 w-3',
    md: 'h-4 w-4',
    lg: 'h-5 w-5',
  };

  const textSizeClasses = {
    sm: 'text-xs',
    md: 'text-sm',
    lg: 'text-base',
  };

  return (
    <div className={cn('flex items-center gap-1', className)}>
      <div className="flex items-center gap-0.5">
        {Array.from({ length: maxRating }).map((_, index) => {
          const filled = index < Math.floor(rating);
          const partial = index < rating && index >= Math.floor(rating);
          
          return (
            <div key={index} className="relative">
              <Star
                className={cn(
                  sizeClasses[size],
                  filled ? 'fill-yellow-400 text-yellow-400' : 'fill-gray-200 text-gray-200'
                )}
              />
              {partial && (
                <div className="absolute inset-0 overflow-hidden" style={{ width: `${(rating % 1) * 100}%` }}>
                  <Star className={cn(sizeClasses[size], 'fill-yellow-400 text-yellow-400')} />
                </div>
              )}
            </div>
          );
        })}
      </div>
      {showNumber && (
        <span className={cn('font-medium text-gray-700', textSizeClasses[size])}>
          {rating.toFixed(1)}
        </span>
      )}
    </div>
  );
}
