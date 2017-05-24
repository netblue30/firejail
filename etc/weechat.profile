# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/weechat.local

# Weechat IRC profile
noblacklist ${HOME}/.weechat
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6
seccomp

# no private-bin support for various reasons:
# Plugins loaded: alias, aspell, charset, exec, fifo, guile, irc,
# logger, lua, perl, python, relay, ruby, script, tcl, trigger, xferloading plugins
