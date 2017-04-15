# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/dino.local

# Firejail profile for Dino
noblacklist ${HOME}/.local/share/dino

mkdir ${HOME}/.local/share/dino
mkdir ${HOME}/Downloads

whitelist ${HOME}/.local/share/dino
whitelist ${HOME}/Downloads

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none

private-bin dino
#private-etc fonts #breaks server connection
private-dev
private-tmp
machine-id

no3d
nosound
