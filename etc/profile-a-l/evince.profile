# Firejail profile for evince
# Description: Document (PostScript, PDF) viewer
# This file is overwritten after every install/update
# Persistent local customizations
include evince.local
# Persistent global definitions
include globals.local

# Uncomment this line and the bottom ones to use bookmarks
# NOTE: This possibly exposes information, including file history from other programs.
#noblacklist ${HOME}/.local/share/gvfs-metadata

noblacklist ${HOME}/.config/evince
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /usr/share/doc
whitelist /usr/share/evince
whitelist /usr/share/poppler
whitelist /usr/share/tracker
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
machine-id
# net none - breaks AppArmor on Ubuntu systems
netfilter
no3d
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
seccomp.block-secondary
shell none
tracelog

private-bin evince,evince-previewer,evince-thumbnailer
private-cache
private-dev
private-etc alternatives,fonts,group,ld.so.cache,machine-id,passwd
# private-lib might break two-page-view on some systems
private-lib evince,gcc/*/*/libgcc_s.so.*,gcc/*/*/libstdc++.so.*,gconv,gdk-pixbuf-2.*,gio,gvfs/libgvfscommon.so,libdjvulibre.so.*,libgconf-2.so.*,libgraphite2.so.*,libpoppler-glib.so.*,librsvg-2.so.*,libspectre.so.*
private-tmp

# might break two-page-view on some systems
dbus-user filter
# Also uncomment these two lines if you want to use bookmarks
#dbus-user.talk org.gtk.vfs.Daemon
#dbus-user.talk org.gtk.vfs.Metadata
dbus-system none
