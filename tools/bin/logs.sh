usuario=$(printenv USER)
workdir=$(printenv PWD)
passCred="" #Passphrase for the credentials downloaded from CloudLab
passKey="" #Passphrase for the key used to connect through ssh

get_host(){
	/usr/bin/expect <<-EOD
	spawn $workdir/tools/bin/experimentManifests ESPOL-sched,comp-rdbms2
	expect "Enter PEM pass phrase:"
	send "$passCred\r"
	expect eod
	EOD
}

# CONNECT VIA SSH
host=$(get_host)
ht_final=$(echo $host | grep -o 'hostname=.*' | cut -f 2 -d\" | cut -d'\' -f 1)
userC="$usuario"@"$ht_final"

/usr/bin/expect <<-EOD
spawn scp -P 22 $userC:~/logs.txt $workdir/logs.txt
expect "Enter passphrase for key*"
send "$passKey\r"
EOD
