# 🎨 Guía de Componentes - FibroSkin Beauty Academy

## 📦 Componentes Base (Base Components)

### GradientButton

Botón con gradiente personalizable y estados de carga.

**Ubicación**: `/src/app/components/base/GradientButton.tsx`

**Props**:
```typescript
interface GradientButtonProps {
  variant?: 'primary' | 'secondary' | 'accent';
  size?: 'sm' | 'md' | 'lg';
  children: ReactNode;
  isLoading?: boolean;
  disabled?: boolean;
  onClick?: () => void;
}
```

**Ejemplo de uso**:
```tsx
import { GradientButton } from './components/base/GradientButton';

// Botón primario grande
<GradientButton variant="primary" size="lg">
  Inscribirse Ahora
</GradientButton>

// Botón con loading
<GradientButton variant="secondary" isLoading={true}>
  Procesando...
</GradientButton>
```

**Variantes**:
- `primary`: Rosa → Morado (#FF6B9D → #C879FF)
- `secondary`: Fucsia → Violeta (#F72585 → #9D50E8)
- `accent`: Rosa → Pink → Morado (triple gradiente)

---

### GradientCard

Tarjeta con diferentes estilos de fondo y efectos hover.

**Ubicación**: `/src/app/components/base/GradientCard.tsx`

**Props**:
```typescript
interface GradientCardProps {
  children: ReactNode;
  variant?: 'default' | 'gradient' | 'subtle';
  className?: string;
  hover?: boolean;
}
```

**Ejemplo de uso**:
```tsx
import { GradientCard } from './components/base/GradientCard';

<GradientCard variant="subtle" hover={true}>
  <h3>Contenido de la tarjeta</h3>
  <p>Descripción...</p>
</GradientCard>
```

**Variantes**:
- `default`: Fondo blanco con borde
- `gradient`: Fondo con gradiente sutil
- `subtle`: Fondo blanco semi-transparente con blur

---

### CategoryChip

Chip de categoría con icono y estado activo.

**Ubicación**: `/src/app/components/base/CategoryChip.tsx`

**Props**:
```typescript
interface CategoryChipProps {
  label: string;
  icon?: string;
  active?: boolean;
  onClick?: () => void;
}
```

**Ejemplo de uso**:
```tsx
import { CategoryChip } from './components/base/CategoryChip';

<CategoryChip 
  label="Skincare" 
  icon="💧" 
  active={true}
  onClick={() => handleCategoryChange('skincare')}
/>
```

---

### SearchBar

Barra de búsqueda con icono y auto-complete.

**Ubicación**: `/src/app/components/base/SearchBar.tsx`

**Props**:
```typescript
interface SearchBarProps extends InputHTMLAttributes<HTMLInputElement> {
  onSearch?: (value: string) => void;
}
```

**Ejemplo de uso**:
```tsx
import { SearchBar } from './components/base/SearchBar';

<SearchBar 
  placeholder="Buscar cursos, productos..."
  onSearch={(value) => console.log('Buscando:', value)}
/>
```

---

### RatingStars

Componente de estrellas de rating con soporte para valores decimales.

**Ubicación**: `/src/app/components/base/RatingStars.tsx`

**Props**:
```typescript
interface RatingStarsProps {
  rating: number;
  maxRating?: number;
  size?: 'sm' | 'md' | 'lg';
  showNumber?: boolean;
  className?: string;
}
```

**Ejemplo de uso**:
```tsx
import { RatingStars } from './components/base/RatingStars';

// Mostrar 4.5 de 5 estrellas
<RatingStars rating={4.5} size="md" showNumber={true} />

// Sin número
<RatingStars rating={4.8} showNumber={false} />
```

---

### ProgressBar

Barra de progreso con porcentaje.

**Ubicación**: `/src/app/components/base/ProgressBar.tsx`

**Props**:
```typescript
interface ProgressBarProps {
  progress: number; // 0-100
  variant?: 'primary' | 'secondary';
  size?: 'sm' | 'md' | 'lg';
  showPercentage?: boolean;
  className?: string;
}
```

**Ejemplo de uso**:
```tsx
import { ProgressBar } from './components/base/ProgressBar';

// Progreso del curso
<ProgressBar 
  progress={75} 
  variant="primary"
  showPercentage={true}
/>
```

---

### BadgeTag

Etiqueta pequeña para categorías, estados, etc.

**Ubicación**: `/src/app/components/base/BadgeTag.tsx`

**Props**:
```typescript
interface BadgeTagProps {
  label: string;
  variant?: 'default' | 'primary' | 'success' | 'warning' | 'info';
  size?: 'sm' | 'md';
  className?: string;
}
```

**Ejemplo de uso**:
```tsx
import { BadgeTag } from './components/base/BadgeTag';

<BadgeTag label="Nuevo" variant="primary" size="sm" />
<BadgeTag label="-30%" variant="warning" />
<BadgeTag label="Agotado" variant="default" />
```

---

## 🛍️ Componentes de Dominio (Domain Components)

### ProductCard

Tarjeta de producto completa con imagen, precio, rating y acciones.

**Ubicación**: `/src/app/components/product/ProductCard.tsx`

**Props**:
```typescript
interface ProductCardProps {
  id: string;
  name: string;
  price: number;
  originalPrice?: number;
  image: string;
  rating: number;
  reviews: number;
  category: string;
  brand?: string;
  inStock?: boolean;
  onAddToCart?: (id: string) => void;
  onToggleFavorite?: (id: string) => void;
}
```

**Ejemplo de uso**:
```tsx
import { ProductCard } from './components/product/ProductCard';

<ProductCard
  id="1"
  name="Sérum de Ácido Hialurónico Premium"
  price={89.99}
  originalPrice={129.99}
  image="https://example.com/image.jpg"
  rating={4.8}
  reviews={1234}
  category="Skincare"
  brand="The Ordinary"
  inStock={true}
  onAddToCart={(id) => console.log('Agregar:', id)}
  onToggleFavorite={(id) => console.log('Favorito:', id)}
/>
```

**Características**:
- Imagen con lazy loading y estado de carga
- Botón de favoritos con animación
- Badge de descuento automático
- Badge de stock
- Precio original tachado
- Rating con estrellas
- Botón de agregar al carrito

---

### CourseCard

Tarjeta de curso con información del instructor, progreso y acciones.

**Ubicación**: `/src/app/components/course/CourseCard.tsx`

**Props**:
```typescript
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
```

**Ejemplo de uso**:
```tsx
import { CourseCard } from './components/course/CourseCard';

<CourseCard
  id="1"
  title="Técnicas Avanzadas de Microblading"
  instructor="María García"
  thumbnail="https://example.com/thumb.jpg"
  duration="8 horas"
  students={1250}
  lessons={24}
  rating={4.9}
  reviews={342}
  price={299}
  level="Avanzado"
  category="Cejas & Pestañas"
  onEnroll={(id) => console.log('Inscribir:', id)}
/>

// Curso ya inscrito con progreso
<CourseCard
  {...courseData}
  isEnrolled={true}
  progress={75}
  onContinue={(id) => console.log('Continuar:', id)}
/>
```

**Características**:
- Thumbnail con overlay de play en hover
- Información del instructor con avatar
- Badges de categoría y nivel
- Estadísticas (duración, lecciones, estudiantes)
- Barra de progreso para cursos inscritos
- Rating con estrellas
- Botones contextuales (inscribir/continuar)

---

## 🏗️ Componentes de Layout

### ModernHeader

Header moderno con navegación, búsqueda y acciones de usuario.

**Ubicación**: `/src/app/components/layout/ModernHeader.tsx`

**Características**:
- Logo con gradiente
- Navegación responsive
- Barra de búsqueda
- Iconos de carrito y notificaciones
- Menú de usuario
- Menú móvil con hamburguesa
- Sticky en scroll

**Ejemplo de uso**:
```tsx
import { ModernHeader } from './components/layout/ModernHeader';

// Ya incluido en App.tsx
<ModernHeader />
```

---

### ModernFooter

Footer moderno con links, redes sociales y newsletter.

**Ubicación**: `/src/app/components/layout/ModernFooter.tsx`

**Características**:
- Grid de links organizados
- Iconos de redes sociales
- Gradiente de fondo
- Responsive
- Links a secciones principales

**Ejemplo de uso**:
```tsx
import { ModernFooter } from './components/layout/ModernFooter';

// Ya incluido en App.tsx
<ModernFooter />
```

---

## 📄 Componentes de Secciones

### HeroSection

Sección hero con gradiente, CTA y estadísticas.

**Ubicación**: `/src/app/components/sections/HeroSection.tsx`

**Características**:
- Gradiente animado de fondo
- Elementos decorativos flotantes
- Textos grandes con gradiente
- Botones CTA
- Grid de estadísticas
- Imagen con tarjetas flotantes

**Ejemplo de uso**:
```tsx
import { HeroSection } from './components/sections/HeroSection';

<HeroSection />
```

---

### CategorySection

Sección de categorías con chips horizontales.

**Ubicación**: `/src/app/components/sections/CategorySection.tsx`

**Props**:
```typescript
interface CategorySectionProps {
  onCategoryChange?: (categoryId: string) => void;
}
```

**Ejemplo de uso**:
```tsx
import { CategorySection } from './components/sections/CategorySection';

<CategorySection 
  onCategoryChange={(id) => setActiveCategory(id)} 
/>
```

---

## 🎣 Custom Hooks

### useCart

Hook para gestionar el carrito de compras.

**Ubicación**: `/src/hooks/useCart.ts`

**API**:
```typescript
const {
  items,       // CartItem[]
  subtotal,    // number
  shipping,    // number
  tax,         // number
  total,       // number
  addItem,     // (product: Product, quantity?: number) => void
  removeItem,  // (productId: string) => void
  updateQuantity, // (productId: string, quantity: number) => void
  clearCart,   // () => void
} = useCart();
```

**Ejemplo de uso**:
```tsx
import { useCart } from '@/hooks/useCart';

function ShoppingCart() {
  const { items, total, addItem, removeItem } = useCart();

  return (
    <div>
      {items.map(item => (
        <div key={item.product.id}>
          {item.product.name} - ${item.product.price} x {item.quantity}
          <button onClick={() => removeItem(item.product.id)}>
            Eliminar
          </button>
        </div>
      ))}
      <p>Total: ${total.toFixed(2)}</p>
    </div>
  );
}
```

---

### useWishlist

Hook para gestionar la lista de deseos.

**Ubicación**: `/src/hooks/useWishlist.ts`

**API**:
```typescript
const {
  items,        // string[]
  addItem,      // (productId: string) => void
  removeItem,   // (productId: string) => void
  toggleItem,   // (productId: string) => void
  isInWishlist, // (productId: string) => boolean
  clearWishlist, // () => void
} = useWishlist();
```

**Ejemplo de uso**:
```tsx
import { useWishlist } from '@/hooks/useWishlist';

function Product({ id }) {
  const { isInWishlist, toggleItem } = useWishlist();
  const isFavorite = isInWishlist(id);

  return (
    <button onClick={() => toggleItem(id)}>
      {isFavorite ? '❤️' : '🤍'}
    </button>
  );
}
```

---

### useSearch

Hook para búsqueda y filtrado.

**Ubicación**: `/src/hooks/useSearch.ts`

**API**:
```typescript
const {
  query,         // string
  setQuery,      // (query: string) => void
  filteredItems, // T[]
} = useSearch<T>(items, searchFields);
```

**Ejemplo de uso**:
```tsx
import { useSearch } from '@/hooks/useSearch';
import { Product } from '@/types/product.types';

function ProductList({ products }: { products: Product[] }) {
  const { query, setQuery, filteredItems } = useSearch(
    products, 
    ['name', 'brand', 'category']
  );

  return (
    <>
      <input 
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        placeholder="Buscar..."
      />
      {filteredItems.map(product => (
        <ProductCard key={product.id} {...product} />
      ))}
    </>
  );
}
```

---

### useFilter

Hook genérico para filtros avanzados.

**Ubicación**: `/src/hooks/useFilter.ts`

**API**:
```typescript
const {
  filteredItems, // T[]
  addFilter,     // (filter: FilterFunction<T>) => void
  removeFilter,  // (index: number) => void
  clearFilters,  // () => void
  hasFilters,    // boolean
} = useFilter<T>(items);
```

**Ejemplo de uso**:
```tsx
import { useFilter } from '@/hooks/useFilter';

function ProductFilter({ products }) {
  const { filteredItems, addFilter, clearFilters } = useFilter(products);

  const filterByPrice = (min: number, max: number) => {
    addFilter((product) => product.price >= min && product.price <= max);
  };

  return (
    <>
      <button onClick={() => filterByPrice(0, 50)}>
        $0 - $50
      </button>
      <button onClick={clearFilters}>
        Limpiar
      </button>
      {filteredItems.map(product => (
        <ProductCard key={product.id} {...product} />
      ))}
    </>
  );
}
```

---

## 🎨 Clases de Utilidad CSS

### Gradientes
```css
.gradient-primary    /* Rosa → Morado */
.gradient-secondary  /* Fucsia → Violeta */
.gradient-accent     /* Rosa → Pink → Morado */
.gradient-subtle     /* Rosa claro → Morado claro */
.gradient-text       /* Texto con gradiente (pink → purple) */
```

### Sombras
```css
.shadow-glow  /* Sombra con efecto glow rosa */
```

### Ejemplo:
```tsx
<div className="gradient-primary p-8 rounded-3xl shadow-glow">
  <h2 className="gradient-text">Título con gradiente</h2>
</div>
```

---

## 📚 Ejemplos Completos

### Página de Productos Completa
```tsx
import { useState } from 'react';
import { ProductCard } from './components/product/ProductCard';
import { SearchBar } from './components/base/SearchBar';
import { CategorySection } from './components/sections/CategorySection';
import { useSearch } from './hooks/useSearch';
import { useCart } from './hooks/useCart';
import { toast } from 'sonner';

function ProductsPage() {
  const [category, setCategory] = useState('all');
  const { addItem } = useCart();
  
  const products = [...]; // tus productos
  
  const { query, setQuery, filteredItems } = useSearch(
    products, 
    ['name', 'brand']
  );

  const displayProducts = category === 'all'
    ? filteredItems
    : filteredItems.filter(p => p.category === category);

  const handleAddToCart = (productId: string) => {
    const product = products.find(p => p.id === productId);
    if (product) {
      addItem(product);
      toast.success('Producto agregado al carrito');
    }
  };

  return (
    <div>
      <SearchBar 
        value={query}
        onChange={(e) => setQuery(e.target.value)}
      />
      
      <CategorySection onCategoryChange={setCategory} />
      
      <div className="grid grid-cols-4 gap-6">
        {displayProducts.map(product => (
          <ProductCard
            key={product.id}
            {...product}
            onAddToCart={handleAddToCart}
          />
        ))}
      </div>
    </div>
  );
}
```

---

## 🔄 Flujo de Datos

```
User Action
    ↓
Component Event Handler
    ↓
Hook (useCart, useWishlist, etc.)
    ↓
Zustand Store (persistido)
    ↓
Re-render con nuevo estado
```

---

## 📖 Mejores Prácticas

1. **Siempre usa los componentes base** en lugar de crear nuevos botones o cards
2. **Tipado estricto**: Usa los tipos de TypeScript proporcionados
3. **Hooks personalizados**: Para lógica reutilizable
4. **Composición**: Combina componentes pequeños para crear páginas
5. **Responsive**: Usa clases Tailwind responsive (sm:, md:, lg:)

---

Para más detalles sobre la arquitectura completa, ver [ARQUITECTURA.md](./ARQUITECTURA.md)
