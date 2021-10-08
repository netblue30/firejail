# Firejail profile for luarocks
# Description: LuaRocks is the package manager for the Lua programming language.
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include luarocks.local
# Persistent global definitions
include globals.local

# Disallow blocking access to Lua header files.
noblacklist /usr/include/lua*
# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

blacklist ${RUNUSER}

include disable-common.inc
# luarocks can invoke compilers
#include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
# luarocks is hacky and needs shell access
#include disable-shell.inc
include disable-X11.inc
include disable-xdg.inc

whitelist ${HOME}/.netrc
whitelist ${HOME}/.config/pkcs11
whitelist ${HOME}/.wget-hsts
whitelist ${HOME}/.cache/luarocks
whitelist ${HOME}/luarocks/cmd/external
whitelist ${HOME}/.nix-profile/bin
whitelist ${HOME}/.luarocks
whitelist ${HOME}/.config/luarocks

whitelist /usr/share/lua
include whitelist-run-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

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
seccomp.block-secondary
shell none
tracelog

disable-mnt
private-cache
private-dev
#private-etc alternatives,ca-certificates,crypto-policies,luarocks,pki,ssl
private-tmp

dbus-user none
dbus-system none

read-write ${HOME}/.luarocks
