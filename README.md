# 💎 Fibroskin Beauty Academy - Aplicación Web

> Plataforma moderna de cursos profesionales y productos de estética avanzada

![React](https://img.shields.io/badge/React-18.3.1-blue)
![TypeScript](https://img.shields.io/badge/TypeScript-5.x-blue)
![Firebase](https://img.shields.io/badge/Firebase-12.x-orange)
![Tailwind CSS](https://img.shields.io/badge/Tailwind-4.x-cyan)

## ✨ Características

### 🎨 Diseño Moderno
- Inspirado en apps de belleza tipo GlowUp AI
- Gradientes modernos y animaciones suaves
- UI limpia y enfocada en la experiencia del usuario
- Totalmente responsivo (mobile, tablet, desktop)

### 🔐 Autenticación
- Firebase Authentication
- Login con email/contraseña
- Registro de usuarios
- Protección de rutas privadas
- Estado de autenticación global con Zustand

### 📚 Módulo de Cursos
- Catálogo completo de cursos profesionales
- Filtros por nivel (Principiante, Intermedio, Avanzado)
- Información detallada de cada curso
- Integración con Loom para videos
- Sistema de ratings y reviews

### 🛍️ Módulo de Productos
- Catálogo de productos profesionales
- 3 categorías: Productos, Supplies, Equipos
- Filtros y búsqueda avanzada
- Productos destacados
- Sistema de stock y disponibilidad

### 👤 Perfil de Usuario
- Dashboard personal
- Estadísticas de cursos y compras
- Historial de certificados
- Gestión de cuenta

## 🚀 Inicio Rápido

### Prerrequisitos

```bash
Node.js >= 18.0.0
npm >= 9.0.0
```

### Instalación

1. **Clonar el repositorio**
```bash
git clone [URL-DEL-REPO]
cd fibroskin-beauty-academy
```

2. **Instalar dependencias**
```bash
npm install
```

3. **Configurar Firebase**
Sigue las instrucciones en [INSTRUCCIONES_FIREBASE.md](./INSTRUCCIONES_FIREBASE.md)

4. **Ejecutar en desarrollo**
```bash
npm run dev
```

La aplicación estará disponible en `http://localhost:5173`

## 📁 Estructura del Proyecto

```
fibroskin-academy/
├── src/
│   ├── app/
│   │   ├── components/          # Componentes de la aplicación
│   │   │   ├── ui/              # Componentes UI reutilizables
│   │   │   └── Header.tsx       # Navegación principal
│   │   └── pages/               # Páginas de la aplicación
│   │       ├── Home.tsx         # Página principal
│   │       ├── Login.tsx        # Autenticación
│   │       ├── Register.tsx     # Registro
│   │       ├── Courses.tsx      # Catálogo de cursos
│   │       ├── Products.tsx     # Catálogo de productos
│   │       └── Profile.tsx      # Perfil de usuario
│   ├── lib/
│   │   └── firebase.ts          # Configuración de Firebase
│   ├── store/
│   │   └── authStore.ts         # Estado global de autenticación
│   ├── types/
│   │   └── index.ts             # Tipos de TypeScript
│   └── data/
│       └── mockData.ts          # Datos de ejemplo
├── public/                      # Archivos estáticos
└── package.json                 # Dependencias del proyecto
```

## 🎯 Tecnologías Utilizadas

### Core
- **React 18.3** - Biblioteca UI
- **TypeScript** - Type safety
- **Vite** - Build tool ultra-rápido
- **React Router** - Navegación

### Estado
- **Zustand** - Manejo de estado global

### Backend
- **Firebase Authentication** - Autenticación
- **Firestore** - Base de datos NoSQL
- **Firebase Storage** - Almacenamiento de archivos

### UI/Estilos
- **Tailwind CSS 4** - Framework CSS utility-first
- **Radix UI** - Componentes accesibles sin estilos
- **Lucide React** - Iconos modernos
- **Motion** - Animaciones fluidas
- **Sonner** - Notificaciones toast elegantes

### Formularios
- **React Hook Form** - Manejo de formularios
- **Zod** - Validación de schemas

## 🎨 Paleta de Colores

```css
/* Gradientes principales */
Pink-Purple: from-pink-600 to-purple-600
Purple-Pink: from-purple-600 to-pink-600

/* Colores primarios */
Pink: #db2777 (pink-600)
Purple: #9333ea (purple-600)
Neutral: #404040 (neutral-700)

/* Backgrounds */
Light Pink: #fdf2f8 (pink-50)
Light Purple: #faf5ff (purple-50)
```

## 📊 Datos del Negocio Real

### Información de Fibroskin
- **Sitio web**: https://fibroacademyusa.com
- **Cursos online**: https://fibroacademyusa.com/recursos/
- **Enfoque**: Técnicas innovadoras de estética moderna
- **Servicios**: 
  - Cursos profesionales certificados
  - Productos de estética avanzada
  - Supplies y equipos profesionales

### Categorías de Cursos
1. Micropigmentación
2. Tratamientos Faciales
3. Fibroblast Plasma
4. Maquillaje Permanente
5. Depilación Láser
6. Masajes Terapéuticos

### Categorías de Productos
1. **Productos**: Sueros, cremas, tratamientos
2. **Supplies**: Kits, herramientas, accesorios
3. **Equipos**: Máquinas y dispositivos profesionales

## 🔧 Scripts Disponibles

```bash
# Desarrollo
npm run dev

# Build para producción
npm run build

# Preview del build
npm run preview

# Linting
npm run lint
```

## 🌐 Despliegue

### Opción 1: Vercel (Recomendado)
```bash
npm install -g vercel
vercel
```

### Opción 2: Firebase Hosting
```bash
npm run build
firebase deploy
```

### Opción 3: Netlify
```bash
npm run build
# Conecta tu repositorio en Netlify Dashboard
```

## 📱 Responsividad

La aplicación está optimizada para:
- 📱 **Mobile**: 320px - 640px
- 📱 **Tablet**: 641px - 1024px
- 💻 **Desktop**: 1025px+

## 🔒 Seguridad

- ✅ Autenticación con Firebase Auth
- ✅ Rutas protegidas con guards
- ✅ Validación de formularios con Zod
- ✅ Variables de entorno para credenciales
- ✅ Reglas de seguridad en Firestore

## 🚧 Próximas Características

- [ ] Página de detalles de curso individual
- [ ] Sistema de carrito de compras
- [ ] Pasarela de pagos con Stripe
- [ ] Dashboard de admin
- [ ] Sistema de reviews y comentarios
- [ ] Notificaciones push
- [ ] Modo oscuro
- [ ] Internacionalización (i18n)

## 📄 Licencia

Este proyecto está bajo la Licencia MIT.

## 👥 Contacto

Para preguntas sobre la plataforma o el negocio:
- Web: https://fibroacademyusa.com
- Email: info@fibroacademyusa.com

---

**Desarrollado con ❤️ para Fibroskin Beauty Academy**
