# 🚀 Guía Rápida - Fibroskin Beauty Academy

## ⚡ Inicio en 3 Pasos

### 1️⃣ Configurar Firebase (5 minutos)

```bash
# Archivo a editar:
/src/lib/firebase.ts

# Reemplaza estos valores con los de tu proyecto Firebase:
apiKey: "TU_API_KEY"
authDomain: "TU_AUTH_DOMAIN"
projectId: "TU_PROJECT_ID"
storageBucket: "TU_STORAGE_BUCKET"
messagingSenderId: "TU_MESSAGING_SENDER_ID"
appId: "TU_APP_ID"
```

**Dónde obtener estos datos:**
1. Ir a [Firebase Console](https://console.firebase.google.com/)
2. Crear un nuevo proyecto
3. Ir a **Configuración del proyecto** (⚙️)
4. Scroll hasta "Tus apps" → Seleccionar Web (icono `</>`)
5. Copiar el objeto `firebaseConfig`

### 2️⃣ Instalar Dependencias

```bash
npm install
```

### 3️⃣ Ejecutar la Aplicación

```bash
npm run dev
```

✨ **¡Listo!** Abre http://localhost:5173

---

## 📱 Funcionalidades Principales

### 🏠 Página Principal (/)
- Hero section con gradientes modernos
- Call-to-actions para Cursos y Productos
- Sección de características
- Diseño tipo GlowUp AI

### 🔐 Autenticación
- **Login** (/login) - Iniciar sesión con email/contraseña
- **Registro** (/register) - Crear nueva cuenta
- **Protección** - Perfil solo para usuarios autenticados

### 📚 Cursos (/courses)
- Catálogo completo de cursos
- Filtros por nivel: Principiante, Intermedio, Avanzado
- Cards con imágenes, ratings y precios
- Datos de ejemplo incluidos

### 🛍️ Productos (/products)
- Catálogo de productos profesionales
- Filtros por categoría: Productos, Supplies, Equipos
- Productos destacados
- Sistema de stock

### 👤 Perfil (/profile)
- Dashboard personal
- Estadísticas de cursos y compras
- Solo accesible para usuarios autenticados

---

## 🎨 Personalización Rápida

### Cambiar Colores
Edita `/src/styles/theme.css`:

```css
:root {
  --primary-pink: #db2777;    /* Rosa principal */
  --primary-purple: #9333ea;  /* Púrpura principal */
}
```

### Agregar Más Cursos
Edita `/src/data/mockData.ts`:

```typescript
export const mockCourses: Course[] = [
  {
    id: '1',
    title: 'Tu Nuevo Curso',
    description: 'Descripción del curso',
    instructor: 'Nombre del instructor',
    duration: '8 semanas',
    level: 'Intermedio',
    price: 599,
    thumbnail: 'URL_DE_IMAGEN',
    rating: 4.9,
    students: 1250,
    category: 'Categoría'
  },
  // ... más cursos
];
```

### Agregar Más Productos
Edita `/src/data/mockData.ts`:

```typescript
export const mockProducts: Product[] = [
  {
    id: '1',
    name: 'Tu Producto',
    description: 'Descripción',
    price: 89.99,
    category: 'Productos', // o 'Supplies' o 'Equipos'
    image: 'URL_DE_IMAGEN',
    brand: 'Marca',
    stock: 45,
    rating: 4.8,
    featured: true
  },
  // ... más productos
];
```

---

## 🔥 Características del Diseño

### ✨ Gradientes Modernos
```css
bg-gradient-to-r from-pink-600 to-purple-600
bg-gradient-to-br from-pink-50 via-purple-50 to-pink-50
```

### 🎯 Componentes UI Incluidos
- ✅ Buttons (varios estilos y tamaños)
- ✅ Cards (con hover effects)
- ✅ Badges (etiquetas y categorías)
- ✅ Inputs (formularios estilizados)
- ✅ Toasts (notificaciones elegantes)

### 📱 Totalmente Responsivo
- Mobile-first design
- Breakpoints: sm (640px), md (768px), lg (1024px), xl (1280px)
- Navegación adaptable

---

## 🗄️ Estructura de Datos

### Usuario (Firebase Auth)
```typescript
{
  uid: string;
  email: string;
  emailVerified: boolean;
}
```

### Curso
```typescript
{
  id: string;
  title: string;
  description: string;
  instructor: string;
  duration: string;
  level: 'Principiante' | 'Intermedio' | 'Avanzado';
  price: number;
  thumbnail: string;
  rating: number;
  students: number;
  category: string;
  loomUrl?: string; // Para videos
}
```

### Producto
```typescript
{
  id: string;
  name: string;
  description: string;
  price: number;
  category: 'Productos' | 'Supplies' | 'Equipos';
  image: string;
  brand: string;
  stock: number;
  rating: number;
  featured: boolean;
}
```

---

## 🛠️ Comandos Útiles

```bash
# Desarrollo
npm run dev

# Build de producción
npm run build

# Preview del build
npm run preview

# Linting
npm run lint

# Type checking
npx tsc --noEmit
```

---

## 🌐 Integración con Datos Reales

### Conexión con tu Backend
Reemplaza `/src/data/mockData.ts` con llamadas a tu API:

```typescript
// Ejemplo con fetch
export const fetchCourses = async () => {
  const response = await fetch('https://fibroacademyusa.com/api/courses');
  return response.json();
};
```

### Integración con Loom
Para los videos de cursos:

1. Sube tus videos a [Loom](https://www.loom.com/)
2. Obtén el enlace compartible
3. Agrega a cada curso: `loomUrl: "https://www.loom.com/share/..."`

---

## 📊 Próximos Pasos

### Inmediatos (1-2 días)
1. ✅ Configurar Firebase
2. ✅ Cargar tus datos reales
3. ✅ Personalizar textos y branding
4. ✅ Subir imágenes reales

### Corto Plazo (1 semana)
1. 🔄 Integrar API de tu backend
2. 🔄 Conectar videos de Loom
3. 🔄 Sistema de pagos (Stripe)
4. 🔄 Email notifications

### Mediano Plazo (1 mes)
1. 📈 Dashboard de admin
2. 📈 Sistema de reviews
3. 📈 Chat de soporte
4. 📈 Analytics avanzado

---

## 🆘 Solución de Problemas

### Error: "Firebase is not configured"
→ Verifica que hayas actualizado `/src/lib/firebase.ts` con tus credenciales

### Error: "Module not found"
→ Ejecuta `npm install` para instalar dependencias

### El diseño no se ve bien
→ Asegúrate de que Tailwind CSS esté procesando correctamente
→ Verifica que `/src/styles/tailwind.css` esté importado

### Las rutas no funcionan
→ Verifica que tengas `react-router-dom` instalado
→ Revisa que el Router esté configurado en `App.tsx`

---

## 💡 Tips Pro

1. **Imágenes**: Usa Unsplash o tu propio hosting para imágenes de alta calidad
2. **Performance**: Implementa lazy loading para imágenes
3. **SEO**: Agrega meta tags y Open Graph
4. **Analytics**: Conecta Google Analytics 4
5. **Seguridad**: Implementa rate limiting en Firebase

---

## 📞 Recursos

- [Documentación Firebase](https://firebase.google.com/docs)
- [Tailwind CSS](https://tailwindcss.com/docs)
- [React Router](https://reactrouter.com/)
- [Radix UI](https://www.radix-ui.com/)
- [Lucide Icons](https://lucide.dev/)

---

✨ **¡Tu aplicación Fibroskin Beauty Academy está lista para crecer!**
