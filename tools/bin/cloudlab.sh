#!/bin/bash
#
em_credentials='/path'
not_ready=true
usuario=$(printenv USER)
passphrase=""
#
# GET STATUS OF THE EXPERIMENT
get_status(){
	/usr/bin/expect <<-EOD
	spawn /code/tools/bin/experimentStatus ESPOL-sched,comp-rdbms
	expect "Enter PEM pass phrase:"
	send "$passphrase\r"
	expect eod
	EOD
}
#
# GET HOST OF THE NODE
get_host(){
	/usr/bin/expect <<-EOD
	spawn /code/tools/bin/experimentManifests ESPOL-sched,comp-rdbms
	expect "Enter PEM pass phrase:"
	send "$passphrase\r"
	expect eod
	EOD
}
#
# COPY EMULAB CREDENTIALS IN THE SSL DIRECTORY
#mkdir .ssl
#chmod 700 .ssl
#scp $em_credentials/\'cloudlab.pem\' .ssl/emulab.epm
#
# START AN EXPERIMENT IN CLOUDLABD
# $1 representa el primer argumento con el que se ejecuta el script, se espera qe sea el tipo de maquina 
# TODO:
#   falta crear los profiles en cloudlab
if [[ $1 == "d430" ]];
then
	if [[ $2 == "Ubuntu 18.04 LTS" ]];
	then
		/usr/bin/expect <<-EOD
		spawn /code/tools/bin/startExperiment --project ESPOL-sched --duration 2 --name comp-rdbms ESPOL-sched,tpcc-d430
		expect "Enter PEM pass phrase:"
		send "$passphrase\r"
		expect eod
		EOD
	elif [[ $2 == "Ubuntu 16.04 LTS" ]]; 
	then
		# Por agregar opcion
		echo "Pronto"
	elif [[ $2 == "Ubuntu 20.04 LTS" ]]; 
	then
		# Por agregar opcion
		echo "Pronto"
	else
		echo "The OS does not exists"
		exit
	fi
elif [[ $1 == "d710" ]];
then
	if [[ $2 == "Ubuntu 18.04 LTS" ]]; 
	then
		/usr/bin/expect <<-EOD
		spawn /code/tools/bin/startExperiment --project ESPOL-sched --duration 2 --name comp-rdbms ESPOL-sched,tpcc-d710
		expect "Enter PEM pass phrase:"
		send "$passphrase\r"
		expect eod
		EOD
	elif [[ $2 == "Ubuntu 16.04 LTS" ]]; 
	then
		# Por agregar opcion
		echo "Pronto"
	elif [[ $2 == "Ubuntu 20.04 LTS" ]];
	then
		# Por agregar opcion
		echo "Pronto"
	else
		echo "The OS does not exists"
		exit
	fi
else
	echo "The profile does not exists"
	exit
fi
#
# CHECK IF THE EXPERIMENT IS READY  
while [ $not_ready ]
do
	status=$(get_status)
	st_final=$(echo $status | grep -o 'Status:.*' | cut -f 2 -d " ")
	echo "Estado actual: $st_final"
	setup=$(get_status)
	su_final=$(echo $setup | grep -o 'Execute.*' | cut -f 4 -d" " | cut -f 2 -d'/')
	echo "SetUp Finished: $su_final"
	if [[ $st_final == *"ready"* ]] && [[ $su_final == *"1"* ]];
	then
		echo "The experiment is ready to use!"
		break
	fi
	echo "Sleep por 30s"
	sleep 30
done
#
# CONNECT VIA SSH
host=$(get_host)
ht_final=$(echo $host | grep -o 'hostname=.*' | cut -f 2 -d\" | cut -d'\' -f 1)
userC="$usuario"@"$ht_final"
echo "$userC"
#ssh -p 22 $userC
# TODO:
	#   Al crear experimento se debe ingresar una clave, preguntar como enviar esa contraseña por cli
