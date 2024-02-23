# Firejail profile for apostrophe
# Description: Distraction free Markdown editor for GNU/Linux made with GTK
# This file is overwritten after every install/update
# Persistent local customizations
include apostrophe.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.texlive20*
noblacklist ${DOCUMENTS}
noblacklist ${PICTURES}

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /usr/libexec/webkit2gtk-4.0
whitelist /usr/share/apostrophe
whitelist /usr/share/texmf
whitelist /usr/share/pandoc-*
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
tracelog

disable-mnt
private-bin apostrophe,fmtutil,kpsewhich,mktexfmt,pandoc,pdftex,perl,python3*,sh,xdvipdfmx,xelatex,xetex
private-cache
private-dev
private-etc @x11,texlive
private-tmp

dbus-user filter
dbus-user.own org.gnome.gitlab.somas.Apostrophe
dbus-user.talk ca.desrt.dconf
dbus-system none

restrict-namespaces
