# Firejail profile for gradio
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gradio.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/gradio
noblacklist ${HOME}/.local/share/gradio

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/gradio
mkdir ${HOME}/.local/share/gradio
whitelist ${HOME}/.cache/gradio
whitelist ${HOME}/.local/share/gradio
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-etc asound.conf,ca-certificates,fonts,host.conf,hostname,hosts,pulse,resolv.conf,ssl,pki,crypto-policies,gtk-3.0,xdg,machine-id
private-tmp

noexec ${HOME}
noexec /tmp
