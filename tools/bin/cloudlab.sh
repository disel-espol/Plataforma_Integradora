#!/bin/bash

not_ready=true
usuario=$(printenv USER)
workdir=$(printenv PWD)
passCred="" #Passphrase for the credentials downloaded from CloudLab
passKey="" #Passphrase for the key used to connect through ssh
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
		spawn $workdir/tools/bin/startExperiment --project ESPOL-sched --duration 2 --name comp-rdbms ESPOL-sched,tpcc-d710
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
	echo "Sleep por 30s"
	sleep 30
done

sleep 35

# CONNECT VIA SSH
host=$(get_host)
ht_final=$(echo $host | grep -o 'hostname=.*' | cut -f 2 -d\" | cut -d'\' -f 1)
userC="$usuario"@"$ht_final"
echo "$userC"

if [[ $4 == "MySQL" ]];
then
	echo "Empezando pruebas con: db1" &>> $workdir/output.txt
	/usr/bin/expect <<-EOD
	set timeout -1
	spawn ssh -p 22 $userC
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
	send "sudo ~/sandboxes/msb_8_0_22/use -uroot -pmsandbox -e \"CREATE DATABASE database_mysql;\"\r"
	expect "*>"
	send "sudo ~/sandboxes/msb_8_0_22/use -uroot -pmsandbox -e \"CREATE USER 'pmm_mysql'@'localhost' IDENTIFIED BY '12345';\"\r"
	expect "*>"
	send "sudo ~/sandboxes/msb_8_0_22/use -uroot -pmsandbox -e \"GRANT ALL PRIVILEGES ON *.* TO 'pmm_mysql'@'localhost' WITH GRANT OPTION;\"\r"
	expect "*>"
	send "sudo ~/sandboxes/msb_8_0_22/use -uroot -pmsandbox -e \"FLUSH PRIVILEGES;\"\r"
	expect "*>"
	send "sudo pmm-admin add mysql --username=pmm_mysql --password=12345 --socket=/tmp/mysql_sandbox8022.sock --query-source=perfschema monitoring_mysql\r"
	expect "*>"
	send "cd sysbench-tpcc\r"
	expect "*>"
	send "./tpcc.lua --mysql-socket=/tmp/mysql_sandbox8022.sock --mysql-user=root --mysql-password=msandbox --mysql-db=database_mysql --threads=64 --tables=2 --scale=$3 --time=240 prepare\r"
	expect "*>"
	send "./tpcc.lua --mysql-socket=/tmp/mysql_sandbox8022.sock --mysql-user=root --mysql-password=msandbox --mysql-db=database_mysql --threads=64 --tables=2 --scale=$3 --time=240 --report-interval=1 run\r"
	expect "*>"
	send "./tpcc.lua --mysql-socket=/tmp/mysql_sandbox8022.sock --mysql-user=root --mysql-password=msandbox --mysql-db=database_mysql --threads=64 --tables=2 --scale=$3 --time=240 --report-interval=1 cleanup\r"
	expect "*>"
	send "exit\r"
	EOD
	echo "Terminaron pruebas con: db1" &>> $workdir/output.txt
	sleep 35
fi
if [[ $4 == "PostgreSQL" || $5 == "PostgreSQL" ]];
then
	base2="db2"
	if [[ $4 == "PostgreSQL" ]];
	then
		base2="db1"
	fi
	echo "Empezando pruebas con: $base2" &>> $workdir/output.txt
	/usr/bin/expect <<-EOD
	set timeout -1
	spawn ssh -p 22 $userC
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
	send "sudo -u postgres psql -c \"ALTER USER postgres PASSWORD '12345';\"\r"
	expect "*>"
	send "sudo -u postgres psql -c \"CREATE DATABASE database_postgres;\"\r"
	expect "*>"
	send "sudo -u postgres psql -c \"CREATE USER pmm_postgres WITH SUPERUSER ENCRYPTED PASSWORD '12345';\"\r"
	expect "*>"
	send "sudo pmm-admin add postgresql --username='pmm_postgres' --password=12345 monitoring_postgres\r"
	expect "*>"
	send "cd sysbench-tpcc\r"
	expect "*>"
	send "./tpcc.lua --pgsql-user=postgres --pgsql-password=12345 --pgsql-db=database_postgres --time=240 --threads=56 --report-interval=1 --tables=2 --scale=$3 --use_fk=0 --trx_level=RC --db-driver=pgsql prepare\r"
	expect "*>"
	send "./tpcc.lua --pgsql-user=postgres --pgsql-password=12345 --pgsql-db=database_postgres --time=240 --threads=56 --report-interval=1 --tables=2 --scale=$3 --use_fk=0 --trx_level=RC --db-driver=pgsql run\r"
	expect "*>"
	send "./tpcc.lua --pgsql-user=postgres --pgsql-password=12345 --pgsql-db=database_postgres --time=240 --threads=56 --report-interval=1 --tables=2 --scale=$3 --use_fk=0 --trx_level=RC --db-driver=pgsql cleanup\r"
	expect "*>"
	send "exit\r"
	EOD
	echo "Terminaron pruebas con: $base2" &>> $workdir/output.txt
	sleep 35
fi
if [[ $4 == "MariaDB" || $5 == "MariaDB" || $6 == "MariaDB" ]];
then
	base3="db3"
	if [[ $4 == "MariaDB" ]];
	then
		base3="db1"
	elif [[ $5 == "MariaDB" ]]; 
	then
		base3="db2"
	fi
	echo "Empezando pruebas con: $base3" &>> $workdir/output.txt
	/usr/bin/expect <<-EOD
	set timeout -1
	spawn ssh -p 22 $userC
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
	send "sudo ~/sandboxes/msb_10_5_8/use -uroot -pmsandbox -e \"CREATE DATABASE database_mariadb;\"\r"
	expect "*>"
	send "sudo ~/sandboxes/msb_10_5_8/use -uroot -pmsandbox -e \"CREATE USER 'pmm_mariadb'@'localhost' IDENTIFIED BY '12345';\"\r"
	expect "*>"
	send "sudo ~/sandboxes/msb_10_5_8/use -uroot -pmsandbox -e \"GRANT ALL PRIVILEGES ON *.* TO 'pmm_mariadb'@'localhost' WITH GRANT OPTION;\"\r"
	expect "*>"
	send "sudo ~/sandboxes/msb_10_5_8/use -uroot -pmsandbox -e \"FLUSH PRIVILEGES;\"\r"
	expect "*>"
	send "sudo pmm-admin add mysql --username=pmm_mariadb --password=12345 --socket=/tmp/mysql_sandbox10508.sock --query-source=perfschema monitoring_mariadb\r"
	expect "*>"
	send "cd sysbench-tpcc\r"
	expect "*>"
	send "./tpcc.lua --mysql-socket=/tmp/mysql_sandbox10508.sock --mysql-user=root --mysql-password=msandbox --mysql-db=database_mariadb --threads=64 --tables=2 --scale=$3 --time=240 prepare\r"
	expect "*>"
	send "./tpcc.lua --mysql-socket=/tmp/mysql_sandbox10508.sock --mysql-user=root --mysql-password=msandbox --mysql-db=database_mariadb --threads=64 --tables=2 --scale=$3 --time=240 --report-interval=1 run\r"
	expect "*>"
	send "./tpcc.lua --mysql-socket=/tmp/mysql_sandbox10508.sock --mysql-user=root --mysql-password=msandbox --mysql-db=database_mariadb --threads=64 --tables=2 --scale=$3 --time=240 --report-interval=1 cleanup\r"
	expect "*>"
	send "exit\r"
	EOD
	echo "Terminaron pruebas con: $base3" &>> $workdir/output.txt
fi
