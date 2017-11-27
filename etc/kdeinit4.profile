# Firejail profile for kdeinit4
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/kdeinit4.local
# Persistent global definitions
include /etc/firejail/globals.local

# use outside KDE Plasma 4

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
no3d
nogroups
nonewprivs
# nosound - disabled for knotify
noroot
novideo
notv
protocol unix,inet,inet6,netlink
seccomp
shell none

private-bin kdeinit4,kbuildsycoca4,kded4,knotify4
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
