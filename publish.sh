#!/usr/bin/env bash

# Script para publicar aplicaciones a un equipo remoto mediante rsync.
# version 1.0.0-beta 

# PRE CONFIGURACIÓN:
# Crear key
#   $ ssh-keygen -t rsa -b 2048
# Copiar las claves al servidor:
#   $ ssh-copy-id id@server
# Para guardar el passphrase 
#   $ eval $(ssh-agent)
#   $ ssh-add
# CONFIGURACIÓN --------------------
local='./'
rsyncignore='.rsyncignore'
remote_sync='/apps/nombreapp_rsync/'
remote_path='/apps/nombreapp/'
remote_user='root'
remote_host='10.0.6.XXX'      #DESARROLLO
# remote_host='10.0.9.XXX'    #PREPRODUCCIÓN

app_user='tomcat'
app_group='tomcat'
# ----------------------------------

# Ingreso de credenciales   
eval $(ssh-agent) 
ssh-add
# Ingreso de credenciales

echo 'Sincronizando el directorio de intercambio:'
rsync -av --exclude-from $rsyncignore --delete $local $rsyncignore $remote_user@$remote_host:$remote_sync

status=$?
echo "codigo de estado: $status"
echo "----------------------------------------------------------------------"
if [ $status != 0 ]
then
    echo 'Error al intentar sincronizar el directorio de intercambio.' 
    exit $status
fi

# Cambia el usuario del directorio
echo "Estado actual del directorio de sincronización:"
ssh $remote_user@$remote_host chown $app_user:$app_group -R $remote_sync
ssh $remote_user@$remote_host ls -l $remote_sync

status=$?
echo "codigo de estado: $status"
echo "----------------------------------------------------------------------"

# DRY RUN
ssh $remote_user@$remote_host rsync -avni --exclude-from $remote_sync$rsyncignore --delete $remote_sync $remote_path
ssh $remote_user@$remote_host diff -ur --exclude-from=$remote_sync$rsyncignore $remote_path $remote_sync

echo "----------------------------------------------------------------------"
read -p '¿Desea confirmar la sincronización?, si/no: ' confirmar

if [ "$confirmar" == "si" ]
then
    ssh $remote_user@$remote_host rsync -av --exclude-from $remote_sync$rsyncignore --delete $remote_sync $remote_path
    
    status=$?
    if [ $status == 0 ]
    then
        echo "Sincronización realizada con éxito."
    else
        echo "codigo de estado: $status"
        echo "Falló la sincronización."
    fi
else
    echo 'Se canceló la sincronización'
fi
