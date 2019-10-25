# Firejail profile for firefox-common
# This file is overwritten after every install/update
# Persistent local customizations
include firefox-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

# noexec ${HOME} breaks DRM binaries.
?BROWSER_ALLOW_DRM: ignore noexec ${HOME}

# Uncomment the following line (or put it in your firefox-common.local) to allow access to common programs/addons/plugins.
#include firefox-common-addons.inc

noblacklist ${HOME}/.pki
noblacklist ${HOME}/.local/share/pki

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.pki
mkdir ${HOME}/.local/share/pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.pki
whitelist ${HOME}/.local/share/pki
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
# machine-id breaks pulse audio; it should work fine in setups where sound is not required.
#machine-id
netfilter
# nodbus breaks various desktop integration features
# among other things global menus, native notifications, Gnome connector, KDE connect and power management on KDE Plasma
nodbus
nodvd
nogroups
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
private-dev
# private-etc below works fine on most distributions. There are some problems on CentOS.
#private-etc alternatives,asound.conf,ca-certificates,crypto-policies,dconf,fonts,group,gtk-2.0,gtk-3.0,hostname,hosts,ld.so.cache,localtime,machine-id,mailcap,mime.types,nsswitch.conf,pango,passwd,pki,pulse,resolv.conf,selinux,ssl,X11,xdg
private-tmp
