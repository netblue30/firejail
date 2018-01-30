# Firejail profile for kaffeine
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/kaffeine.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/kaffeinerc
noblacklist ~/.kde/share/apps/kaffeine
noblacklist ~/.kde/share/config/kaffeinerc
noblacklist ~/.kde4/share/apps/kaffeine
noblacklist ~/.kde4/share/config/kaffeinerc
noblacklist ~/.local/share/kaffeine

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
novideo
protocol unix,inet,inet6
seccomp
shell none

# private-bin kaffeine
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
