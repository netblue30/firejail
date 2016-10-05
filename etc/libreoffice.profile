# Firejail profile for LibreOffice
noblacklist ~/.config/libreoffice
noblacklist /usr/local/sbin
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
tracelog

private-dev
# whitelist /tmp/.X11-unix/
