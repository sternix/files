#!/bin/sh

# for AMD: kldload amdtemp
# for INTEL: kldload coretemp
# for persistence put 
# amdtemp_load="YES"
# coretemp_load="YES"
# to /boot/loader.conf

SYSCTL=/sbin/sysctl
AWK=/usr/bin/awk

cpus() {
	$SYSCTL -N dev.cpu | $AWK -F. '$4 == "temperature" {print $3}'
}

for cpu in $(cpus) ; do
	$SYSCTL -n dev.cpu.$cpu.temperature
done
