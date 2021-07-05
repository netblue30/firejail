# Firejail profile for ephemeral
# Description: The always-incognito web browser
# This file is overwritten after every install/update
# Persistent local customizations
include ephemeral.local
# Persistent global definitions
include globals.local

# enforce private-cache
#noblacklist ${HOME}/.cache/ephemeral

nodeny  ${HOME}/.pki
nodeny  ${HOME}/.local/share/pki

# noexec ${HOME} breaks DRM binaries.
?BROWSER_ALLOW_DRM: ignore noexec ${HOME}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

# enforce private-cache
#mkdir ${HOME}/.cache/ephemeral
mkdir ${HOME}/.pki
mkdir ${HOME}/.local/share/pki
# enforce private-cache
#whitelist ${HOME}/.cache/ephemeral
allow  ${HOME}/.pki
allow  ${HOME}/.local/share/pki
allow  ${DOWNLOADS}
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
# machine-id breaks pulse audio; it should work fine in setups where sound is not required.
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
seccomp
shell none
tracelog

disable-mnt
private-cache
?BROWSER_DISABLE_U2F: private-dev
# private-etc below works fine on most distributions. There are some problems on CentOS.
#private-etc alternatives,asound.conf,ca-certificates,crypto-policies,dconf,fonts,group,gtk-2.0,gtk-3.0,hostname,hosts,ld.so.cache,localtime,login.defs,machine-id,mailcap,mime.types,nsswitch.conf,os-release,pango,passwd,pki,pulse,resolv.conf,selinux,ssl,X11,xdg
private-tmp

# breaks preferences
# dbus-user none
# dbus-system none
