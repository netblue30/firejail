# Firejail profile for xpra
# Description: Tool to detach/reattach running X programs
# This file is overwritten after every install/update
# Persistent local customizations
include xpra.local
# Persistent global definitions
include globals.local

#
# This profile will sandbox Xpra server itself when used with firejail --x11=xpra.
# To enable it, create a firejail-xpra  symlink in /usr/local/bin:
#
#    $ sudo ln -s /usr/bin/firejail /usr/local/bin/xpra
#
# or run "sudo firecfg"

blacklist /media

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*
noblacklist /usr/local/lib/python2*
noblacklist /usr/local/lib/python3*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist /var/lib/xkb
# whitelisting home directory, or including whitelist-common.inc
# will crash xpra on some platforms

caps.drop all
# xpra needs to be allowed access to the abstract Unix socket namespace.
nodvd
nogroups
nonewprivs
# In noroot mode, xpra cannot create a socket in the real /tmp/.X11-unix.
#noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none

# private home directory doesn't work on some distros, so we go for a regular home
# private
# older Xpra versions also use Xvfb
# private-bin xpra,python*,Xvfb,Xorg,sh,xkbcomp,xauth,dbus-launch,pactl,ldconfig,which,strace,bash,cat,ls
private-dev
# private-etc alternatives,ld.so.conf,ld.so.cache,resolv.conf,host.conf,nsswitch.conf,gai.conf,hosts,hostname,machine-id,xpra,X11
private-tmp
