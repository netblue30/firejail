# Firejail profile for offical Teams application
#
# Description: Teams is an application for Microsoft's team collaboration and chat program
# URL:         https://teams.microsoft.com/downloads
#
# This file is overwritten after every install/update
# Persistent local customizations
include teams.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/teams

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/teams
mkdir ${HOME}/.config/Microsoft

whitelist ${HOME}/.config/teams
whitelist ${HOME}/.config/Microsoft
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
#private-bin bash,cut,echo,egrep,grep,head,sed,sh,teams,tr,xdg-mime,xdg-open,zsh,readlink,dirname,mkdir,nohup,pulseaudio,awk,mv,dash,kde-config,wget
private-cache
private-dev
#private-etc ca-certificates,crypto-policies,fonts,ld.so.cache,localtime,machine-id,pki,resolv.conf,ssl,alsa,asound.conf,pulse,alternatives,ld.so.preload,selinux,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,xdg,gtk-3.0,hosts,resolve.conf,host.conf,hostname,protocols,config,dconf,gconf,gtk-2.0,gnutls,mime.types,locale.alias,magic,magic.mgc,group,login.defs,password,X11,nsswitch.conf
private-tmp
