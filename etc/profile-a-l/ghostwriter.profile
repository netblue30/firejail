# Firejail profile for ghostwriter
# Description: Cross-platform, aesthetic, distraction-free Markdown editor.
# This file is overwritten after every install/update
# Persistent local customizations
include ghostwriter.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/ghostwriter
noblacklist ${HOME}/.local/share/ghostwriter
noblacklist ${DOCUMENTS}
noblacklist ${PICTURES}

include allow-lua.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /usr/share/ghostwriter
whitelist /usr/share/mozilla-dicts
whitelist /usr/share/pandoc*
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp !chroot
seccomp.block-secondary
#tracelog # breaks

private-bin context,gettext,ghostwriter,latex,mktexfmt,pandoc,pdflatex,pdfroff,prince,weasyprint,wkhtmltopdf
private-cache
private-dev
# passwd,login.defs,firejail are a temporary workaround for #2877 and can be removed once it is fixed
private-etc @tls-ca,@x11,dbus-1,firejail,gconf,host.conf,mime.types,rpc,services,texlive
private-tmp

dbus-user filter
dbus-system none

#restrict-namespaces
