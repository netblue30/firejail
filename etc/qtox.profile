# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/qtox.local

# qTox instant messaging profile
noblacklist ~/.config/tox
noblacklist ~/.config/qt5ct
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

mkdir ${HOME}/.config/tox
whitelist ${HOME}/.config/tox
mkdir ${HOME}/.config/qt5ct
whitelist ${HOME}/.config/qt5ct
whitelist ${DOWNLOADS}

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none
tracelog

noexec ${HOME}
noexec /tmp

private-bin qtox
private-tmp
