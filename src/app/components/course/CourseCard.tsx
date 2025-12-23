import { Clock, Users, BookOpen, PlayCircle } from 'lucide-react';
import { useState } from 'react';
import { GradientCard } from '../base/GradientCard';
import { RatingStars } from '../base/RatingStars';
import { BadgeTag } from '../base/BadgeTag';
import { ProgressBar } from '../base/ProgressBar';
import { ImageWithFallback } from '../figma/ImageWithFallback';

interface CourseCardProps {
  id: string;
  title: string;
  instructor: string;
  instructorImage?: string;
  thumbnail: string;
  duration: string;
  students: number;
  lessons: number;
  rating: number;
  reviews: number;
  price?: number;
  level: 'Principiante' | 'Intermedio' | 'Avanzado';
  category: string;
  progress?: number;
  isEnrolled?: boolean;
  onEnroll?: (id: string) => void;
  onContinue?: (id: string) => void;
}

export function CourseCard({
  id,
  title,
  instructor,
  instructorImage,
  thumbnail,
  duration,
  students,
  lessons,
  rating,
  reviews,
  price,
  level,
  category,
  progress,
  isEnrolled = false,
  onEnroll,
  onContinue,
}: CourseCardProps) {
  const [imageLoaded, setImageLoaded] = useState(false);

  const levelColors = {
    Principiante: 'success' as const,
    Intermedio: 'warning' as const,
    Avanzado: 'info' as const,
  };

  return (
    <GradientCard className="group overflow-hidden">
      {/* Course Thumbnail */}
      <div className="relative aspect-video mb-4 rounded-2xl overflow-hidden bg-gray-100">
        {!imageLoaded && (
          <div className="absolute inset-0 animate-pulse bg-gray-200" />
        )}
        <ImageWithFallback
          src={thumbnail}
          alt={title}
          className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
          onLoad={() => setImageLoaded(true)}
        />
        
        {/* Play Button Overlay */}
        <div className="absolute inset-0 bg-black/30 opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex items-center justify-center">
          <PlayCircle className="h-16 w-16 text-white drop-shadow-lg" />
        </div>

        {/* Badges */}
        <div className="absolute top-3 left-3 flex gap-2">
          <BadgeTag label={category} variant="primary" size="sm" />
          <BadgeTag label={level} variant={levelColors[level]} size="sm" />
        </div>
      </div>

      {/* Course Info */}
      <div className="space-y-3">
        <h3 className="font-bold text-gray-900 line-clamp-2 min-h-[3.5rem]">{title}</h3>

        {/* Instructor */}
        <div className="flex items-center gap-2">
          {instructorImage ? (
            <img
              src={instructorImage}
              alt={instructor}
              className="w-8 h-8 rounded-full object-cover"
            />
          ) : (
            <div className="w-8 h-8 rounded-full gradient-primary flex items-center justify-center text-white text-xs font-bold">
              {instructor.charAt(0)}
            </div>
          )}
          <span className="text-sm text-gray-600">{instructor}</span>
        </div>

        {/* Stats */}
        <div className="flex items-center gap-4 text-sm text-gray-500">
          <div className="flex items-center gap-1">
            <Clock className="h-4 w-4" />
            <span>{duration}</span>
          </div>
          <div className="flex items-center gap-1">
            <BookOpen className="h-4 w-4" />
            <span>{lessons} lecciones</span>
          </div>
          <div className="flex items-center gap-1">
            <Users className="h-4 w-4" />
            <span>{students.toLocaleString()}</span>
          </div>
        </div>

        <RatingStars rating={rating} size="sm" showNumber={false} />
        <p className="text-xs text-gray-500">{reviews} reseñas</p>

        {/* Progress Bar for Enrolled Courses */}
        {isEnrolled && progress !== undefined && (
          <ProgressBar progress={progress} size="sm" showPercentage={true} />
        )}

        {/* Price and Action */}
        <div className="flex items-center justify-between pt-2 border-t border-gray-100">
          {price !== undefined ? (
            <span className="text-2xl font-bold gradient-text">${price.toFixed(2)}</span>
          ) : (
            <span className="text-2xl font-bold gradient-text">Gratis</span>
          )}
          
          {isEnrolled ? (
            <button
              onClick={() => onContinue?.(id)}
              className="px-4 py-2 gradient-primary text-white rounded-xl hover:scale-105 transition-transform shadow-glow"
            >
              Continuar
            </button>
          ) : (
            <button
              onClick={() => onEnroll?.(id)}
              className="px-4 py-2 gradient-primary text-white rounded-xl hover:scale-105 transition-transform shadow-glow"
            >
              Inscribirse
            </button>
          )}
        </div>
      </div>
    </GradientCard>
  );
}
