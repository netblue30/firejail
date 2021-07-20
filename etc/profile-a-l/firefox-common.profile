# Firejail profile for firefox-common
# This file is overwritten after every install/update
# Persistent local customizations
include firefox-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

# noexec ${HOME} breaks DRM binaries.
?BROWSER_ALLOW_DRM: ignore noexec ${HOME}

# Add the next line to your firefox-common.local to allow access to common programs/addons/plugins.
#include firefox-common-addons.profile

nodeny  ${HOME}/.pki
nodeny  ${HOME}/.local/share/pki
nodeny  ${RUNUSER}/*firefox* # location of profiles if profile-sync-daemon is used

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.pki
mkdir ${HOME}/.local/share/pki
allow  ${DOWNLOADS}
allow  ${HOME}/.pki
allow  ${HOME}/.local/share/pki
allow ${RUNUSER}/*firefox*
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
# machine-id breaks pulse audio; add it to your firefox-common.local if sound is not required.
#machine-id
netfilter
nodvd
nogroups
noinput
nonewprivs
# noroot breaks GTK_USE_PORTAL=1 usage, see https://github.com/netblue30/firejail/issues/2506.
noroot
notv
?BROWSER_DISABLE_U2F: nou2f
protocol unix,inet,inet6,netlink
# The below seccomp configuration still permits chroot syscall. See https://github.com/netblue30/firejail/issues/2506 for possible workarounds.
seccomp !chroot
shell none
# Disable tracelog, it breaks or causes major issues with many firefox based browsers, see https://github.com/netblue30/firejail/issues/1930.
#tracelog

disable-mnt
?BROWSER_DISABLE_U2F: private-dev
# private-etc below works fine on most distributions. There are some problems on CentOS.
# Add it to your firefox-common.local if you want to enable it.
#private-etc alternatives,asound.conf,ca-certificates,crypto-policies,dconf,fonts,group,gtk-2.0,gtk-3.0,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,localtime,machine-id,mailcap,mime.types,nsswitch.conf,pango,passwd,pki,pulse,resolv.conf,selinux,ssl,X11,xdg
private-tmp

# 'dbus-user none' breaks various desktop integration features like global menus, native notifications,
# Gnome connector, KDE connect and power management on KDE Plasma.
dbus-user none
dbus-system none
