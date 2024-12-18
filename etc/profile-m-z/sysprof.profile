# Firejail profile for sysprof
# Description: Kernel based performance profiler (GUI)
# This file is overwritten after every install/update
# Persistent local customizations
include sysprof.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}
include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

# Add the next lines to your sysprof.local if you don't need (yelp) help menu functionality.
#ignore noblacklist ${HOME}/.config/yelp
#ignore mkdir ${HOME}/.config/yelp
#nowhitelist ${HOME}/.config/yelp
#nowhitelist /usr/share/help/C/sysprof
#nowhitelist /usr/share/yelp
#nowhitelist /usr/share/yelp-tools
#nowhitelist /usr/share/yelp-xsl

noblacklist ${HOME}/.config/yelp
mkdir ${HOME}/.config/yelp
whitelist ${HOME}/.config/yelp
whitelist /usr/share/help/C/sysprof
whitelist /usr/share/yelp
whitelist /usr/share/yelp-tools
whitelist /usr/share/yelp-xsl

whitelist ${DOCUMENTS}
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
net none
no3d
nodvd
nogroups
noinput
nonewprivs
# Some older Debian/Ubuntu sysprof versions need root privileges.
# Add 'ignore noroot' to your sysprof.local if you run one of these.
noroot
nosound
notv
nou2f
novideo
protocol unix,netlink
seccomp
tracelog

disable-mnt
#private-bin sysprof # breaks help menu
private-cache
private-dev
private-etc @tls-ca
#private-lib # breaks help menu
#private-lib gdk-pixbuf-2.*,gio,gtk3,gvfs/libgvfscommon.so,libgconf-2.so.*,librsvg-2.so.*,libsysprof-2.so,libsysprof-ui-2.so
private-tmp

dbus-user filter
dbus-user.own org.gnome.Shell
dbus-user.own org.gnome.Yelp
dbus-user.own org.gnome.Sysprof3
dbus-user.talk ca.desrt.dconf

#memory-deny-write-execute # breaks on Arch
restrict-namespaces
