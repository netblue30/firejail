# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/epiphany.local

# Epiphany browser profile
noblacklist ${HOME}/.config/epiphany
noblacklist ${HOME}/.local/share/epiphany
noblacklist ${HOME}/.cache/epiphany

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

whitelist ${DOWNLOADS}
mkdir ${HOME}/.local/share/epiphany
whitelist ${HOME}/.local/share/epiphany
mkdir ${HOME}/.config/epiphany
whitelist ${HOME}/.config/epiphany
mkdir ${HOME}/.cache/epiphany
whitelist ${HOME}/.cache/epiphany
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nonewprivs
protocol unix,inet,inet6
seccomp
