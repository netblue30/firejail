# Firejail profile for crow
# Description: A translator that allows to translate and say selected text using Google, Yandex and Bing translate API
# This file is overwritten after every install/update
# Persistent local customizations
include crow.local
# Persistent global definitions
include globals.local

mkdir ${HOME}/.config/crow
mkdir ${HOME}/.cache/gstreamer-1.0
whitelist ${HOME}/.config/crow
whitelist ${HOME}/.cache/gstreamer-1.0

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
private-bin crow
private-dev
private-etc alternatives,asound.conf,ca-certificates,crypto-policies,dconf,fonts,ld.so.preload,machine-id,nsswitch.conf,pki,pulse,resolv.conf,ssl
private-opt none
private-tmp
private-srv none

