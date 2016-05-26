# Epiphany browser profile
noblacklist ${HOME}/.config/epiphany
noblacklist ${HOME}/.cache/epiphany
noblacklist ${HOME}/.local/share/epiphany

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

whitelist ${DOWNLOADS}
mkdir ${HOME}/.local
mkdir ${HOME}/.local/share
mkdir ${HOME}/.local/share/epiphany
whitelist ${HOME}/.local/share/epiphany
mkdir ${HOME}/.config
mkdir ${HOME}/.config/epiphany
whitelist ${HOME}/.config/epiphany
mkdir ${HOME}/.cache
mkdir ${HOME}/.cache/epiphany
whitelist ${HOME}/.cache/epiphany
include /etc/firejail/whitelist-common.inc
caps.drop all
seccomp
protocol unix,inet,inet6
netfilter
nonewprivs
