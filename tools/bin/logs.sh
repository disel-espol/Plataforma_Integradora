usuario=$(printenv USER)
workdir=$(printenv PWD)
passCred="" #Passphrase for the credentials downloaded from CloudLab
passKey="" #Passphrase for the key used to connect through ssh


get_host(){
	/usr/bin/expect <<-EOD
	spawn $workdir/tools/bin/experimentManifests ESPOL-sched,comp-rdbms
	expect "Enter PEM pass phrase:"
	send "$passCred\r"
	expect eod
	EOD
}

get_status(){
	/usr/bin/expect <<-EOD
	spawn $workdir/tools/bin/experimentStatus ESPOL-sched,comp-rdbms
	expect "Enter PEM pass phrase:"
	send "$passCred\r"
	expect eod
	EOD
}


status=$(get_status)
st_final=$(echo "$status" | grep -o 'Status:.*' | cut -f 2 -d " ")
su_final=$(echo "$status" | grep -o 'Execute.*' | cut -f 4 -d" " | cut -f 2 -d'/')
if [[ $st_final == *"ready"* ]] && [[ $su_final == *"1"* ]];
then
	# CONNECT VIA SSH
	host=$(get_host)
	ht_final=$(echo $host | grep -o 'hostname=.*' | cut -f 2 -d\" | cut -d'\' -f 1)
	userC="$usuario"@"$ht_final"

	/usr/bin/expect <<-EOD
	spawn scp -P 22 $userC:~/logs.txt $workdir/media/logs.txt
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
	EOD
fi

