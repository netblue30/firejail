# Firejail profile for firefox-common
# This file is overwritten after every install/update
# Persistent local customizations
include firefox-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

# noexec ${HOME} breaks DRM binaries.
?BROWSER_ALLOW_DRM: ignore noexec ${HOME}
# noexec ${RUNUSER} breaks DRM binaries when using profile-sync-daemon.
?BROWSER_ALLOW_DRM: ignore noexec ${RUNUSER}

# Add the next line to your firefox-common.local to allow access to common programs/addons/plugins.
#include firefox-common-addons.profile

noblacklist ${HOME}/.local/share/pki
noblacklist ${HOME}/.pki

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc

mkdir ${HOME}/.local/share/pki
mkdir ${HOME}/.pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.local/share/pki
whitelist ${HOME}/.pki
whitelist /usr/share/doc
whitelist /usr/share/gtk-doc/html
whitelist /usr/share/mozilla
whitelist /usr/share/webext
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
# Fixme!
apparmor-replace
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
# Disable tracelog, it breaks or causes major issues with many firefox based browsers, see https://github.com/netblue30/firejail/issues/1930.
#tracelog

disable-mnt
?BROWSER_DISABLE_U2F: private-dev
# private-etc below works fine on most distributions. There could be some problems on CentOS.
private-etc @tls-ca,@x11,mailcap,mime.types,os-release
private-tmp

blacklist ${PATH}/curl
blacklist ${PATH}/wget
blacklist ${PATH}/wget2

# 'dbus-user none' breaks various desktop integration features like global menus, native notifications,
# Gnome connector, KDE connect and power management on KDE Plasma.
dbus-user none
dbus-system none

#restrict-namespaces
