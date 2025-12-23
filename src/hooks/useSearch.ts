import { useState, useMemo } from 'react';

interface SearchableItem {
  id: string;
  [key: string]: any;
}

export function useSearch<T extends SearchableItem>(
  items: T[],
  searchFields: (keyof T)[]
) {
  const [query, setQuery] = useState('');

  const filteredItems = useMemo(() => {
    if (!query.trim()) return items;

    const lowerQuery = query.toLowerCase();
    return items.filter((item) =>
      searchFields.some((field) => {
        const value = item[field];
        if (typeof value === 'string') {
          return value.toLowerCase().includes(lowerQuery);
        }
        if (typeof value === 'number') {
          return value.toString().includes(lowerQuery);
        }
        return false;
      })
    );
  }, [items, query, searchFields]);

  return {
    query,
    setQuery,
    filteredItems,
  };
}
