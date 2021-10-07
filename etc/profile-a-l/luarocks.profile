# Firejail profile for luarocks
# Description: LuaRocks is the package manager for the Lua programming language.
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include luarocks.local
# Persistent global definitions
include globals.local

# disable blacklist for lua interpreter paths
noblacklist ${PATH}/lua*
noblacklist /usr/include/lua*
noblacklist /usr/lib/liblua*
noblacklist /usr/lib/lua
noblacklist /usr/lib64/liblua*
noblacklist /usr/lib64/lua
noblacklist /usr/share/lua*

include disable-common.inc
# luarocks can invoke compilers
#include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
# luarocks is hacky and needs shell access
#include disable-shell.inc
include disable-write-mnt.inc
include disable-xdg.inc

allow ${HOME}/.netrc
allow ${HOME}/.config/pkcs11
allow ${HOME}/.wget-hsts
allow ${HOME}/.cache/luarocks
allow ${HOME}/luarocks/cmd/external
allow ${HOME}/.nix-profile/bin
allow ${HOME}/.luarocks
allow ${HOME}/.config/luarocks

allow /usr/share/ca-certificates
allow /usr/share/p11-kit
allow /usr/share/terminfo
allow /usr/share/lua

# apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
#private-bin md5sum,chmod,unzip,wget,gcc,bash,lua,luarocks
private-cache
private-dev
#private-etc ssl,ca-certificates,pkcs11,wgetrc,login.defs,luarocks,
private-tmp

dbus-user none
dbus-system none

read-write ${HOME}/.luarocks
