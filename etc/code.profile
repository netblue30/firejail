# Firejail profile for Visual Studio Code
# This file is overwritten after every install/update
# Persistent local customizations
include code.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Code
noblacklist ${HOME}/.config/Code - OSS
noblacklist ${HOME}/.vscode
noblacklist ${HOME}/.vscode-oss

# Allows files commonly used by IDEs
include allow-common-devel.inc

include disable-common.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

private-cache
private-dev
#private-etc Trolltech.conf,X11,alternatives,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp

# Disabling noexec ${HOME} for now since it will
# probably interfere with running some programmes
# in VS Code
# noexec ${HOME}
noexec /tmp
