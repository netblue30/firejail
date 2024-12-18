# Firejail profile for git
# Description: Fast, scalable, distributed revision control system
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include git.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/git
noblacklist ${HOME}/.config/nano
noblacklist ${HOME}/.emacs
noblacklist ${HOME}/.emacs.d
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.git-credential-cache
noblacklist ${HOME}/.git-credentials
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.nanorc
noblacklist ${HOME}/.vim
noblacklist ${HOME}/.viminfo

# Allow environment variables (rmenv'ed by disable-common.inc)
ignore rmenv GH_TOKEN
ignore rmenv GITHUB_TOKEN
ignore rmenv GH_ENTERPRISE_TOKEN
ignore rmenv GITHUB_ENTERPRISE_TOKEN

# Allow ssh (blacklisted by disable-common.inc)
include allow-ssh.inc

blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-exec.inc
include disable-programs.inc
include disable-x11.inc

whitelist /usr/share/git
whitelist /usr/share/git-core
whitelist /usr/share/gitgui
whitelist /usr/share/gitweb
whitelist /usr/share/nano
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
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

private-cache
private-dev

memory-deny-write-execute
restrict-namespaces
