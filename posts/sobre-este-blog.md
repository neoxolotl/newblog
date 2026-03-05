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

* GitHub (almacenamiento)
* GitHub Pages (hosting)
* JavaScript vanilla (renderizado)
* Markdown (artículos)
* Giscus (comentarios)

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

* 60 requests por hora sin token
* 5000 requests por hora con token
* No recomendado para datos sensibles
* Ideal para menos de 1000 posts

---

# 2. Arquitectura

Flujo:

Usuario
↓
Navegador (index.html + CSS + JS)
↓
GitHub API
↓
Repositorio GitHub

Tecnologías utilizadas:

* HTML5
* CSS3
* JavaScript ES6+
* Markdown
* GitHub API v3
* Marked.js 4.x
* Giscus

---

3. Requisitos

Software requerido:

Git 2.0 o superior
Navegador moderno
Editor de texto (VS Code, Nano o Vim)

Cuentas necesarias:

GitHub (gratuita)
Giscus (gratuita)

Conocimientos recomendados:

Git básico
HTML y CSS básico
Markdown

No se requiere conocimiento avanzado de JavaScript.

---

4. Configuración Inicial

4.1 Crear repositorio

1. Inicia sesión en GitHub
2. Haz clic en el botón + y selecciona New repository
3. Nombre del repositorio: newblog
4. Debe ser público (requerido para GitHub Pages gratuito)
5. Presiona Create repository

---

4.2 Clonar repositorio

git clone https://github.com/TU-USUARIO/newblog.git
cd newblog

---

4.3 Activar Discussions

Ir a Settings del repositorio
Buscar la sección General → Features
Activar la opción Discussions
Guardar los cambios

---

5. Estructura del Proyecto

newblog/

index.html
styles.css
DOCUMENTACION.md

posts/

mi-primer-post.md
(otros posts)

---

6. Archivos del Proyecto

6.1 index.html

Configuración necesaria dentro del archivo:

const GITHUB_USERNAME = 'tu-usuario';
const GITHUB_REPO = 'newblog';
const POSTS_PATH = 'posts/';
const GITHUB_TOKEN = '';

---

6.2 styles.css

Este archivo contiene los estilos del sitio:

header
buscador
posts
renderizado markdown
giscus
footer
responsive

---

6.3 posts/*.md

Ejemplo de post:

---

title: Título del Post
date: 2026-03-05
tags: [categoria, tema]
-----------------------

# Contenido del Post

Escribe aquí tu artículo.

---

7. Configuración de Giscus

Giscus es un sistema de comentarios que utiliza GitHub Discussions como backend.

Pasos:

1. Activar Discussions en el repositorio
2. Instalar la aplicación Giscus
3. Obtener los IDs en https://giscus.app/es
4. Actualizar index.html

Configuración ejemplo:

script.setAttribute('data-repo', 'neoxolotl/newblog');
script.setAttribute('data-repo-id', 'R_kgDOXXXXXXXXXX');
script.setAttribute('data-category-id', 'DIC_kwDOXXXXXXXXXX');
script.setAttribute('data-lang', 'es');

---

8. GitHub Pages

Activación:

Ir a Settings → Pages
Seleccionar Deploy from a branch
Elegir la rama main
Carpeta root
Guardar cambios

URL del blog:

https://TU-USUARIO.github.io/newblog/

Tiempo de deploy aproximado: 1 a 3 minutos.

---

9. Agregar nuevos posts

Crear archivo:

nano posts/mi-nuevo-post.md

Estructura del post:

---

title: Mi Nuevo Post
date: 2026-03-06
tags: [tutorial, github]
------------------------

# Contenido

Escribe aquí.

Subir a GitHub:

git add posts/
git commit -m "Agregar nuevo post"
git push origin main

---

10. Mantenimiento

Actualizar post:

nano posts/mi-post.md
git add posts/
git commit -m "Actualizar post"
git push origin main

Eliminar post:

rm posts/post-antiguo.md
git add posts/
git commit -m "Eliminar post"
git push origin main

Cambiar diseño:

nano styles.css
git add styles.css
git commit -m "Actualizar estilos"
git push origin main

---

11. Solución de Problemas

Error 404 al cargar posts

Posibles causas:

La carpeta posts no existe
El repositorio es privado
POSTS_PATH incorrecto en index.html

Solución:

Crear la carpeta posts
Hacer el repositorio público
Verificar la configuración del path

---

Giscus no carga

Posibles causas:

Discussions no activado
Aplicación Giscus no instalada
IDs incorrectos
Sitio abierto con file://

Solución:

Activar Discussions
Instalar Giscus
Obtener nuevos IDs
Usar GitHub Pages

---

Buscador no funciona

Posibles causas:

JavaScript deshabilitado
Errores en consola
Cache del navegador

Solución:

Habilitar JavaScript
Abrir consola con F12
Limpiar cache con Ctrl + Shift + R

---

12. Recursos

GitHub
https://github.com

GitHub Pages
https://pages.github.com

GitHub API
https://docs.github.com/es/rest

Giscus
https://giscus.app/es

Marked.js
https://marked.js.org

Markdown Guide
https://www.markdownguide.org

---

Licencia MIT

Última revisión: Marzo 2026
Mantenido por: neoxolotl
Versión: 1.0
