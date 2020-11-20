# Firejail profile for yelp
# Description: Help browser for the GNOME desktop
# This file is overwritten after every install/update
# Persistent local customizations
include yelp.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/yelp

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/yelp
whitelist ${HOME}/.config/yelp
whitelist /usr/share/doc
whitelist /usr/share/groff
whitelist /usr/share/help
whitelist /usr/share/man
whitelist /usr/share/yelp
whitelist /usr/share/yelp-tools
whitelist /usr/share/yelp-xsl
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
seccomp.block-secondary
shell none
tracelog

disable-mnt
private-bin groff,man,tbl,troff,yelp
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,crypto-policies,cups,dconf,drirc,fonts,gcrypt,groff,gtk-3.0,machine-id,man_db.conf,openal,os-release,pulse,sgml,xml
private-tmp

dbus-system none

# read-only ${HOME} breaks some not necesarry featrues, comment it if
# you need them or put 'ignore read-only ${HOME}' into your yelp.local.
# broken features:
#  1. yelp --editor-mode
#  2. saving the window geometry
read-only ${HOME}
read-write ${HOME}/.cache
