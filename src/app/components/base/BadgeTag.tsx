import { cn } from '../ui/utils';

interface BadgeTagProps {
  label: string;
  variant?: 'default' | 'primary' | 'success' | 'warning' | 'info';
  size?: 'sm' | 'md';
  className?: string;
}

export function BadgeTag({ label, variant = 'default', size = 'md', className }: BadgeTagProps) {
  const sizeClasses = {
    sm: 'px-2 py-0.5 text-xs',
    md: 'px-3 py-1 text-sm',
  };

  const variantClasses = {
    default: 'bg-gray-100 text-gray-700',
    primary: 'gradient-primary text-white',
    success: 'bg-green-100 text-green-700',
    warning: 'bg-amber-100 text-amber-700',
    info: 'bg-blue-100 text-blue-700',
  };

  return (
    <span
      className={cn(
        'inline-flex items-center font-medium rounded-full',
        sizeClasses[size],
        variantClasses[variant],
        className
      )}
    >
      {label}
    </span>
  );
}
