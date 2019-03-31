# Firejail profile for evince
# Description: Document (PostScript, PDF) viewer
# This file is overwritten after every install/update
# Persistent local customizations
include evince.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/evince
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
machine-id
# net none - breaks AppArmor on Ubuntu systems
netfilter
no3d
# nodbus might break two-page-view on some systems
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

private-bin evince,evince-previewer,evince-thumbnailer
private-cache
private-dev
private-etc alternatives,fonts,group,machine-id,passwd
private-lib evince,gdk-pixbuf-2.*,gio,gvfs/libgvfscommon.so,libdjvulibre.so.*,libgconf-2.so.*,libpoppler-glib.so.*,librsvg-2.so.*,gconv
private-tmp

# memory-deny-write-execute - might break application (https://github.com/netblue30/firejail/issues/1803)
noexec ${HOME}
noexec /tmp
