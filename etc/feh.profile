# Firejail profile for feh
# Description: imlib2 based image viewer
# This file is overwritten after every install/update
# Persistent local customizations
include feh.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

#X11: include whitelist-runuser-common.inc

# This profile disables network access
# In order to enable network access,
# uncomment the following or put it in your feh.local:
# include feh-network.inc

caps.drop all
net none
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none

private-bin feh,jpegexiforient,jpegtran
private-cache
private-dev
private-etc alternatives,feh
private-tmp
