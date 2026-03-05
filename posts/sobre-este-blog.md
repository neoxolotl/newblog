# Blog Estático con GitHub - Documentación Completa

**Versión:** 1.0
**Actualización:** Marzo 2026
**Autor:** neoxolotl

---

# Índice

1. Introducción
2. Arquitectura
3. Requisitos
4. Configuración Inicial
5. Estructura del Proyecto
6. Archivos del Proyecto
7. Configuración de Giscus
8. GitHub Pages
9. Agregar Nuevos Posts
10. Mantenimiento
11. Solución de Problemas
12. Recursos

---

# 1. Introducción

Blog **100% estático** usando:

* **GitHub** (almacenamiento)
* **GitHub Pages** (hosting)
* **JavaScript vanilla** (renderizado)
* **Markdown** (artículos)
* **Giscus** (comentarios)

## Características

* Gratis
* Rápido
* Seguro
* Sin backend
* Comentarios con Giscus
* Búsqueda en tiempo real
* Responsive
* Deploy automático con `git push`

## Limitaciones

* **60 requests/hora** sin token
* **5000 requests/hora** con token
* No recomendado para datos sensibles
* Ideal para menos de **1000 posts**

---

# 2. Arquitectura

## Flujo

```
Usuario
   ↓
Navegador (index.html + CSS + JS)
   ↓
GitHub API
   ↓
Repositorio GitHub
```

## Tecnologías

* **HTML5**
* **CSS3**
* **JavaScript ES6+**
* **Markdown**
* **GitHub API v3**
* **Marked.js 4.x**
* **Giscus**

---

# 3. Requisitos

## Software

* **Git 2.0+**
* **Navegador moderno**
* **Editor de texto**

  * VS Code
  * Nano
  * Vim

## Cuentas

* **GitHub (gratis)**
* **Giscus (gratis)**

## Conocimientos

* Git básico
* HTML / CSS básico
* Markdown

No se requiere JavaScript avanzado.

---

# 4. Configuración Inicial

## 4.1 Crear Repositorio

1. Inicia sesión en **GitHub**
2. Clic en **+ → New repository**
3. Nombre: `newblog`
4. Debe ser **público** (requerido para GitHub Pages gratis)
5. Presiona **Create repository**

---

## 4.2 Clonar Repositorio

```bash
git clone https://github.com/TU-USUARIO/newblog.git
cd newblog
```

---

## 4.3 Activar Discussions

1. Ir a **Settings** del repositorio
2. Buscar **General → Features**
3. Activar **Discussions**
4. Guardar cambios

---

# 5. Estructura del Proyecto

```
newblog/
├── index.html
├── styles.css
├── DOCUMENTACION.md
└── posts/
    ├── mi-primer-post.md
    └── (más posts)
```

---

# 6. Archivos del Proyecto

## 6.1 index.html

Configuración requerida:

```javascript
const GITHUB_USERNAME = 'tu-usuario';
const GITHUB_REPO = 'newblog';
const POSTS_PATH = 'posts/';
const GITHUB_TOKEN = '';
```

---

## 6.2 styles.css

Contiene estilos para:

* Header
* Buscador
* Posts
* Renderizado Markdown
* Giscus
* Footer
* Diseño responsive

---

## 6.3 posts/*.md

Ejemplo de post:

```markdown
---
title: Título del Post
date: 2026-03-05
tags: [categoria, tema]
---

# Contenido del Post

Escribe aquí tu artículo...
```

---

# 7. Configuración de Giscus

## ¿Qué es Giscus?

Sistema de comentarios que usa **GitHub Discussions como backend**.

---

## Pasos de Configuración

1. Activar **Discussions** en el repositorio
2. Instalar la app **Giscus**
3. Obtener los IDs en:

https://giscus.app/es

4. Actualizar `index.html`

---

## Configuración en index.html

```javascript
script.setAttribute('data-repo', 'neoxolotl/newblog');
script.setAttribute('data-repo-id', 'R_kgDOXXXXXXXXXX');
script.setAttribute('data-category-id', 'DIC_kwDOXXXXXXXXXX');
script.setAttribute('data-lang', 'es');
```

---

# 8. GitHub Pages

## Activar GitHub Pages

1. Ir a **Settings → Pages**
2. Source: **Deploy from a branch**
3. Branch: **main**
4. Folder: **/ (root)**
5. Guardar

---

## URL del Blog

```
https://TU-USUARIO.github.io/newblog/
```

---

## Tiempo de Deploy

El deploy tarda aproximadamente **1 a 3 minutos**.

Puedes verificar el progreso en la pestaña **Actions**.

---

# 9. Agregar Nuevos Posts

## Crear Post

```bash
nano posts/mi-nuevo-post.md
```

---

## Estructura del Post

```markdown
---
title: Mi Nuevo Post
date: 2026-03-06
tags: [tutorial, github]
---

# Contenido

Escribe aquí...
```

---

## Subir a GitHub

```bash
git add posts/
git commit -m "Agregar nuevo post"
git push origin main
```

---

# 10. Mantenimiento

## Actualizar Post

```bash
nano posts/mi-post.md
git add posts/
git commit -m "Actualizar post"
git push origin main
```

---

## Eliminar Post

```bash
rm posts/post-antiguo.md
git add posts/
git commit -m "Eliminar post"
git push origin main
```

---

## Cambiar Diseño

```bash
nano styles.css
git add styles.css
git commit -m "Actualizar estilos"
git push origin main
```

---

# 11. Solución de Problemas

## Error 404 al Cargar Posts

| Causa                      | Solución                                |
| -------------------------- | --------------------------------------- |
| Carpeta `posts/` no existe | Crear la carpeta y subir archivos `.md` |
| Repositorio privado        | Cambiar a público                       |
| POSTS_PATH incorrecto      | Verificar configuración en `index.html` |

---

## Giscus No Carga

| Causa                       | Solución                     |
| --------------------------- | ---------------------------- |
| Discussions no activado     | Activarlo en Settings        |
| Giscus no instalado         | Instalar la app Giscus       |
| IDs incorrectos             | Obtener nuevos en giscus.app |
| Sitio abierto con `file://` | Usar GitHub Pages            |

---

## Buscador No Funciona

| Causa                    | Solución                   |
| ------------------------ | -------------------------- |
| JavaScript deshabilitado | Activar JS en el navegador |
| Error en consola         | Revisar con F12            |
| Cache del navegador      | Ctrl + Shift + R           |

---

# 12. Recursos

## Enlaces Oficiales

| Recurso        | URL                             |
| -------------- | ------------------------------- |
| GitHub         | https://github.com              |
| GitHub Pages   | https://pages.github.com        |
| GitHub API     | https://docs.github.com/es/rest |
| Giscus         | https://giscus.app/es           |
| Marked.js      | https://marked.js.org           |
| Markdown Guide | https://www.markdownguide.org   |

---

# Licencia

**Licencia MIT**

Última revisión: **Marzo 2026**
Mantenido por: **neoxolotl**
Versión: **1.0**
