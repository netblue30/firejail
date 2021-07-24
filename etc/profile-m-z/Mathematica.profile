# Firejail profile for Mathematica
# This file is overwritten after every install/update
# Persistent local customizations
include Mathematica.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.Mathematica
nodeny  ${HOME}/.Wolfram Research

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.Mathematica
mkdir ${HOME}/.Wolfram Research
mkdir ${HOME}/Documents/Wolfram Mathematica
allow  ${HOME}/.Mathematica
allow  ${HOME}/.Wolfram Research
allow  ${HOME}/Documents/Wolfram Mathematica
include whitelist-common.inc

caps.drop all
nodvd
nonewprivs
noroot
notv
seccomp
