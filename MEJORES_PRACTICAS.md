# 💎 Mejores Prácticas - Fibroskin Beauty Academy

## 🎯 Patrón de Diseño: Inspiración GlowUp AI

### ✨ Características del Diseño Moderno

#### 1. Gradientes Vibrantes
```css
/* Pink to Purple */
background: linear-gradient(to right, #db2777, #9333ea);

/* Purple to Pink */
background: linear-gradient(to right, #9333ea, #db2777);

/* Subtle backgrounds */
background: linear-gradient(to bottom right, #fdf2f8, #faf5ff, #fdf2f8);
```

#### 2. Cards con Hover Effects
- Border suave que cambia de color al hover
- Imagen con zoom suave (scale-110)
- Shadow que se intensifica
- Transiciones de 300ms para suavidad

#### 3. Tipografía Clara
- Títulos grandes y bold
- Subtítulos en neutral-600
- Espaciado generoso
- Contrast ratios accesibles (WCAG AA)

#### 4. Iconografía Consistente
- Lucide React para todos los iconos
- Tamaños: 16px (h-4 w-4), 20px (h-5 w-5), 24px (h-6 w-6)
- Colores primarios para acciones importantes

---

## 🔥 Firebase: Configuración Óptima

### Autenticación

```typescript
// ✅ BUENA PRÁCTICA: Manejar errores específicos
try {
  await signInWithEmailAndPassword(auth, email, password);
} catch (error: any) {
  if (error.code === 'auth/wrong-password') {
    toast.error('Contraseña incorrecta');
  } else if (error.code === 'auth/user-not-found') {
    toast.error('Usuario no encontrado');
  } else {
    toast.error('Error al iniciar sesión');
  }
}
```

### Firestore Queries

```typescript
// ✅ BUENA PRÁCTICA: Usar índices y limitar resultados
const coursesRef = collection(db, 'courses');
const q = query(
  coursesRef, 
  where('level', '==', 'Intermedio'),
  orderBy('rating', 'desc'),
  limit(10)
);
const snapshot = await getDocs(q);
```

### Seguridad

```javascript
// ✅ REGLAS DE FIRESTORE RECOMENDADAS
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Función helper para validar usuario autenticado
    function isSignedIn() {
      return request.auth != null;
    }
    
    // Función helper para validar que es el propietario
    function isOwner(userId) {
      return isSignedIn() && request.auth.uid == userId;
    }
    
    // Cursos: Lectura pública, escritura solo admin
    match /courses/{courseId} {
      allow read: if true;
      allow write: if isSignedIn() && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Usuarios: Solo pueden leer/escribir sus propios datos
    match /users/{userId} {
      allow read, write: if isOwner(userId);
    }
    
    // Enrollments: Solo el usuario puede crear sus inscripciones
    match /enrollments/{enrollmentId} {
      allow read: if isOwner(resource.data.userId);
      allow create: if isSignedIn() && request.resource.data.userId == request.auth.uid;
    }
  }
}
```

---

## 🚀 Performance y Optimización

### Imágenes

```typescript
// ✅ BUENA PRÁCTICA: Lazy loading de imágenes
<img 
  src={course.thumbnail} 
  alt={course.title}
  loading="lazy"
  className="..."
/>

// ✅ BUENA PRÁCTICA: Usar WebP cuando sea posible
// Subir imágenes optimizadas:
// - Resolución máxima: 1200px ancho
// - Formato: WebP o JPEG optimizado
// - Compresión: 80-85% calidad
```

### Code Splitting

```typescript
// ✅ BUENA PRÁCTICA: Lazy load de rutas
import { lazy, Suspense } from 'react';
import Loading from './components/Loading';

const Courses = lazy(() => import('./pages/Courses'));
const Products = lazy(() => import('./pages/Products'));

// En Routes
<Suspense fallback={<Loading />}>
  <Route path="/courses" element={<Courses />} />
</Suspense>
```

### Memoización

```typescript
// ✅ BUENA PRÁCTICA: Memorizar componentes costosos
import { memo } from 'react';

export const CourseCard = memo(function CourseCard({ course }) {
  // ...
});

// ✅ BUENA PRÁCTICA: Memorizar cálculos
import { useMemo } from 'react';

const filteredCourses = useMemo(() => {
  return courses.filter(c => c.level === selectedLevel);
}, [courses, selectedLevel]);
```

---

## 🎨 UI/UX Best Practices

### Feedback al Usuario

```typescript
// ✅ SIEMPRE dar feedback en acciones
const handleAction = async () => {
  const toastId = toast.loading('Procesando...');
  
  try {
    await someAsyncAction();
    toast.success('¡Acción completada!', { id: toastId });
  } catch (error) {
    toast.error('Error al procesar', { id: toastId });
  }
};
```

### Estados de Carga

```typescript
// ✅ BUENA PRÁCTICA: Mostrar skeletons o spinners
{loading ? (
  <Loading />
) : (
  <div>Contenido</div>
)}
```

### Validación de Formularios

```typescript
// ✅ BUENA PRÁCTICA: Validación en tiempo real
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';

const schema = z.object({
  email: z.string().email('Email inválido'),
  password: z.string().min(6, 'Mínimo 6 caracteres')
});

const { register, handleSubmit, formState: { errors } } = useForm({
  resolver: zodResolver(schema)
});
```

### Accesibilidad (a11y)

```typescript
// ✅ SIEMPRE incluir textos alternativos
<img src={...} alt="Descripción clara de la imagen" />

// ✅ SIEMPRE usar labels en inputs
<Label htmlFor="email">Email</Label>
<Input id="email" type="email" {...register('email')} />

// ✅ Contraste de colores adecuado (mínimo 4.5:1)
// ✅ Navegación con teclado funcional
// ✅ Focus visible en elementos interactivos
```

---

## 📊 Estructura de Datos Recomendada

### Firestore Collections

```typescript
// ✅ ESTRUCTURA ÓPTIMA

// Collection: users
{
  id: "user_id",
  email: "user@email.com",
  name: "Nombre Usuario",
  photoURL: "url",
  role: "student" | "instructor" | "admin",
  createdAt: Timestamp,
  enrolledCourses: ["course_id_1", "course_id_2"],
  stats: {
    coursesCompleted: 0,
    certificatesEarned: 0,
    totalSpent: 0
  }
}

// Collection: courses
{
  id: "course_id",
  title: "Título del Curso",
  slug: "titulo-del-curso",
  description: "Descripción completa",
  instructor: {
    id: "instructor_id",
    name: "Nombre Instructor",
    photoURL: "url"
  },
  level: "Principiante" | "Intermedio" | "Avanzado",
  category: "Micropigmentación",
  price: 599,
  discountPrice: 499, // opcional
  thumbnail: "url",
  rating: 4.9,
  totalRatings: 250,
  students: 1250,
  duration: {
    weeks: 8,
    hours: 40
  },
  loomUrl: "https://loom.com/share/...",
  sections: [
    {
      id: "section_1",
      title: "Introducción",
      lessons: [
        {
          id: "lesson_1",
          title: "Bienvenida",
          duration: 10,
          videoUrl: "url",
          resources: ["url1", "url2"]
        }
      ]
    }
  ],
  requirements: ["Requisito 1", "Requisito 2"],
  learningOutcomes: ["Aprenderás 1", "Aprenderás 2"],
  featured: true,
  published: true,
  createdAt: Timestamp,
  updatedAt: Timestamp
}

// Collection: products
{
  id: "product_id",
  name: "Nombre del Producto",
  slug: "nombre-del-producto",
  description: "Descripción completa",
  category: "Productos" | "Supplies" | "Equipos",
  price: 89.99,
  compareAtPrice: 129.99, // opcional
  images: ["url1", "url2", "url3"],
  brand: "Marca",
  stock: 45,
  sku: "SKU-12345",
  rating: 4.8,
  totalReviews: 156,
  features: ["Característica 1", "Característica 2"],
  specifications: {
    weight: "100g",
    size: "50ml",
    ingredients: ["Ingrediente 1", "Ingrediente 2"]
  },
  featured: true,
  published: true,
  createdAt: Timestamp,
  updatedAt: Timestamp
}

// Collection: enrollments
{
  id: "enrollment_id",
  userId: "user_id",
  courseId: "course_id",
  status: "active" | "completed" | "cancelled",
  progress: {
    percentage: 45,
    completedLessons: ["lesson_1", "lesson_2"],
    lastAccessedLesson: "lesson_3",
    lastAccessedAt: Timestamp
  },
  enrolledAt: Timestamp,
  completedAt: Timestamp, // si está completo
  certificateUrl: "url" // si está completo
}

// Collection: orders
{
  id: "order_id",
  userId: "user_id",
  items: [
    {
      type: "course" | "product",
      id: "item_id",
      name: "Nombre",
      price: 599,
      quantity: 1
    }
  ],
  subtotal: 599,
  tax: 59.9,
  total: 658.9,
  status: "pending" | "paid" | "cancelled" | "refunded",
  paymentMethod: "stripe",
  paymentIntentId: "pi_...",
  createdAt: Timestamp,
  paidAt: Timestamp
}

// Collection: reviews
{
  id: "review_id",
  userId: "user_id",
  targetType: "course" | "product",
  targetId: "target_id",
  rating: 5,
  title: "Excelente curso",
  comment: "Comentario detallado...",
  helpful: 12, // número de "útil"
  createdAt: Timestamp,
  updatedAt: Timestamp
}
```

---

## 🔒 Seguridad

### Variables de Entorno

```bash
# ✅ NUNCA commitear credenciales reales
# ✅ Usar .env.local para desarrollo
# ✅ Configurar variables en Vercel/Netlify para producción

# .gitignore debe incluir:
.env
.env.local
.env.*.local
```

### Validación de Entrada

```typescript
// ✅ SIEMPRE validar en cliente Y servidor
// Cliente (frontend)
const schema = z.object({
  email: z.string().email(),
  amount: z.number().positive()
});

// Servidor (Cloud Functions)
exports.createPayment = functions.https.onCall((data, context) => {
  // Validar autenticación
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated');
  }
  
  // Validar datos
  const { error } = schema.safeParse(data);
  if (error) {
    throw new functions.https.HttpsError('invalid-argument');
  }
  
  // Procesar...
});
```

---

## 🧪 Testing

### Tests Recomendados

```typescript
// ✅ Tests unitarios para lógica de negocio
// ✅ Tests de integración para flows críticos
// ✅ Tests E2E para user journeys principales

// Ejemplo con Vitest
import { describe, it, expect } from 'vitest';
import { calculateTotal } from './utils';

describe('calculateTotal', () => {
  it('debe calcular el total correctamente', () => {
    expect(calculateTotal(100, 0.15)).toBe(115);
  });
});
```

---

## 📈 Métricas y Analytics

### Eventos Importantes a Trackear

```typescript
// ✅ Sign up
analytics.logEvent('sign_up', { method: 'email' });

// ✅ Purchase
analytics.logEvent('purchase', {
  transaction_id: orderId,
  value: total,
  currency: 'USD',
  items: [...]
});

// ✅ View item
analytics.logEvent('view_item', {
  item_id: course.id,
  item_name: course.title,
  item_category: course.category
});

// ✅ Add to cart
analytics.logEvent('add_to_cart', {
  item_id: product.id,
  item_name: product.name,
  price: product.price
});
```

---

## 🚀 Deployment Checklist

- [ ] Actualizar todas las variables de entorno
- [ ] Verificar reglas de seguridad de Firestore
- [ ] Habilitar CORS en Storage
- [ ] Configurar dominio custom
- [ ] Activar SSL/HTTPS
- [ ] Configurar redirects (www → non-www)
- [ ] Optimizar imágenes
- [ ] Minificar y comprimir assets
- [ ] Configurar caché headers
- [ ] Probar en múltiples dispositivos
- [ ] Verificar accesibilidad (Lighthouse)
- [ ] Configurar error tracking (Sentry)
- [ ] Activar Analytics
- [ ] Configurar backups automáticos
- [ ] Documentar deployment process

---

✨ **Siguiendo estas prácticas, tendrás una aplicación profesional, escalable y mantenible**
