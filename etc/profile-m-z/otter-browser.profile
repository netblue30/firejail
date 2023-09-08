# Firejail profile for otter-browser
# Description: Lightweight web browser based on Qt5
# This file is overwritten after every install/update
# Persistent local customizations
include otter-browser.local
# Persistent global definitions
include globals.local

?BROWSER_ALLOW_DRM: ignore noexec ${HOME}

noblacklist ${HOME}/.cache/Otter
noblacklist ${HOME}/.config/otter
noblacklist ${HOME}/.local/share/pki
noblacklist ${HOME}/.pki

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/Otter
mkdir ${HOME}/.config/otter
mkdir ${HOME}/.local/share/pki
mkdir ${HOME}/.pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/Otter
whitelist ${HOME}/.config/otter
whitelist ${HOME}/.local/share/pki
whitelist ${HOME}/.pki
whitelist /usr/share/otter-browser
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
?BROWSER_DISABLE_U2F: nou2f
protocol unix,inet,inet6,netlink
seccomp !chroot

disable-mnt
private-bin bash,otter-browser,sh,which
private-cache
?BROWSER_DISABLE_U2F: private-dev
private-etc @tls-ca,@x11,mailcap,mime.types
private-tmp

dbus-system none

#restrict-namespaces
