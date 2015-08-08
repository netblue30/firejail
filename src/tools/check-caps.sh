#!/bin/bash

if [ $# -eq 0 ]
then
	echo "Usage: check-caps.sh program-and-arguments"
	echo
fi

set -x

firejail --caps.drop=chown "$1"
firejail --caps.drop=dac_override "$1"
firejail --caps.drop=dac_read_search "$1"
firejail --caps.drop=fowner "$1"
firejail --caps.drop=fsetid "$1"
firejail --caps.drop=kill "$1"
firejail --caps.drop=setgid "$1"
firejail --caps.drop=setuid "$1"
firejail --caps.drop=setpcap "$1"
firejail --caps.drop=linux_immutable "$1"
firejail --caps.drop=net_bind_service "$1"
firejail --caps.drop=net_broadcast "$1"
firejail --caps.drop=net_admin "$1"
firejail --caps.drop=net_raw "$1"
firejail --caps.drop=ipc_lock "$1"
firejail --caps.drop=ipc_owner "$1"
firejail --caps.drop=sys_module "$1"
firejail --caps.drop=sys_rawio "$1"
firejail --caps.drop=sys_chroot "$1"
firejail --caps.drop=sys_ptrace "$1"
firejail --caps.drop=sys_pacct "$1"
firejail --caps.drop=sys_admin "$1"
firejail --caps.drop=sys_boot "$1"
firejail --caps.drop=sys_nice "$1"
firejail --caps.drop=sys_resource "$1"
firejail --caps.drop=sys_time "$1"
firejail --caps.drop=sys_tty_config "$1"
firejail --caps.drop=mknod "$1"
firejail --caps.drop=lease "$1"
firejail --caps.drop=audit_write "$1"
firejail --caps.drop=audit_control "$1"
firejail --caps.drop=setfcap "$1"
firejail --caps.drop=mac_override "$1"
firejail --caps.drop=mac_admin "$1"
firejail --caps.drop=syslog "$1"
firejail --caps.drop=wake_alarm "$1"
