# Plataforma de comparación de rendimiento de RDBMS

## Previo la ejecución
Antes de empezar con la ejecución del proyecto se debe realizar lo siguiente:
1. Cambio de usuario
2. Cambio de contraseñas
3. Obtener credenciales de CloudLab
4. Copiar key para conexión por ssh

### 1. Cambio de usuario

En el archivo **Dockerfile** debe escribir su usuario de cloudlab en la variable USER (línea 3).

### 2. Cambio de contraseñas

En los archivos **tools/bin/cloudlab.sh** y **tools/bin/logs.sh** debe escribir sus contraseñas.
- **passCred**: Aquí va la constraseña de su cuenta de Cloudlab, esta es usada por las credenciales descritas en el punto 3.
- **passKey**: Aquí va la contraseña que usó al sacar el key para conectarse via ssh con los nodos de CloudLab.

### 3. Obtener credenciales de CloudLab

Para descargar las credenciales de la página de CloudLab, dar clic en su nombre en la esquina superior derecha y seleccione la opción **Download Credentials**. A este archivo deberá cambiarle el nombre a **emulab.pem** y colocarlo en la carpeta raíz de este proyecto.

### 4. Copiar key para conexión por ssh

En la carpeta raíz de este proyecto, debe crear una carpeta llamada **.ssh**, esto lo puede hacer con el comando:
```
mkdir .ssh
```

A esta carpeta creada debe copiar los archivos que corresponden a su key para conexión por ssh, estos pueden tener los nombres: **id_rsa.pub**, **id_ecdsa.pub**, **id_ed25519.pub**. Para esto puede usar el comando **scp**, por ejemplo:
```
scp ~/.ssh/id* /path_to/Plataforma_Integradora/.ssh
```

## Ejecución del proyecto con Docker
Una vez completados todos los pasos mencionados anteriormente, puede empezar con la creación del container de Docker usando los siguientes comandos:
```
docker-compose build
docker-compose up -d
```

En la carpeta tools se encuentran algunos archivos muy necesarios para el proyecto. Estos necesitan el salto de línea del formato Unix y también dependen de soft links entre archivos. Por esta razón se creó el archivo **docker.sh**, para ayudar con la conversión y creación de soft links. 

Como el proyecto fue hecho en Windows, el archivo **docker.sh** también necesita conversión del salto de línea previo a su uso, esto se lo puede logar ejecutando el siguiente comando usando una terminal de Ubuntu para Windows:
```
dos2unix docker.sh
```
Una vez hecha la conversión, puede ejecutar el archivo. Nótese que una vez realizado esto, no podrá volver a ejecutar los comandos de build y up de docker en Windows, por lo que se recomienda crear una copia de la carpeta tools antes de ejecutar este script.

### Cambios en fixtures
Información de tipos de hardware, sistemas operativos y rdbms (mostradas como opciones en la plataforma web) se encuentran detallas en la carpeta **fixtures**, son útiles ya que facilitan la carga de información en los modelos de Django. Cuando se agregue información a cualquiera de estos fixtures se necesitará actualizar los modelos, para esto está el archivo **load_fixtures.py** y lo puede ejecutar con:
```
py load_fixtures.py
```

Con todos esos detalles listos, la plataforma web está lista para ser usada.
