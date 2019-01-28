#! /bin/bash
CURRENT=$(hostname)
HOSTS="Summer Fall Equinox"
NETWORKS="admin net16 net17 net18 net19"

Prefix="fdd0:8184:d967"

echo Reachability to destination using Hostname
echo

for host in $HOSTS
do	
	#check connection of 192
	ping -c 1 "$host" >/dev/null
	if [ $? -eq 0 ]; then
		echo Host "$host" is Reachable from "$CURRENT" && tracepath "$host" && arp "$host"
	else
		echo Host "$host" is NOT Reachable from "$CURRENT"
	fi
	echo
	#for nw in $NETWORKS


	#check connection of 172
done
