# Firejail profile for telegram
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/telegram.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.TelegramDesktop
noblacklist ${HOME}/.local/share/TelegramDesktop

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-programs.inc

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
private-tmp

noexec ${HOME}
noexec /tmp
