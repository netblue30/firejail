# Firejail profile for okular
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/okular.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/okular
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
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

apparmor
caps.drop all
machine-id
# net none
netfilter
# nodbus
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
private-etc alternatives,cups,fonts,kde4rc,kde5rc,ld.so.cache,machine-id,xdg
# private-tmp - on KDE we need access to the real /tmp for data exchange with email clients

# memory-deny-write-execute
noexec ${HOME}
noexec /tmp

join-or-start okular
