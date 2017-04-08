# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/baloo_file.local

# KDE Baloo file daemon profile
noblacklist ${HOME}/.kde4/share/config/baloofilerc
noblacklist ${HOME}/.kde4/share/config/baloorc
noblacklist ${HOME}/.kde/share/config/baloofilerc
noblacklist ${HOME}/.kde/share/config/baloorc
noblacklist ${HOME}/.config/baloofilerc
noblacklist ${HOME}/.local/share/baloo
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
nosound
protocol unix
# Baloo makes ioprio_set system calls, which are blacklisted by default. 
# That's why we need to disable seccomp
#seccomp

private-dev
private-tmp

# Experimental: make home directory read-only and allow writing only
# to Baloo configuration files and databases
#read-only  ${HOME}
#read-write ${HOME}/.kde4/share/config/baloofilerc
#read-write ${HOME}/.kde4/share/config/baloorc
#read-write ${HOME}/.kde/share/config/baloofilerc
#read-write ${HOME}/.kde/share/config/baloorc
#read-write ${HOME}/.config/baloofilerc
#read-write ${HOME}/.local/share/baloo
#read-write ${HOME}/.local/share/akonadi/search_db
