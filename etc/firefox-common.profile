# Firejail profile for firefox-common
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/firefox-common.local
# Persistent global definitions
include /etc/firejail/globals.local

# uncomment the following line to allow access to common programs/addons/plugins
#include /etc/firejail/firefox-common-addons.inc

noblacklist ${HOME}/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.pki
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
# machine-id breaks pulse audio; it should work fine in setups where sound is not required
#machine-id
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
