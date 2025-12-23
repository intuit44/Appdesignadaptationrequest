# 🔥 Instrucciones de Configuración Firebase

## Fibroskin Beauty Academy - Configuración Firebase

### 📋 Paso 1: Crear Proyecto Firebase

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Haz clic en "Agregar proyecto"
3. Nombre del proyecto: `fibroskin-beauty-academy`
4. Sigue los pasos del asistente

### 🔑 Paso 2: Obtener Configuración

1. En la consola de Firebase, ve a **Configuración del proyecto** (ícono de engranaje)
2. En la sección "Tus apps", haz clic en el ícono web `</>`
3. Registra tu app con el nombre: `Fibroskin Web App`
4. Copia la configuración que aparece (objeto firebaseConfig)

### 📝 Paso 3: Actualizar Configuración Local

Edita el archivo `/src/lib/firebase.ts` y reemplaza los valores de configuración:

```typescript
const firebaseConfig = {
  apiKey: "TU_API_KEY_AQUI",
  authDomain: "TU_AUTH_DOMAIN_AQUI",
  projectId: "TU_PROJECT_ID_AQUI",
  storageBucket: "TU_STORAGE_BUCKET_AQUI",
  messagingSenderId: "TU_MESSAGING_SENDER_ID_AQUI",
  appId: "TU_APP_ID_AQUI"
};
```

### 🔐 Paso 4: Habilitar Autenticación

1. En Firebase Console, ve a **Authentication**
2. Haz clic en "Comenzar"
3. En la pestaña **Sign-in method**, habilita:
   - ✅ Correo electrónico/contraseña
   - ✅ Google (opcional)

### 🗄️ Paso 5: Configurar Firestore Database

1. En Firebase Console, ve a **Firestore Database**
2. Haz clic en "Crear base de datos"
3. Selecciona **Modo de producción**
4. Elige la ubicación más cercana (por ejemplo: `us-central`)

### 📦 Paso 6: Reglas de Seguridad

En **Firestore Database** > **Reglas**, pega estas reglas:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permitir lectura pública de cursos y productos
    match /courses/{courseId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Solo usuarios autenticados pueden leer/escribir sus datos
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 💾 Paso 7: Datos de Ejemplo (Opcional)

Puedes agregar datos de ejemplo directamente en Firestore Console:

#### Colección: `courses`
```json
{
  "title": "Micropigmentación Profesional",
  "description": "Domina las técnicas más avanzadas...",
  "instructor": "Dra. María González",
  "duration": "8 semanas",
  "level": "Intermedio",
  "price": 599,
  "thumbnail": "URL_DE_IMAGEN",
  "rating": 4.9,
  "students": 1250,
  "category": "Micropigmentación"
}
```

#### Colección: `products`
```json
{
  "name": "Suero Ácido Hialurónico Premium",
  "description": "Suero concentrado de ácido hialurónico...",
  "price": 89.99,
  "category": "Productos",
  "image": "URL_DE_IMAGEN",
  "brand": "FibroSkin Professional",
  "stock": 45,
  "rating": 4.8,
  "featured": true
}
```

### 🚀 Paso 8: Ejecutar la Aplicación

Una vez configurado Firebase, ejecuta:

```bash
npm run dev
```

### 🔗 Integración con Loom

Para los videos de cursos:

1. Crea una cuenta en [Loom](https://www.loom.com/)
2. Sube tus videos de cursos
3. Obtén los enlaces compartibles
4. Agrega el campo `loomUrl` a cada curso en Firestore

### 📊 Datos Reales de Fibroskin

**Información del Negocio:**
- Sitio web: https://fibroacademyusa.com
- Cursos: https://fibroacademyusa.com/recursos/
- Enfoque: Cursos de estética profesional, productos avanzados, supplies y equipos

**Categorías de Productos:**
1. **Productos de Estética Avanzada**
   - Sueros
   - Cremas
   - Tratamientos

2. **Supplies (Insumos)**
   - Kits profesionales
   - Herramientas
   - Accesorios

3. **Equipos**
   - Máquinas profesionales
   - Dispositivos de tratamiento
   - Tecnología avanzada

### ⚠️ Notas Importantes

1. **Seguridad**: NUNCA compartas tus claves de Firebase públicamente
2. **Producción**: Actualiza las reglas de seguridad antes de lanzar
3. **Backup**: Configura backups automáticos en Firestore
4. **Monitoreo**: Activa Google Analytics en Firebase para métricas

### 🆘 Soporte

Si tienes problemas:
1. Revisa la [documentación de Firebase](https://firebase.google.com/docs)
2. Verifica que todas las APIs estén habilitadas
3. Asegúrate de que las credenciales sean correctas

---

✨ **¡Listo!** Tu aplicación Fibroskin Beauty Academy ahora está conectada a Firebase y lista para funcionar.
