# 🏗️ Arquitectura de FibroSkin Beauty Academy

## 📋 Tabla de Contenidos
- [Visión General](#visión-general)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Patrones de Diseño](#patrones-de-diseño)
- [Sistema de Componentes](#sistema-de-componentes)
- [Gestión de Estado](#gestión-de-estado)
- [Integración con Firebase](#integración-con-firebase)
- [Preparación para Flutter/DhiWise](#preparación-para-flutterdhiwise)

---

## 🎯 Visión General

FibroSkin Beauty Academy es una plataforma integral que combina:
- **Academia**: Cursos profesionales de estética
- **Marketplace**: Productos de belleza profesionales
- **Comunidad**: Red social para profesionales

### Tecnologías
- **Frontend**: React 18 + TypeScript
- **Styling**: Tailwind CSS v4 con sistema de diseño personalizado
- **State Management**: Zustand
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Future**: Flutter (via DhiWise export)

---

## 📁 Estructura del Proyecto

```
src/
├── app/
│   ├── components/
│   │   ├── base/              # Componentes base reutilizables
│   │   │   ├── GradientButton.tsx
│   │   │   ├── GradientCard.tsx
│   │   │   ├── CategoryChip.tsx
│   │   │   ├── SearchBar.tsx
│   │   │   ├── RatingStars.tsx
│   │   │   ├── ProgressBar.tsx
│   │   │   └── BadgeTag.tsx
│   │   ├── course/            # Componentes específicos de cursos
│   │   │   └── CourseCard.tsx
│   │   ├── product/           # Componentes específicos de productos
│   │   │   └── ProductCard.tsx
│   │   ├── layout/            # Componentes de layout
│   │   │   ├── ModernHeader.tsx
│   │   │   └── ModernFooter.tsx
│   │   ├── sections/          # Secciones de página reutilizables
│   │   │   ├── HeroSection.tsx
│   │   │   └── CategorySection.tsx
│   │   └── ui/                # Componentes UI de shadcn
│   └── pages/                 # Páginas de la aplicación
│       ├── Home.tsx
│       ├── Login.tsx
│       ├── Register.tsx
│       ├── Courses.tsx
│       ├── Products.tsx
│       └── Profile.tsx
├── config/
│   └── firebase.config.ts     # Configuración centralizada
├── hooks/
│   ├── useCart.ts             # Hook para carrito de compras
│   ├── useWishlist.ts         # Hook para lista de deseos
│   ├── useSearch.ts           # Hook para búsqueda
│   └── useFilter.ts           # Hook para filtros
├── services/
│   ├── course.service.ts      # Servicio de cursos
│   └── product.service.ts     # Servicio de productos
├── store/
│   └── authStore.ts           # Store de autenticación
├── types/
│   ├── course.types.ts        # Tipos de cursos
│   ├── product.types.ts       # Tipos de productos
│   └── user.types.ts          # Tipos de usuario
└── styles/
    ├── theme.css              # Sistema de diseño (colores, gradientes)
    ├── fonts.css              # Fuentes personalizadas
    └── index.css              # Estilos globales
```

---

## 🎨 Patrones de Diseño

### 1. Component Composition Pattern
Los componentes se diseñan para ser **composables** y **reutilizables**:

```tsx
// ✅ CORRECTO - Componentes composables
<GradientCard>
  <ProductInfo />
  <ProductActions />
</GradientCard>

// ❌ INCORRECTO - Componente monolítico
<ProductCardWithEverything />
```

### 2. Container/Presentation Pattern
- **Container Components**: Manejan lógica y estado (`pages/`)
- **Presentation Components**: Solo UI (`components/base/`)

### 3. Custom Hooks Pattern
Lógica reutilizable extraída en hooks personalizados:
```tsx
const { items, addItem, removeItem } = useCart();
const { query, setQuery, filteredItems } = useSearch(products, ['name', 'brand']);
```

### 4. Service Layer Pattern
Separación de lógica de negocio de componentes UI:
```tsx
// services/course.service.ts
export const courseService = {
  getCourses,
  enrollInCourse,
  updateProgress
};
```

---

## 🧩 Sistema de Componentes

### Base Components (Atomic Design)
Componentes fundamentales sin dependencias de negocio:

#### GradientButton
```tsx
<GradientButton variant="primary" size="lg" isLoading={false}>
  Inscribirse Ahora
</GradientButton>
```

**Variantes**: `primary`, `secondary`, `accent`  
**Tamaños**: `sm`, `md`, `lg`

#### GradientCard
```tsx
<GradientCard variant="gradient" hover={true}>
  {/* Contenido */}
</GradientCard>
```

**Variantes**: `default`, `gradient`, `subtle`

#### CategoryChip
```tsx
<CategoryChip 
  label="Skincare" 
  icon="💧" 
  active={true}
  onClick={() => {}}
/>
```

#### SearchBar
```tsx
<SearchBar 
  placeholder="Buscar..." 
  onSearch={(value) => console.log(value)}
/>
```

#### RatingStars
```tsx
<RatingStars 
  rating={4.5} 
  maxRating={5}
  size="md"
  showNumber={true}
/>
```

#### ProgressBar
```tsx
<ProgressBar 
  progress={75}
  variant="primary"
  showPercentage={true}
/>
```

#### BadgeTag
```tsx
<BadgeTag 
  label="Nuevo" 
  variant="primary"
  size="sm"
/>
```

### Domain Components
Componentes específicos del dominio:

#### ProductCard
```tsx
<ProductCard
  id="1"
  name="Product Name"
  price={99.99}
  originalPrice={149.99}
  image="url"
  rating={4.8}
  reviews={1234}
  category="Skincare"
  brand="Brand"
  onAddToCart={(id) => {}}
  onToggleFavorite={(id) => {}}
/>
```

#### CourseCard
```tsx
<CourseCard
  id="1"
  title="Course Title"
  instructor="Instructor Name"
  thumbnail="url"
  duration="8 horas"
  students={1250}
  lessons={24}
  rating={4.9}
  reviews={342}
  price={299}
  level="Avanzado"
  category="Category"
  onEnroll={(id) => {}}
/>
```

---

## 💾 Gestión de Estado

### Zustand Stores

#### AuthStore
```tsx
const { user, signIn, signUp, logout } = useAuthStore();
```

#### CartStore
```tsx
const { items, addItem, removeItem, total } = useCart();
```

#### WishlistStore
```tsx
const { items, toggleItem, isInWishlist } = useWishlist();
```

### Estado Local
Para estado que no necesita compartirse:
```tsx
const [isOpen, setIsOpen] = useState(false);
```

---

## 🔥 Integración con Firebase

### Configuración
Ver `/src/config/firebase.config.ts`

### Collections Firestore
```typescript
COLLECTIONS = {
  USERS: 'users',
  COURSES: 'courses',
  PRODUCTS: 'products',
  ORDERS: 'orders',
  REVIEWS: 'reviews',
  ENROLLMENTS: 'enrollments',
  PROGRESS: 'progress',
}
```

### Servicios
```typescript
// Course Service
await courseService.getCourses({ category: 'skincare' });
await courseService.enrollInCourse(userId, courseId);

// Product Service
await productService.getProducts({ inStock: true });
await productService.searchProducts('serum');
```

---

## 🎨 Sistema de Diseño

### Colores (theme.css)

#### Brand Colors
```css
--brand-pink: #FF6B9D
--brand-purple: #C879FF
--brand-violet: #9D50E8
--brand-rose: #FF8FA3
--brand-fuchsia: #F72585
```

#### Gradientes
```css
.gradient-primary     /* Pink → Purple */
.gradient-secondary   /* Fuchsia → Violet */
.gradient-accent      /* Rose → Pink → Purple */
.gradient-subtle      /* Light pink → Light purple */
.gradient-text        /* Texto con gradiente */
```

#### Uso
```tsx
<div className="gradient-primary">...</div>
<h1 className="gradient-text">Título</h1>
<button className="shadow-glow">...</button>
```

### Tipografía
- **Font Size**: Se maneja via elementos HTML (h1, h2, h3, p)
- **Font Weight**: 
  - Normal: 400
  - Medium: 600
  - Semibold: 600
  - Bold: 700

### Espaciado
- **Border Radius**: 
  - Default: `1rem`
  - Cards: `1.25rem` (20px)
  - Buttons: `0.75rem` (12px)
  - Modals: `1.5rem` (24px)

---

## 📱 Preparación para Flutter/DhiWise

### Principios de Diseño Portables

1. **Componentes Atómicos**: Cada componente base puede mapearse a un Widget de Flutter
2. **Props Tipadas**: TypeScript types → Dart classes
3. **Estado Centralizado**: Zustand → Provider/Riverpod
4. **Servicios Separados**: Service layer → Repository pattern

### Mapeo de Componentes

| React Component | Flutter Widget |
|----------------|----------------|
| `GradientButton` | `ElevatedButton` with `LinearGradient` |
| `GradientCard` | `Card` with `Container` |
| `SearchBar` | `TextField` with `InputDecoration` |
| `RatingStars` | `Row` of `Icon` widgets |
| `ProgressBar` | `LinearProgressIndicator` |

### Exportación a DhiWise

1. **Diseño en Figma**: Usar componentes consistentes con la arquitectura actual
2. **Naming Convention**: Mantener mismos nombres de componentes
3. **Props Structure**: Seguir misma estructura de props
4. **Color System**: Exportar theme.css como theme.dart

---

## 🚀 Próximos Pasos

### Fase 1: Completar Funcionalidad Base
- [ ] Implementar autenticación Firebase completa
- [ ] Conectar servicios con Firestore
- [ ] Agregar gestión de usuarios
- [ ] Implementar carrito de compras funcional

### Fase 2: Features Avanzadas
- [ ] Integración con APIs externas (Sephora, Ulta)
- [ ] Sistema de recomendaciones
- [ ] Video player para cursos
- [ ] Sistema de certificados

### Fase 3: Optimización
- [ ] Lazy loading de imágenes
- [ ] Code splitting
- [ ] PWA features
- [ ] Performance optimization

### Fase 4: Flutter Migration
- [ ] Diseño completo en Figma
- [ ] Export via DhiWise
- [ ] Migración de servicios
- [ ] Testing multiplataforma

---

## 📚 Recursos

- [Firebase Docs](https://firebase.google.com/docs)
- [Tailwind CSS](https://tailwindcss.com)
- [Zustand](https://github.com/pmndrs/zustand)
- [DhiWise](https://www.dhiwise.com)
- [Flutter](https://flutter.dev)

---

**Última actualización**: Diciembre 2024
