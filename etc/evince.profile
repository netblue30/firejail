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
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/evince
whitelist /usr/share/poppler
whitelist /usr/share/tracker
include whitelist-usr-share-common.inc
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
private-etc alternatives,fonts,group,ld.so.cache,machine-id,passwd
# private-lib might break two-page-view on some systems
private-lib evince,gconv,gdk-pixbuf-2.*,gio,gvfs/libgvfscommon.so,libdjvulibre.so.*,libgcc_s.so.*,libgconf-2.so.*,libgraphite2.so.*,libpoppler-glib.so.*,librsvg-2.so.*,libspectre.so.*,libstdc++.so.*
private-tmp
