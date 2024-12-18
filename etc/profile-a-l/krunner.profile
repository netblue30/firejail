# Firejail profile for krunner
# Description: Framework for providing different actions given a string query
# This file is overwritten after every install/update
# Persistent local customizations
include krunner.local
# Persistent global definitions
include globals.local

# Programs started in krunner run with this generic profile.
# When a file is opened in krunner, the file viewer runs in its own sandbox
# with its own profile, if it is sandboxed automatically.

#noblacklist ${HOME}/.cache/krunner
#noblacklist ${HOME}/.cache/krunnerbookmarkrunnerfirefoxdbfile.sqlite*
#noblacklist ${HOME}/.config/chromium
noblacklist ${HOME}/.config/krunnerrc
noblacklist ${HOME}/.kde/share/config/krunnerrc
noblacklist ${HOME}/.kde4/share/config/krunnerrc
#noblacklist ${HOME}/.local/share/baloo
#noblacklist ${HOME}/.mozilla

include disable-common.inc
#include disable-devel.inc
#include disable-interpreters.inc
#include disable-programs.inc

include whitelist-var-common.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp

#private-cache

restrict-namespaces
