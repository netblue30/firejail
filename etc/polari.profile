# Polari IRC profile
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-terminals.inc
whitelist ${HOME}/.local/share/Empathy
whitelist ${HOME}/.local/share/telepathy
whitelist ${HOME}/.local/share/TpLogger
whitelist ${HOME}/.config/dconf
whitelist ${HOME}/.config/telepathy-account-widgets
whitelist ${HOME}/.cache/telepathy
whitelist ${HOME}/.purple
include /etc/firejail/whitelist-common.inc
caps.drop all
seccomp
protocol unix,inet,inet6
noroot
