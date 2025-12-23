import { ReactNode } from 'react';
import { cn } from '../ui/utils';

interface GradientCardProps {
  children: ReactNode;
  variant?: 'default' | 'gradient' | 'subtle';
  className?: string;
  hover?: boolean;
}

export function GradientCard({
  children,
  variant = 'default',
  className,
  hover = true,
}: GradientCardProps) {
  const variantClasses = {
    default: 'bg-white border border-gray-100',
    gradient: 'gradient-subtle border-0',
    subtle: 'bg-white/80 backdrop-blur-sm border border-pink-100',
  };

  return (
    <div
      className={cn(
        'rounded-3xl p-6 transition-all duration-300',
        variantClasses[variant],
        hover && 'hover:shadow-xl hover:-translate-y-1',
        className
      )}
    >
      {children}
    </div>
  );
}
