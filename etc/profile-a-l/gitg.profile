# Firejail profile for gitg
# Description: Git repository viewer
# This file is overwritten after every install/update
# Persistent local customizations
include gitg.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/git
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.git-credentials
noblacklist ${HOME}/.local/share/gitg

# Allow ssh (blacklisted by disable-common.inc)
include allow-ssh.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

#whitelist ${HOME}/YOUR_GIT_PROJECTS_DIRECTORY
#whitelist ${HOME}/.config/git
#whitelist ${HOME}/.gitconfig
#whitelist ${HOME}/.git-credentials
#whitelist ${HOME}/.local/share/gitg
#whitelist ${HOME}/.ssh
#include whitelist-common.inc

whitelist /usr/share/gitg
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
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

private-bin git,gitg,ssh
private-cache
private-dev
private-tmp

dbus-user filter
dbus-user.own org.gnome.gitg
dbus-user.talk ca.desrt.dconf
# Add the next line to your gitg.local if you need keyring access.
#dbus-user.talk org.freedesktop.secrets
dbus-system none
