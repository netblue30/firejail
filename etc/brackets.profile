# Firejail profile for brackets
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/brackets.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Brackets
noblacklist /opt/brackets/
noblacklist /opt/google/

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
# Comment out or use --ignore=net if you want to install extensions or themes
net none
# Disable these if you use live preview (until I figure out a workaround)
# Doing so should be relatively safe since there is no network access
noroot
seccomp

private-bin bash,brackets,readlink,dirname,google-chrome,cat
private-dev
