# Firejail profile for Gajim

mkdir ${HOME}/.cache/gajim
mkdir ${HOME}/.local/share/gajim
mkdir ${HOME}/.config/gajim
mkdir ${HOME}/Downloads

# Allow the local python 2.7 site packages, in case any plugins are using these
mkdir ${HOME}/.local/lib/python2.7/site-packages/
whitelist ${HOME}/.local/lib/python2.7/site-packages/
read-only ${HOME}/.local/lib/python2.7/site-packages/

whitelist ${HOME}/.cache/gajim
whitelist ${HOME}/.local/share/gajim
whitelist ${HOME}/.config/gajim
whitelist ${HOME}/Downloads

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
nonewprivs
nogroups
noroot
protocol unix,inet,inet6
seccomp
shell none

#private-bin python2.7 gajim
private-dev
