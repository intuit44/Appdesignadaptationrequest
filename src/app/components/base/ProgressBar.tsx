import { cn } from '../ui/utils';

interface ProgressBarProps {
  progress: number;
  variant?: 'primary' | 'secondary';
  size?: 'sm' | 'md' | 'lg';
  showPercentage?: boolean;
  className?: string;
}

export function ProgressBar({
  progress,
  variant = 'primary',
  size = 'md',
  showPercentage = true,
  className,
}: ProgressBarProps) {
  const sizeClasses = {
    sm: 'h-1.5',
    md: 'h-2.5',
    lg: 'h-4',
  };

  const variantClasses = {
    primary: 'gradient-primary',
    secondary: 'gradient-secondary',
  };

  const clampedProgress = Math.min(100, Math.max(0, progress));

  return (
    <div className={cn('w-full', className)}>
      <div className={cn('w-full bg-gray-200 rounded-full overflow-hidden', sizeClasses[size])}>
        <div
          className={cn('h-full transition-all duration-500 ease-out', variantClasses[variant])}
          style={{ width: `${clampedProgress}%` }}
        />
      </div>
      {showPercentage && (
        <div className="mt-1 text-sm font-medium text-gray-600 text-right">
          {clampedProgress.toFixed(0)}%
        </div>
      )}
    </div>
  );
}
