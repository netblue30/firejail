# XChat IRC profile
noblacklist ${HOME}/.config/xchat
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-terminals.inc
blacklist ${HOME}/.wine
caps.drop all
seccomp
protocol unix,inet,inet6
noroot
