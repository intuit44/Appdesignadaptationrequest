import { useState, useMemo } from 'react';

type FilterFunction<T> = (item: T) => boolean;

export function useFilter<T>(items: T[]) {
  const [filters, setFilters] = useState<FilterFunction<T>[]>([]);

  const filteredItems = useMemo(() => {
    if (filters.length === 0) return items;
    return items.filter((item) => filters.every((filter) => filter(item)));
  }, [items, filters]);

  const addFilter = (filter: FilterFunction<T>) => {
    setFilters((prev) => [...prev, filter]);
  };

  const removeFilter = (index: number) => {
    setFilters((prev) => prev.filter((_, i) => i !== index));
  };

  const clearFilters = () => {
    setFilters([]);
  };

  return {
    filteredItems,
    addFilter,
    removeFilter,
    clearFilters,
    hasFilters: filters.length > 0,
  };
}
