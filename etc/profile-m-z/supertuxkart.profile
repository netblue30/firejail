# Firejail profile for supertuxkart
# Description: Free kart racing game.
# This file is overwritten after every install/update
# Persistent local customizations
include supertuxkart.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/supertuxkart
noblacklist ${HOME}/.cache/supertuxkart
noblacklist ${HOME}/.local/share/supertuxkart

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/supertuxkart
mkdir ${HOME}/.cache/supertuxkart
mkdir ${HOME}/.local/share/supertuxkart
whitelist ${HOME}/.config/supertuxkart
whitelist ${HOME}/.cache/supertuxkart
whitelist ${HOME}/.local/share/supertuxkart
whitelist /usr/share/supertuxkart
whitelist /usr/share/games/supertuxkart	# Debian version
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink,bluetooth
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin supertuxkart
private-cache
# Add the next line to your supertuxkart.local if you do not need controller support.
#private-dev
private-etc @games,@tls-ca,@x11
private-tmp
private-srv none

dbus-user none
dbus-system none

restrict-namespaces
