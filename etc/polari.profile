# Polari IRC profile
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

mkdir ${HOME}/.local/share/Empathy
whitelist ${HOME}/.local/share/Empathy
mkdir ${HOME}/.local/share/telepathy
whitelist ${HOME}/.local/share/telepathy
mkdir ${HOME}/.local/share/TpLogger
whitelist ${HOME}/.local/share/TpLogger
mkdir ${HOME}/.config/telepathy-account-widgets
whitelist ${HOME}/.config/telepathy-account-widgets
mkdir ${HOME}/.cache/telepathy
whitelist ${HOME}/.cache/telepathy
mkdir ${HOME}/.purple
whitelist ${HOME}/.purple
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
