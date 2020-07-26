# Firejail profile for telegram
# This file is overwritten after every install/update
# Persistent local customizations
include telegram.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.TelegramDesktop
noblacklist ${HOME}/.local/share/TelegramDesktop

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp

disable-mnt
private-cache
#<<<<<<< HEAD
#<<<<<<< HEAD
#<<<<<<< HEAD
#private-etc ca-certificates,crypto-policies,fonts,ld.so.cache,localtime,machine-id,pki,pulse,resolv.conf,ssl
#=======
#private-etc fonts,resolv.conf,ld.so.cache,localtime,ca-certificates,ssl,pki,pulse
#>>>>>>> Create telegram.profile
#=======
#private-etc fonts,resolv.conf,ld.so.cache,localtime,ca-certificates,ssl,pki,pulse
#>>>>>>> Revert "Delete telegram.profile"
#=======
#private-etc fonts,resolv.conf,ld.so.cache,localtime,ca-certificates,ssl,pki,pulse
#>>>>>>> Revert "Delete telegram.profile"
#=======
#private-etc ca-certificates,crypto-policies,fonts,ld.so.cache,localtime,machine-id,pki,pulse,resolv.conf,ssl
#>>>>>>> parent of 17517516... Create telegram.profile
#private-tmp
