# Firejail profile for chromium-common
# This file is overwritten after every install/update
# Persistent local customizations
include chromium-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
# noexec ${HOME} breaks DRM binaries.
?BROWSER_ALLOW_DRM: ignore noexec ${HOME}

noblacklist ${HOME}/.pki
noblacklist ${HOME}/.local/share/pki

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.pki
mkdir ${HOME}/.local/share/pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.pki
whitelist ${HOME}/.local/share/pki
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.keep sys_admin,sys_chroot
netfilter
# nodbus - prevents access to passwords saved in GNOME Keyring and KWallet, also breaks Gnome connector
nodvd
nogroups
notv
?BROWSER_DISABLE_U2F: nou2f
shell none

disable-mnt
private-dev
# private-tmp - problems with multiple browser sessions

# the file dialog needs to work without d-bus
?HAS_NODBUS: env NO_CHROME_KDE_FILE_DIALOG=1
