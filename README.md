# Plataforma de comparación de rendimiento de RDBMS

Antes de empezar con la ejecución del proyecto se debe realizar lo siguiente:
1. Cambio de usuario
2. Cambio de contraseñas
3. Obtener credenciales de CloudLab

## 1. Cambio de usuario

En el archivo **Dockerfile** debe escribir su usuario de cloudlab en la variable USER (línea 3).

## 2. Cambio de contraseñas

En el archivo **tools/bin/cloudlab.sh** debe escribir sus contraseñas.
- **passCred**: Aquí va la constraseña de su cuenta de Cloudlab, esta es usada por las credenciales descritas en el punto 3.
- **passKey**: Aquí va la contraseña que usó al sacar el key para conectarse via ssh con los nodos de CloudLab.

## 3. Obtener credenciales de CloudLab

Para descargar las credenciales de la página de CloudLab, dar clic en su nombre en la esquina superior derecha y seleccione la opción **Download Credentials**. A este archivo deberá cambiarle el nombre a **emulab.pem** y colocarlo en la carpeta raíz de este proyecto.
