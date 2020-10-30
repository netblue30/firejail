# Firejail profile for equalx
# Description: A graphical editor for writing LaTeX equations
# This file is overwritten after every install/update
# Persistent local customizations
include equalx.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/equalx
noblacklist ${HOME}/.equalx

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/equalx
mkdir ${HOME}/.equalx
whitelist ${HOME}/.config/equalx
whitelist ${HOME}/.equalx
whitelist /usr/share/poppler
whitelist /usr/share/ghostscript
whitelist /usr/share/texlive
whitelist /usr/share/equalx
whitelist /var/lib/texmf
include whitelist-common.inc
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
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

disable-mnt
private-bin equalx,gs,pdflatex,pdftocairo
private-cache
private-dev
private-etc equalx,equalx.conf,fonts,gtk-2.0,latexmk.conf,machine-id,papersize,passwd,texlive,Trolltech.conf
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
