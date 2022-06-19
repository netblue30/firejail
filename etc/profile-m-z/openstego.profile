# Firejail profile for OpenStego
# Description: Steganography application that provides data hiding and watermarking functionality
# This file is overwritten after every install/update
# Persistent local customizations
include openstego.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/openstego.ini

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc

mkfile ${HOME}/openstego.ini
whitelist ${HOME}/openstego.ini
whitelist ${HOME}/.java
whitelist ${PICTURES}
whitelist ${DOCUMENTS}
whitelist ${DESKTOP}
whitelist /usr/share/java
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
machine-id
net none
no3d
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin bash,dirname,openstego,readlink,sh
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
