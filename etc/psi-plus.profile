# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/psi-plus.local

# Firejail profile for Psi+
noblacklist ${HOME}/.config/psi+
noblacklist ${HOME}/.local/share/psi+

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

whitelist ${DOWNLOADS}
mkdir ~/.config/psi+
whitelist ~/.config/psi+
mkdir ~/.local/share/psi+
whitelist ~/.local/share/psi+
mkdir ~/.cache/psi+
whitelist ~/.cache/psi+

include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
no3d
nogroups
nonewprivs
noroot
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp
disable-mnt

noexec ${HOME}
noexec /tmp
