# Firejail profile for gnome-schedule
# Description: Graphical interface to crontab and at for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-schedule.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.gnome/gnome-schedule

# Needs at and crontab to read/write user cron
nodeny  ${PATH}/at
nodeny  ${PATH}/crontab

# Needs access to these files/dirs
nodeny  /etc/cron.allow
nodeny  /etc/cron.deny
nodeny  /etc/shadow
nodeny  /var/spool/cron

# cron job testing needs a terminal, resulting in sandbox escape (see disable-common.inc)
# add 'noblacklist ${PATH}/your-terminal' to gnome-schedule.local if you need that functionality

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkfile ${HOME}/.gnome/gnome-schedule
allow  ${HOME}/.gnome/gnome-schedule
allow  /usr/share/gnome-schedule
allow  /var/spool/atd
allow  /var/spool/cron
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.keep chown,dac_override,setgid,setuid
ipc-namespace
machine-id
#net none - breaks on Ubuntu
no3d
nodvd
nogroups
noinput
nosound
notv
nou2f
novideo
shell none
tracelog

disable-mnt
private-cache
private-dev
writable-var

