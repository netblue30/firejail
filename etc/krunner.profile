# Firejail profile for krunner
# Description: Framework for providing different actions given a string query
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/krunner.local
# Persistent global definitions
include /etc/firejail/globals.local

# - programs started in krunner run with this generic profile.
# - when a file is opened in krunner, the file viewer runs in its own sandbox
#   with its own profile, if it is sandboxed automatically.

# noblacklist ${HOME}/.cache/krunner
# noblacklist ${HOME}/.cache/krunnerbookmarkrunnerfirefoxdbfile.sqlite*
# noblacklist ${HOME}/.config/chromium
noblacklist ${HOME}/.config/krunnerrc
noblacklist ${HOME}/.kde/share/config/krunnerrc
noblacklist ${HOME}/.kde4/share/config/krunnerrc
# noblacklist ${HOME}/.local/share/baloo
# noblacklist ${HOME}/.mozilla

include /etc/firejail/disable-common.inc
# include /etc/firejail/disable-devel.inc
# include /etc/firejail/disable-interpreters.inc
# include /etc/firejail/disable-passwdmgr.inc
# include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp

# private-cache
