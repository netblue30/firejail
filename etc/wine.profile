# wine profile
noblacklist ${HOME}/.steam
noblacklist ${HOME}/.local/share/steam
noblacklist ${HOME}/.wine
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-terminals.inc
caps.drop all
netfilter
noroot
seccomp
