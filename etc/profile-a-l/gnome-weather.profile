# Firejail profile for gnome-weather
# Description: Access current conditions and forecasts
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-weather.local
# Persistent global definitions
include globals.local

# when gjs apps are started via gnome-shell, firejail is not applied because systemd will start them

noblacklist ${HOME}/.cache/libgweather

# Allow gjs (blacklisted by disable-interpreters.inc)
include allow-gjs.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-runuser-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
tracelog

disable-mnt
#private-bin gjs,gnome-weather
private-dev
#private-etc alternatives,ca-certificates,crypto-policies,fonts,pki,ssl
private-tmp

restrict-namespaces
