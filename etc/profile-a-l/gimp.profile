# Firejail profile for gimp
# Description: GNU Image Manipulation Program
# This file is overwritten after every install/update
# Persistent local customizations
include gimp.local
# Persistent global definitions
include globals.local

# Add the next lines to your gimp.local in order to support scanning via xsane (see #3640).
# TODO: Replace 'ignore seccomp' with a less permissive option.
#ignore seccomp
#ignore dbus-system
#ignore net
#protocol unix,inet,inet6

# gimp plugins are installed by the user in ${HOME}/.gimp-2.8/plug-ins/ directory
# If you are not using external plugins, you can add 'noexec ${HOME}' to your gimp.local.
ignore noexec ${HOME}

noblacklist ${HOME}/.cache/babl
noblacklist ${HOME}/.cache/gegl-0.4
noblacklist ${HOME}/.cache/gimp
noblacklist ${HOME}/.config/GIMP
noblacklist ${HOME}/.gimp*
noblacklist ${DOCUMENTS}
noblacklist ${PICTURES}

# See issue #4367, gimp 2.10.22-3: gegl:introspect broken
noblacklist /sbin
noblacklist /usr/sbin

include disable-common.inc
include disable-exec.inc
include disable-devel.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/gegl-0.4
whitelist /usr/share/gimp
whitelist /usr/share/mypaint-data
whitelist /usr/share/lensfun
include whitelist-run-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
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
seccomp !mbind
shell none
tracelog

private-dev
private-tmp

dbus-user none
dbus-system none
