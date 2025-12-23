import { ButtonHTMLAttributes, ReactNode } from 'react';
import { cn } from '../ui/utils';

interface GradientButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'accent';
  size?: 'sm' | 'md' | 'lg';
  children: ReactNode;
  isLoading?: boolean;
}

export function GradientButton({
  variant = 'primary',
  size = 'md',
  children,
  className,
  isLoading = false,
  disabled,
  ...props
}: GradientButtonProps) {
  const sizeClasses = {
    sm: 'px-4 py-2 text-sm',
    md: 'px-6 py-3 text-base',
    lg: 'px-8 py-4 text-lg',
  };

  const variantClasses = {
    primary: 'gradient-primary text-white shadow-glow',
    secondary: 'gradient-secondary text-white shadow-glow',
    accent: 'gradient-accent text-white shadow-glow',
  };

  return (
    <button
      className={cn(
        'rounded-2xl font-semibold transition-all duration-300 hover:scale-105 active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:scale-100',
        sizeClasses[size],
        variantClasses[variant],
        className
      )}
      disabled={disabled || isLoading}
      {...props}
    >
      {isLoading ? (
        <span className="flex items-center justify-center gap-2">
          <svg className="animate-spin h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
            <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          <span>Cargando...</span>
        </span>
      ) : (
        children
      )}
    </button>
  );
}
