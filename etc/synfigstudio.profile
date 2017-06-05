# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/synfigstudio.local

# synfigstudio
noblacklist ${HOME}/.config/synfig
noblacklist ${HOME}/.synfig
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix
seccomp

noexec ${HOME}
noexec ${HOME}/.local/share
noexec /tmp

private-dev
private-tmp
