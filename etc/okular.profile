# Firejail profile for okular
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/okular.local
# Persistent global definitions
include /etc/firejail/globals.local

# blacklist /run/user/*/bus

noblacklist ${HOME}/.config/okularpartrc
noblacklist ${HOME}/.config/okularrc
noblacklist ${HOME}/.kde/share/apps/okular
noblacklist ${HOME}/.kde/share/config/okularpartrc
noblacklist ${HOME}/.kde/share/config/okularrc
noblacklist ${HOME}/.kde4/share/apps/okular
noblacklist ${HOME}/.kde4/share/config/okularpartrc
noblacklist ${HOME}/.kde4/share/config/okularrc
noblacklist ${HOME}/.local/share/okular

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
machine-id
# net none
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

private-bin okular,kbuildsycoca4,kdeinit4,lpr
private-dev
private-etc alternatives,cups,fonts,ld.so.cache,machine-id
# private-tmp - on KDE we need access to the real /tmp for data exchange with thunderbird

# memory-deny-write-execute
noexec ${HOME}
noexec /tmp
