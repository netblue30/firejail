# Firejail profile for Mathematica
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/Mathematica.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.Mathematica
noblacklist ${HOME}/.Wolfram Research

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.Mathematica
mkdir ${HOME}/.Wolfram Research
whitelist ${HOME}/.Mathematica
whitelist ${HOME}/.Wolfram Research
whitelist ${HOME}/Documents/Wolfram Mathematica
include /etc/firejail/whitelist-common.inc

caps.drop all
nodvd
nonewprivs
noroot
notv
seccomp
