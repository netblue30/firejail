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
