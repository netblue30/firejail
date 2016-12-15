# Mathematica profile
noblacklist ${HOME}/.Mathematica
noblacklist ${HOME}/.Wolfram Research

mkdir ~/.Mathematica
whitelist ~/.Mathematica
mkdir ~/.Wolfram Research
whitelist ~/.Wolfram Research
whitelist ~/Documents/Wolfram Mathematica
include /etc/firejail/whitelist-common.inc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nonewprivs
noroot
seccomp
