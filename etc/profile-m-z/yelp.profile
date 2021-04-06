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
# machine-id breaks sound - add the next line to your yelp.local if you don't need sound support.
#machine-id
net none
nodvd
nogroups
nonewprivs
noroot
# nosound - add the next line to your yelp.local if you don't need sound support.
#nosound
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

dbus-user filter
dbus-user.own org.gnome.Yelp
dbus-user.talk ca.desrt.dconf
dbus-system none

# read-only ${HOME} breaks some features:
#  1. yelp --editor-mode
#  2. saving the window geometry
# add 'ignore read-only ${HOME}' to your yelp.local if you need these features.
read-only ${HOME}
read-write ${HOME}/.cache
#  3. printing to PDF in ${DOCUMENTS}
# additionally add 'noblacklist ${DOCUMENTS}' and 'whitelist ${DOCUMENTS}' to
# your yelp.local if you need PDF printing support.
#noblacklist ${DOCUMENTS}
#whitelist ${DOCUMENTS}
