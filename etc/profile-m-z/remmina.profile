# Firejail profile for remmina
# Description: GTK+ Remote Desktop Client
# This file is overwritten after every install/update
# Persistent local customizations
include remmina.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.remmina
noblacklist ${HOME}/.config/remmina
noblacklist ${HOME}/.local/share/remmina

# Allow ssh (blacklisted by disable-common.inc)
include allow-ssh.inc
# Remmina needs to load some modules
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-runuser-common.inc
include whitelist-var-common.inc

caps.drop all
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp

private-cache
private-dev
private-tmp

