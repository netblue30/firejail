# Firejail profile for catfish
# Description: File searching tool
# This file is overwritten after every install/update
# Persistent local customizations
include catfish.local
# Persistent global definitions
include globals.local

# We can't blacklist much since catfish
# is for finding files/content

noblacklist ${HOME}/.config/catfish

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

# include disable-common.inc
# include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
# include disable-programs.inc

whitelist /var/lib/mlocate
include whitelist-var-common.inc

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
novideo
protocol unix
seccomp
shell none
tracelog

# These options work but are disabled in case
# a users wants to search in these directories.
# private-bin bash,catfish,env,locate,ls,mlocate,python*
# private-dev
#private-etc Trolltech.conf,X11,alternatives,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,pango,passwd,xdg
# private-tmp
