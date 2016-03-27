# qTox instant messaging profile
noblacklist ${HOME}/.config/tox
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-terminals.inc
mkdir ${HOME}/.config/tox
whitelist ${HOME}/.config/tox
whitelist ${DOWNLOADS}
include /etc/firejail/whitelist-common.inc
caps.drop all
seccomp
protocol unix,inet,inet6
noroot
