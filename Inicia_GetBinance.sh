#!/bin/bash

#######################################################################
#######################################################################
#COMO AGREGAR UNA UNIDAD DE DISCO A UNA NUEVA CARPETA RAIZ
#######################################################################
#######################################################################
#COMANDOS PROBADOS 21-ENE-2023

function Obtener_Disco_Data {
	OBT_SDA=`lsblk | grep sda | wc -l`
	OBT_SDB=`lsblk | grep sdb | wc -l`
	OBT_SDC=`lsblk | grep sdc | wc -l`
	OBT_SDD=`lsblk | grep sdd | wc -l`
	OBT_SDE=`lsblk | grep sde | wc -l`
	
	if [[ ${OBT_SDA} == "1" ]];
    then
        VAR_Disco="sda"
    fi
	if [[ ${OBT_SDB} == "1" ]];
    then
        VAR_Disco="sdb"
    fi
	if [[ ${OBT_SDC} == "1" ]];
    then
        VAR_Disco="sdc"
    fi
	if [[ ${OBT_SDD} == "1" ]];
    then
        VAR_Disco="sdd"
    fi
	if [[ ${OBT_SDE} == "1" ]];
    then
        VAR_Disco="sde"
    fi
}

echo "VAR_Disco: ["${VAR_Disco}"]"
Obtener_Disco_Data
echo "VAR_Disco: ["${VAR_Disco}"]"


#Ingresar como ROOT
#sudo su
#Realizar cambio de Zona Horaria
date
timedatectl set-timezone America/Lima
date
#Ver en forma de arbol las unidades o particiones creadas
lsblk

#Opcion (2) automatica de creacion de particiones
echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/${VAR_Disco}
lsblk


####OPCION 01
#ls -l /
#df -h
#mkdir -p /u01
#ls -l /
#mkfs.xfs /dev/sdc1
#mount /dev/sda1 /u01
#lsblk
#df -h
####OPCION 02
#Validar que se creo la particion en el arbol

ls -l /
df -h
mkdir -p /u01
ls -l /
mkfs.xfs /dev/${VAR_Disco}1

vgcreate datavg /dev/${VAR_Disco}1 -y
#vgcreate data2vg /dev/sdd1 -y

#VAR_Size=`fdisk -l | grep ${VAR_Disco}1 | awk -F' ' '{print $5}'`

#awk '{print ($0 ~ /T/)?T:G}'

lvcreate -L 1023G -n datalv datavg
#lvcreate -l 100 -n datalv datavg
#lvcreate -l 100 -n data2lv data2vg
mkfs.xfs /dev/datavg/datalv
mount /dev/datavg/datalv /u01
df -h
#lvextend -L +250G /dev/mapper/datavg-datalv -r
#lvextend -L +1200M /dev/mapper/datavg-datalv -r

#########################---------------------------------------------------------
##Si hubiera error en la instalación de Paquetes en Azure con Redhat y el Repositorio de Microsoft, usar los siguientes comandos
########Red Hat Enterprise Linux 8 for x86_64 - BaseOS - Extended Update Support from RHUI (RPMs)                                                                     0.0  B/s |   0  B     00:00
########Errors during downloading metadata for repository 'rhel-8-for-x86_64-baseos-eus-rhui-rpms':
########  - Curl error (56): Failure when receiving data from the peer for https://rhui-1.microsoft.com/pulp/repos/content/eus/rhel8/rhui/8.6/x86_64/baseos/os/repodata/repomd.xml [OpenSSL SSL_read: error:14094415:SSL routines:ssl3_read_bytes:sslv3 alert certificate expired, errno 0]
########  - Curl error (56): Failure when receiving data from the peer for https://rhui-2.microsoft.com/pulp/repos/content/eus/rhel8/rhui/8.6/x86_64/baseos/os/repodata/repomd.xml [OpenSSL SSL_read: error:14094415:SSL routines:ssl3_read_bytes:sslv3 alert certificate expired, errno 0]
########  - Curl error (56): Failure when receiving data from the peer for https://rhui-3.microsoft.com/pulp/repos/content/eus/rhel8/rhui/8.6/x86_64/baseos/os/repodata/repomd.xml [OpenSSL SSL_read: error:14094415:SSL routines:ssl3_read_bytes:sslv3 alert certificate expired, errno 0]
########Error: Failed to download metadata for repo 'rhel-8-for-x86_64-baseos-eus-rhui-rpms': Cannot download repomd.xml: Cannot download repodata/repomd.xml: All mirrors were tried
#(1)Opcional para detectar la solucion (probar directo paso "2")
###sudo su
###yum clean all
###yum check-update
###mkdir /tmp/rhui && cd /tmp/rhui
###wget https://github.com/Azure/azure-support-scripts/archive/refs/heads/master.zip && unzip master.zip 'azure-support-scripts-master/Linux_scripts/RHUI_repo_validation_scripts/*' && rm -f master.zip && cd azure-support-scripts-master/Linux_scripts/RHUI_repo_validation_scripts
###python3 repo_check.py
#(2) Paso final
#-----sudo su
#-----yum --disablerepo='*' remove 'rhui-azure-rhel8' -y
#-----wget https://rhelimage.blob.core.windows.net/repositories/rhui-microsoft-azure-rhel8-eus.config
#-----yum --config=rhui-microsoft-azure-rhel8-eus.config install rhui-azure-rhel8-eus -y
#-----yum update
#########################---------------------------------------------------------


#Instalar Telnet
#-----yum install -y telnet java
#-----yum install -y telnet
#Instalar Java 8
yum install -y java
#Verificar versión de Java
java -version

#Crear directorios de Trabajo
mkdir -p /u01/data


#chown -R user_crypto:user_crypto /u01/data/
##exit

#Trabajar con usuario INFAUSER
mkdir -p /u01/data/Descargas/Binance_API
mkdir -p /u01/data/Programa/Binance_Descarga/lib
mkdir -p /u01/data/Programa/GetFilesMetadataControl/lib

mkdir -p /u01/data/Dir_Data
mkdir -p /u01/data/Dir_Work/BINANCE_CSV
mkdir -p /u01/data/Dir_Work/BINANCE_JSON

cd /u01/data/Programa/Binance_Descarga
