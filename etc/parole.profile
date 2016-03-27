# Profile for Parole, the default XFCE4 media player
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-terminals.inc
private-etc passwd,group,fonts
private-bin parole,dbus-launch
blacklist ${HOME}/.pki/nssdb
blacklist ${HOME}/.lastpass
blacklist ${HOME}/.keepassx
blacklist ${HOME}/.password-store
caps.drop all
seccomp
protocol unix,inet,inet6
netfilter
noroot
shell none
