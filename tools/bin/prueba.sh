#!/bin/bash

not_ready=true
usuario=$(printenv USER)
workdir=$(printenv PWD)
passCred="Sofia*1497" #Passphrase for the credentials downloaded from CloudLab
passKey="Sofia*1497" #Passphrase for the key used to connect through ssh
#
# GET STATUS OF THE EXPERIMENT
get_status(){
	/usr/bin/expect <<-EOD
	spawn $workdir/tools/bin/experimentStatus ESPOL-sched,comp-rdbms
	expect "Enter PEM pass phrase:"
	send "$passCred\r"
	expect eod
	EOD
}

# GET HOST OF THE NODE
get_host(){
	/usr/bin/expect <<-EOD
	spawn $workdir/tools/bin/experimentManifests ESPOL-sched,comp-rdbms
	expect "Enter PEM pass phrase:"
	send "$passCred\r"
	expect eod
	EOD
}

# START AN EXPERIMENT IN CLOUDLABD
# TODO:
#   falta crear los profiles en cloudlab
if [[ $1 == "d430" ]];
then
	if [[ $2 == "Ubuntu 18.04 LTS" ]];
	then
		/usr/bin/expect <<-EOD
		spawn $workdir/tools/bin/startExperiment --project ESPOL-sched --duration 2 --name comp-rdbms ESPOL-sched,tpcc3-d430
		expect "Enter PEM pass phrase:"
		send "$passCred\r"
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
		spawn $workdir/tools/bin/startExperiment --project ESPOL-sched --duration 2 --name comp-rdbms ESPOL-sched,tpcc-d710-2
		expect "Enter PEM pass phrase:"
		send "$passCred\r"
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

# CHECK IF THE EXPERIMENT IS READY  
while [ $not_ready ]
do
	status=$(get_status)
	st_final=$(echo "$status" | grep -o 'Status:.*' | cut -f 2 -d " ")
	echo "Estado actual: $st_final" &>> $workdir/output.txt
	#setup=$(get_status)
	su_final=$(echo "$status" | grep -o 'Execute.*' | cut -f 4 -d" " | cut -f 2 -d'/')
	echo "SetUp Finished: $su_final" &>> $workdir/output.txt
	if [[ $st_final == *"ready"* ]] && [[ $su_final == *"1"* ]];
	then
		echo "The experiment is ready to use!"
		break
	fi
	if [[ $st_final == *"failed"* ]];
	then
		echo "The experiment failed"
		exit
	fi
	echo "Sleep por 30s"
	sleep 30
done
sleep 35

echo "toy fuera"
# CONNECT VIA SSH
host=$(get_host)
ht_final=$(echo $host | grep -o 'hostname=.*' | cut -f 2 -d\" | cut -d'\' -f 1)
userC="$usuario"@"$ht_final"
echo "$userC"

if [[ $7 == "exist" ]];
then
	/usr/bin/expect <<-EOD
	spawn ssh -p 22 -o ServerAliveInterval=30 $userC
	expect {
		"Are you sure you want to continue connecting*" {
			send "yes\r"
		}
		"Enter passphrase for key*" {
			send "$passKey\r"
		}
	}
	expect {
		"Enter passphrase for key*" {
			send "$passKey\r"
		}
		"*>" {
			send "echo ok\r"
		}
	}
	expect "*>"
	send "sudo chmod 777 ~/sandboxes/msb_8_0_22/my.sandbox.cnf\r"
	expect "*>"
	send "exit\r"
	expect eod
	EOD
	/usr/bin/expect <<-EOD
	spawn scp -P 22 $workdir/media/mysql.cnf $userC:~/sandboxes/msb_8_0_22/my.sandbox.cnf
	expect "Enter passphrase for key*"
	send "$passKey\r"
	expect eod
	EOD
fi