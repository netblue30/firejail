# Epiphany browser profile
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-terminals.inc
whitelist ${DOWNLOADS}
whitelist ${HOME}/.local/share/epiphany
whitelist ${HOME}/.config/epiphany
whitelist ${HOME}/.cache/epiphany
include /etc/firejail/whitelist-common.inc
caps.drop all
seccomp
protocol unix,inet,inet6
netfilter

