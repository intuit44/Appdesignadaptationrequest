import { cn } from '../ui/utils';

interface CategoryChipProps {
  label: string;
  icon?: string;
  active?: boolean;
  onClick?: () => void;
}

export function CategoryChip({ label, icon, active, onClick }: CategoryChipProps) {
  return (
    <button
      onClick={onClick}
      className={cn(
        'flex items-center gap-2 px-4 py-2 rounded-full transition-all duration-300 whitespace-nowrap',
        active
          ? 'gradient-primary text-white shadow-glow'
          : 'bg-white border border-gray-200 text-gray-700 hover:border-pink-300 hover:text-pink-500'
      )}
    >
      {icon && <span>{icon}</span>}
      <span className="text-sm font-medium">{label}</span>
    </button>
  );
}
