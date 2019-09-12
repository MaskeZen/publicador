# Publicador

Script para publicar proyectos mediante ssh a un servidor remoto.

## Uso

El script puede estar en cualquier ubicación, pero es recomendable tenerlo en la raíz del directorio a publicar.

El intercambio utiliza las herramientas `ssh`, `rsync` y `bash` o `gitbash` en ambientes windows y para iniciar seción intercambio de claves públicas.

Una vez que se cuenta con todas los programas (ssh, rsync, bash), se deben seguir unos pasos para agregar la clave publica al servidor remoto:

1. Crear key
  `ssh-keygen -t rsa -b 2048`
2. Copiar las claves al servidor:
  `ssh-copy-id id@server`
3. Para guardar el passphrase:
  `eval $(ssh-agent)`
  `ssh-add`

### Ambientes Windows

ssh se instala junto con git bash, por lo que de tener esa herramienta ya es suficiente.
rsync hay que agregarsela a gitbash. El ejecutable se encuentra en `./bin/rsync.zip`, es necesario extraer su contenido en el directorio `%ProgramFiles%\Git\usr\bin`.

## Configuración

Dentro del script hay una sección donde se ingresan los datos correspondientes a los directorios a sincronizar y el host remoto.

```s
local='./' # Directorio local del proyecto
rsyncignore='.rsyncignore' # contiene lista de archivos a ignorar (simil. .gitignore)
remote_sync='/apps/nombreapp_rsync/' # Directorio remoto donde se hará una primer subida para comparar con el resultado final.
remote_path='/apps/nombreapp/' # Directorio remoto final
remote_user='root' # Usuario remoto
remote_host='10.0.6.XXX' # Host remoto

app_user='tomcat' # Usuario propietario del directorio final
app_group='tomcat' # Grupo del directorio final
```
