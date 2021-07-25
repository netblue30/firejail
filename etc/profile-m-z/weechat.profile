# Firejail profile for weechat
# Description: Fast, light and extensible chat client
# This file is overwritten after every install/update
# Persistent local customizations
include weechat.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.weechat

include disable-common.inc
include disable-programs.inc

whitelist /usr/share/weechat
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp

# no private-bin support for various reasons:
# Plugins loaded: alias, aspell, charset, exec, fifo, guile, irc,
# logger, lua, perl, python, relay, ruby, script, tcl, trigger, xferloading plugins
