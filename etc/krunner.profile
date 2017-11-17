# Firejail profile for krunner
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/krunner.local
# Persistent global definitions
include /etc/firejail/globals.local

# start a program in krunner: program will run with this generic profile
# open a file in krunner: file viewer will run with its own profile (if firejailed automatically)

noblacklist ${HOME}/.config/krunnerrc
noblacklist ${HOME}/.kde/share/config/krunnerrc
noblacklist ${HOME}/.kde4/share/config/krunnerrc

include /etc/firejail/disable-common.inc
# include /etc/firejail/disable-devel.inc
# include /etc/firejail/disable-passwdmgr.inc
# include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
