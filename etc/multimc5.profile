# Firejail profile for multimc5
# This file is overwritten after every install/update
# Persistent local customizations
include multimc5.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/multimc
noblacklist ${HOME}/.local/share/multimc5
noblacklist ${HOME}/.multimc5

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.local/share/multimc
mkdir ${HOME}/.local/share/multimc5
mkdir ${HOME}/.multimc5
whitelist ${HOME}/.local/share/multimc
whitelist ${HOME}/.local/share/multimc5
whitelist ${HOME}/.multimc5
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
# seccomp
shell none

disable-mnt
# private-bin works, but causes weirdness
# private-bin apt-file,awk,bash,chmod,dirname,dnf,grep,java,kdialog,ldd,mkdir,multimc5,pfl,pkgfile,readlink,sort,valgrind,which,yum,zenity,zypper
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,java.conf,java-10-openjdk,java-9-openjdk,java-8-openjdk,java-7-openjdk,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

