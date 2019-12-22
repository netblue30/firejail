# Firejail profile for Mathematica
# This file is overwritten after every install/update
# Persistent local customizations
include Mathematica.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.Mathematica
noblacklist ${HOME}/.Wolfram Research

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.Mathematica
mkdir ${HOME}/.Wolfram Research
mkdir ${HOME}/Documents/Wolfram Mathematica
whitelist ${HOME}/.Mathematica
whitelist ${HOME}/.Wolfram Research
whitelist ${HOME}/Documents/Wolfram Mathematica
include whitelist-common.inc

caps.drop all
nodvd
nonewprivs
noroot
notv
seccomp

#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,group,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
