# Firejail profile for evince
# Description: Document (PostScript, PDF) viewer
# This file is overwritten after every install/update
# Persistent local customizations
include evince.local
# Persistent global definitions
include globals.local

# WARNING: This exposes information like file history from other programs.
# You can add a blacklist for it in your evince.local for additional hardening if you can live with some restrictions.
noblacklist ${HOME}/.local/share/gvfs-metadata

noblacklist ${HOME}/.config/evince
noblacklist ${DOCUMENTS}

blacklist /usr/libexec

include allow-bin-sh.inc
include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
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
#net none # breaks AppArmor on Ubuntu systems
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
protocol unix
seccomp
seccomp.block-secondary
tracelog

private-bin evince,evince-previewer,evince-thumbnailer,sh
private-cache
private-dev
private-etc
# private-lib might break two-page-view on some systems
private-lib evince,gcc/*/*/libgcc_s.so.*,gcc/*/*/libstdc++.so.*,gconv,gdk-pixbuf-2.*,gio,gvfs/libgvfscommon.so,libarchive.so.*,libdjvulibre.so.*,libgconf-2.so.*,libgraphite2.so.*,libpoppler-glib.so.*,librsvg-2.so.*,libspectre.so.*
private-tmp

dbus-user filter
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.gtk.vfs.Daemon
dbus-user.talk org.gtk.vfs.Metadata
dbus-system none

restrict-namespaces
