# Firejail profile for Visual Studio Code
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/code.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.vscode
noblacklist ${HOME}/.config/Code

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

private-cache
private-dev
private-tmp

# Disabling noexec ${HOME} for now since it will
# probably interfere with running some programmes
# in VS Code
# noexec ${HOME}
noexec /tmp
