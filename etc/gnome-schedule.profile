# Firejail profile for gnome-schedule
# Description: Graphical interface to crontab and at for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-schedule.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.gnome/gnome-schedule

# Needs at and crontab to read/write user cron
noblacklist ${PATH}/at
noblacklist ${PATH}/crontab

# Needs access to these files/dirs
noblacklist /etc/cron.allow
noblacklist /etc/cron.deny
noblacklist /etc/shadow
noblacklist /var/spool/cron

# Needs a terminal for cron job test execution
noblacklist ${PATH}/lxterminal
noblacklist ${PATH}/gnome-terminal
noblacklist ${PATH}/gnome-terminal.wrapper
noblacklist ${PATH}/lilyterm
noblacklist ${PATH}/mate-terminal
noblacklist ${PATH}/mate-terminal.wrapper
noblacklist ${PATH}/pantheon-terminal
noblacklist ${PATH}/roxterm
noblacklist ${PATH}/roxterm-config
noblacklist ${PATH}/terminix
noblacklist ${PATH}/tilix
noblacklist ${PATH}/urxvtc
noblacklist ${PATH}/urxvtcd
noblacklist ${PATH}/xfce4-terminal
noblacklist ${PATH}/xfce4-terminal.wrapper

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
whitelist ${HOME}/.gnome/gnome-schedule
include whitelist-common.inc

apparmor
caps.keep chown,dac_override,setgid,setuid
ipc-namespace
machine-id
#net none - breaks on Ubuntu
no3d
nodvd
nogroups
nosound
notv
nou2f
novideo
shell none
tracelog

disable-mnt
private-cache
private-dev
# private-etc alternatives
writable-var

