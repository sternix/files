#!/bin/sh

# make executable and private script as
# chmod 700 /etc/ipfw.sh

# add variables to rc.conf as
# sysrc firewall_enable=YES
# sysrc firewall_logging=YES
# sysrc firewall_script=/etc/ipfw.sh

# if traffic shaping required  
# sysrc dummynet_enable=YES

# if in kernel nat required
# sysrc firewall_nat_enable=YES

# USAGE: 
# first test rules with 
# # /etc/ipfw.sh -n 
# then load 
# # /etc/ipfw.sh

# add allowed tcp ports here
allowed_tcp_ports="80 443 5432 22 8080"

# add allowed usp ports here
allowed_udp_ports="53"

# change this
ext_if="re0"
lan_if="wlan0"


# -n for testing rules, dont load rules
if [ "$#" -gt 0 ] && [ ! -z $1 ] && [ "$1" = "-n" ]; then
	cmd="/sbin/ipfw -q -n"
else
	cmd="/sbin/ipfw -q"
fi

# flush existing rules
$cmd -f flush
$cmd -f table all destroy

# non routable blocks
$cmd table nrb create
$cmd table nrb add 192.168.0.0/16 
$cmd table nrb add 172.16.0.0/12 
$cmd table nrb add 10.0.0.0/8 
$cmd table nrb add 127.0.0.0/8 
$cmd table nrb add 0.0.0.0/8 
$cmd table nrb add 169.254.0.0/16 
$cmd table nrb add 192.0.2.0/24 
$cmd table nrb add 204.152.64.0/23
$cmd table nrb add 224.0.0.0/3

#$cmd add deny all from table\(nrb\) to any via $ext_if

#$cmd nat 1 config if $ext_if

# block non routable blocks on ext interface
#for b in ${nrb} ; do
#	$cmd add deny all from $b to any in via $ext_if
#done

# antispoof
$cmd add deny ip from any to any not antispoof in

# setup loopback
$cmd add pass all from any to any via lo0
$cmd add deny all from any to 127.0.0.0/8
$cmd add deny ip from 127.0.0.0/8 to any

# reassembly incoming packets
$cmd add reass all from any to any in

# stateful filter
$cmd add check-state

# allow connections established below
$cmd add pass tcp from me to any established

# allow connection out, add state for each
$cmd add pass tcp from me to any setup keep-state
$cmd add pass udp from me to any keep-state
$cmd add pass icmp from me to any keep-state

# allow DHCP
$cmd add pass udp from 0.0.0.0 68 to 255.255.255.255 67 out
$cmd add pass udp from any 67 to me 68 in
$cmd add pass udp from any 67 to 255.255.255.255 68 in

# allow mandatory ICMP in
# 3 -> Destination Unreachable
# 8 -> Echo request
# 11 -> Time Exceeded
$cmd add pass icmp from any to any icmptype 3,8,11

# allow tcp ports defined top of script
for p in ${allowed_tcp_ports} ; do
	$cmd add pass tcp from any to me $p setup keep-state
done

# allow udp ports defined top of script
for p in ${allowed_udp_ports} ; do
	$cmd add pass udp from any to me $p keep-state
done

# deny broadcasts and multicasts
$cmd add deny ip from any to 255.255.255.255
$cmd add deny ip from any to 224.0.0.0/24

# deny noise from routers
$cmd add deny udp from any to any 520 in

# deny noise from webbrowsing
$cmd add deny log tcp from any 80,443 to any 1024-65535 in

# deny and log rest
$cmd add deny log ip from any to any
