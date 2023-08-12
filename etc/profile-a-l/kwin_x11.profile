# Firejail profile for kwin_x11
# This file is overwritten after every install/update
# Persistent local customizations
include kwin_x11.local
# Persistent global definitions
include globals.local

# fix automatic kwin_x11 sandboxing:
# echo KDEWM=kwin_x11 >> ~/.pam_environment

noblacklist ${HOME}/.cache/kwin
noblacklist ${HOME}/.config/kwinrc
noblacklist ${HOME}/.config/kwinrulesrc
noblacklist ${HOME}/.local/share/kwin

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-run-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
tracelog

disable-mnt
private-bin kwin_x11
private-dev
private-etc @x11
private-tmp

restrict-namespaces
