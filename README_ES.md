# 💎 FibroSkin Beauty Academy

> Plataforma integral de belleza profesional con diseño moderno inspirado en GlowUp AI

[![React](https://img.shields.io/badge/React-18-61DAFB?logo=react)](https://reactjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5-3178C6?logo=typescript)](https://www.typescriptlang.org/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind-4.0-38B2AC?logo=tailwind-css)](https://tailwindcss.com/)
[![Firebase](https://img.shields.io/badge/Firebase-Ready-FFCA28?logo=firebase)](https://firebase.google.com/)

## ✨ Características

- 🎨 **Diseño Moderno**: Sistema de diseño con gradientes rosa-púrpura inspirado en GlowUp AI
- 📱 **Totalmente Responsivo**: Optimizado para móviles, tablets y desktop
- 🔥 **Firebase Ready**: Configuración lista para Authentication, Firestore y Storage
- 🍎 **Apple Sign In**: Soporte para autenticación con Apple ID
- 🛍️ **Marketplace**: Catálogo de productos profesionales con carrito de compras
- 📚 **Academia**: Plataforma de cursos con tracking de progreso
- 🎯 **Arquitectura Escalable**: Patrones de diseño modulares y reutilizables
- 🚀 **Flutter Ready**: Preparado para exportar a Flutter vía DhiWise

## 🎯 Stack Tecnológico

- **Frontend Framework**: React 18 + TypeScript
- **Styling**: Tailwind CSS v4.0 con sistema de diseño personalizado
- **State Management**: Zustand
- **Routing**: React Router v6
- **UI Components**: shadcn/ui + componentes personalizados
- **Backend**: Firebase (Auth, Firestore, Storage, Functions)
- **Deployment**: Vercel / Firebase Hosting

## 🚀 Inicio Rápido

### Prerequisitos

```bash
Node.js 18+ 
npm o yarn
```

### Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/tu-usuario/fibroskin-beauty-academy.git
cd fibroskin-beauty-academy
```

2. **Instalar dependencias**
```bash
npm install
```

3. **Configurar variables de entorno**
```bash
cp .env.example .env
```

Edita `.env` con tus credenciales de Firebase:
```env
VITE_FIREBASE_API_KEY=tu_api_key
VITE_FIREBASE_AUTH_DOMAIN=tu_auth_domain
VITE_FIREBASE_PROJECT_ID=tu_project_id
# ... etc
```

4. **Iniciar el servidor de desarrollo**
```bash
npm run dev
```

La aplicación estará disponible en `http://localhost:5173`

## 📁 Estructura del Proyecto

```
fibroskin-beauty-academy/
├── src/
│   ├── app/
│   │   ├── components/
│   │   │   ├── base/           # Componentes base reutilizables
│   │   │   ├── course/         # Componentes de cursos
│   │   │   ├── product/        # Componentes de productos
│   │   │   ├── layout/         # Header, Footer, etc.
│   │   │   └── sections/       # Secciones de páginas
│   │   └── pages/              # Páginas de la aplicación
│   ├── config/                 # Configuración (Firebase, etc.)
│   ├── hooks/                  # Custom React Hooks
│   ├── services/               # Servicios API
│   ├── store/                  # Zustand stores
│   ├── types/                  # TypeScript types
│   └── styles/                 # Estilos globales y tema
├── public/                     # Assets estáticos
└── ...archivos de configuración
```

## 🎨 Sistema de Diseño

### Colores de Marca

```css
--brand-pink: #FF6B9D
--brand-purple: #C879FF
--brand-violet: #9D50E8
--brand-rose: #FF8FA3
--brand-fuchsia: #F72585
```

### Gradientes

```tsx
<div className="gradient-primary">Pink → Purple</div>
<div className="gradient-secondary">Fuchsia → Violet</div>
<div className="gradient-accent">Rose → Pink → Purple</div>
<h1 className="gradient-text">Texto con gradiente</h1>
```

### Componentes Base

#### GradientButton
```tsx
import { GradientButton } from '@/components/base/GradientButton';

<GradientButton variant="primary" size="lg" isLoading={false}>
  Comenzar Ahora
</GradientButton>
```

#### ProductCard
```tsx
import { ProductCard } from '@/components/product/ProductCard';

<ProductCard
  id="1"
  name="Sérum Premium"
  price={89.99}
  image="url"
  rating={4.8}
  onAddToCart={(id) => console.log(id)}
/>
```

Ver [ARQUITECTURA.md](./ARQUITECTURA.md) para documentación completa.

## 🔥 Firebase Setup

### 1. Crear Proyecto Firebase

1. Ve a [Firebase Console](https://console.firebase.google.com)
2. Crea un nuevo proyecto
3. Activa los siguientes servicios:
   - Authentication (Email/Password + Apple)
   - Cloud Firestore
   - Storage
   - Cloud Functions (opcional)

### 2. Configurar Authentication

```typescript
// Ya configurado en src/config/firebase.config.ts
import { firebaseConfig } from '@/config/firebase.config';
```

### 3. Estructura Firestore

```
/users/{userId}
  - email
  - name
  - avatar
  - enrolledCourses[]
  
/courses/{courseId}
  - title
  - instructor
  - price
  - modules[]
  
/products/{productId}
  - name
  - price
  - category
  - brand
  
/enrollments/{enrollmentId}
  - userId
  - courseId
  - progress
  - enrolledAt
```

## 🍎 Apple Sign In Setup

### 1. Apple Developer Console

1. Crea un **App ID**
2. Crea un **Service ID** para web authentication
3. Descarga la **Private Key**
4. Configura las **Redirect URLs**

### 2. Firebase Console

1. Ve a Authentication > Sign-in method
2. Activa "Apple"
3. Ingresa tu Service ID, Team ID y Key ID
4. Sube tu Private Key

Ver [documentación detallada](./INSTRUCCIONES_FIREBASE.md)

## 🛒 Features Principales

### Marketplace de Productos

- Catálogo con filtros y búsqueda
- Carrito de compras persistente
- Lista de deseos
- Reviews y ratings
- Comparación de precios

### Academia de Cursos

- Catálogo de cursos por categoría
- Video player integrado
- Tracking de progreso
- Certificados digitales
- Sistema de calificaciones

### Gestión de Usuario

- Perfil personalizable
- Historial de compras
- Cursos inscritos
- Favoritos y wishlist

## 🎯 Hooks Personalizados

### useCart
```tsx
const { items, addItem, removeItem, total } = useCart();

addItem(product, quantity);
```

### useWishlist
```tsx
const { items, toggleItem, isInWishlist } = useWishlist();

const isFavorite = isInWishlist(productId);
```

### useSearch
```tsx
const { query, setQuery, filteredItems } = useSearch(
  products, 
  ['name', 'brand', 'category']
);
```

## 🚀 Deployment

### Vercel (Recomendado)

```bash
npm install -g vercel
vercel login
vercel
```

### Firebase Hosting

```bash
npm run build
firebase login
firebase init hosting
firebase deploy
```

## 📱 Migración a Flutter

Esta aplicación está diseñada para ser convertida a Flutter usando DhiWise:

1. **Diseña en Figma** siguiendo los patrones establecidos
2. **Importa a DhiWise** con la estructura de componentes
3. **Genera código Flutter** automáticamente
4. **Conecta servicios Firebase** (ya estructurados)

Ver [guía de migración completa](./ARQUITECTURA.md#preparación-para-flutterdhiwise)

## 🤝 Contribuciones

Las contribuciones son bienvenidas! Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 👥 Autores

- **FibroSkin Team** - *Trabajo Inicial* - [fibroacademyusa.com](https://fibroacademyusa.com)

## 🙏 Agradecimientos

- Diseño inspirado en GlowUp AI
- UI Components de [shadcn/ui](https://ui.shadcn.com/)
- Icons de [Lucide](https://lucide.dev/)

---

**Última actualización**: Diciembre 2024

Para más información, visita [fibroacademyusa.com](https://fibroacademyusa.com)
