# Firejail profile for pycharm-community
# This file is overwritten after every install/update
# Persistent local customizations
include pycharm-community.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.PyCharmCE*
noblacklist ${HOME}/.python-history
noblacklist ${HOME}/.pythonrc.py
noblacklist ${HOME}/.java

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
machine-id
nodvd
nogroups
nosound
notv
nou2f
novideo
shell none
tracelog

# private-etc alternatives,fonts,passwd - minimal required to run but will probably break
# program!
private-cache
private-dev
private-tmp

noexec /tmp
