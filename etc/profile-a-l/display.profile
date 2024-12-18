# Firejail profile for display
# This file is overwritten after every install/update
# Persistent local customizations
include display.local
# Persistent global definitions
include globals.local

noblacklist ${PICTURES}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
net none
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
protocol unix
seccomp
#x11 xorg # problems on kubuntu 17.04

private-bin display,python*
private-dev
# On Debian-based systems, display is a symlink in /etc/alternatives
private-etc ImageMagick-6,ImageMagick-7
private-lib ImageMagick*,gcc/*/*/libgcc_s.so.*,gcc/*/*/libgomp.so.*,libMagickWand-*.so.*,libXext.so.*,libfreetype.so.*,libltdl.so.*
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
