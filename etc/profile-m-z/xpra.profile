# Firejail profile for xpra
# Description: Tool to detach/reattach running X programs
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include xpra.local
# Persistent global definitions
include globals.local

#
# This profile will sandbox Xpra server itself when used with firejail --x11=xpra.
# To enable it, create a firejail-xpra symlink in /usr/local/bin:
#
#    $ sudo ln -s /usr/bin/firejail /usr/local/bin/xpra
#
# or run "sudo firecfg"

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

whitelist /var/lib/xkb
# whitelisting home directory, or including whitelist-common.inc
# will crash xpra on some platforms

caps.drop all
# xpra needs to be allowed access to the abstract Unix socket namespace.
nodvd
nogroups
noinput
nonewprivs
# In noroot mode, xpra cannot create a socket in the real /tmp/.X11-unix.
#noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp

disable-mnt
# private home directory doesn't work on some distros, so we go for a regular home
#private
# older Xpra versions also use Xvfb
#private-bin bash,cat,dbus-launch,ldconfig,ls,pactl,python*,sh,strace,which,xauth,xkbcomp,Xorg,xpra,Xvfb
private-dev
#private-etc alternatives,gai.conf,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,machine-id,nsswitch.conf,resolv.conf,X11,xpra
private-tmp

restrict-namespaces
