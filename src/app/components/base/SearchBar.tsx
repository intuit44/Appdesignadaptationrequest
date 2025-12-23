import { Search } from 'lucide-react';
import { InputHTMLAttributes } from 'react';
import { cn } from '../ui/utils';

interface SearchBarProps extends InputHTMLAttributes<HTMLInputElement> {
  onSearch?: (value: string) => void;
}

export function SearchBar({ onSearch, className, ...props }: SearchBarProps) {
  return (
    <div className={cn('relative w-full', className)}>
      <Search className="absolute left-4 top-1/2 -translate-y-1/2 h-5 w-5 text-gray-400" />
      <input
        type="search"
        className="w-full pl-12 pr-4 py-3 bg-white border border-gray-200 rounded-2xl focus:outline-none focus:ring-2 focus:ring-pink-300 focus:border-transparent transition-all"
        placeholder="Buscar cursos, productos..."
        onChange={(e) => onSearch?.(e.target.value)}
        {...props}
      />
    </div>
  );
}
