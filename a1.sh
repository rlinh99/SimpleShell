#! /bin/bash
#get current host name of a server
CURRENT=$(hostname)

CURRENT_IP=$(hostname -I)
#get current inner ipv4 address of the server
for i in $CURRENT_IP
do
	if [[ $i == *"172."* ]];then
		CURRENT_INNER_IPv4="$i"
	fi
done

#get current outer ipv4 address of the running client
for i in $CURRENT_IP
do
	if [[ $i == *"192."* ]];then
		CURRENT_OUTER_IPv4="$i"
	fi
done

#pre-defined host names, used for host name testing
HOSTS="January February March December Autumn Spring November August October Solstice Year May July Winter Summer Fall April June September Equinox Unreachable1 Unreachable2"
NETWORKS="admin net16 net17 net18 net19"

#ipv6 server used to test is Autumn
DEST_IPV6="fdd0:8184:d967:17:ecc6:84e1:4920:8927 fdd0:8184:d967:8017:ecc6:84e1:4920:8927 fdd0:8184:d967:17:250:56ff:fe85:6737 fdd0:8184:d967:8017:250:56ff:fe85:6737"

echo Reachability to destination using Hostname
echo
echo Check connection start with 192.
for host in $HOSTS
do	
	#check connection of 192
	ping -c 1 "$host" >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo Host "$host" is Reachable from "$CURRENT" && tracepath "$host"
		#extra ping to make sure arp is working
		echo Ethernet address of the connection
		ping -c 1 "$host" >/dev/null && arp "$host"
	else
		echo Host "$host" is NOT Reachable from host "$CURRENT"
	fi
	echo
	echo Check connection start with 172.
	#check connection of 172
	for nw in $NETWORKS
	do
		ping -c 1 "$host.$nw" >/dev/null 2>&1
		if [ $? -eq 0 ]; then
			echo Host "$host.$nw" is Reachable from "$CURRENT" && tracepath "$host.$nw" 
			#extra ping to make sure arp is working
			echo Ethernet address of the connection
			ping -c 1 "$host.$nw" >/dev/null && arp "$host.$nw"
		else
			echo Host "$host.$nw" is NOT Reachable from host "$CURRENT"
		fi
		echo
	done
done

echo Reachbility to destination using IPv4
echo Check inner link "(addresses start with 172.)"
echo
	#check connection of inner link
for i in 16 17 18 19
do	
	for j in {1..20}
	do
		ping -c 1 "172.$i.1.$j" >/dev/null
		if [ $? -eq 0 ]; then
			echo Host "172.$i.1.$j" is Reachable from host "$CURRENT_INNER_IPv4" && tracepath "172.$i.1.$j" 
			#extra ping to make sure arp is working
			echo Ethernet address of the connection
			ping -c 1 "172.$i.1.$j" >/dev/null && arp "172.$i.1.$j"
		else
			echo Host "172.$i.1.$j" is NOT Reachable from "$CURRENT_INNER_IPv4"
		fi
		echo
	done
done

echo Reachbility to destination using IPv4
echo Check outer link "(addresses start with 192.)"
echo
	#check connection of outer link
for i in {1..25}
do
	ping -c 1 "192.168.0.$i" >/dev/null
	if [ $? -eq 0 ]; then
		echo Host "192.168.0.$i" is Reachable from host "$CURRENT_OUTER_IPv4" && tracepath "192.168.0.$i" 
		#extra ping to make sure arp is working
		echo Ethernet address of the connection
		ping -c 1 "192.168.0.$i" >/dev/null && arp "192.168.0.$i"
	else
		echo Host "192.168.0.$i" is NOT Reachable from "$CURRENT_OUTER_IPv4"
	fi
	echo
done

#ipv6 server used to test is Autumn
echo Reachbility to destination using IPv6
echo
for addr in $DEST_IPV6
do 
	ping6 -c 1 "$addr" >/dev/null
	if [ $? -eq 0 ]; then
		echo "$addr is reachable from current host" && tracepath6 "$addr"
	else
		echo "$addr is not reachable from current host"
	fi
done
