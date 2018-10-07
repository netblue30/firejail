# Firejail profile for quiterss
# Description: RSS/Atom news feeds reader
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/quiterss.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/QuiteRss
noblacklist ${HOME}/.config/QuiteRss
noblacklist ${HOME}/.config/QuiteRssrc
noblacklist ${HOME}/.local/share/QuiteRss

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/QuiteRss
mkdir ${HOME}/.config/QuiteRss
mkdir ${HOME}/.local/share/data
mkdir ${HOME}/.local/share/data/QuiteRss
whitelist ${HOME}/.cache/QuiteRss
whitelist ${HOME}/.config/QuiteRss/
whitelist ${HOME}/.config/QuiteRssrc
whitelist ${HOME}/.local/share/data/QuiteRss
whitelist ${HOME}/.local/share/QuiteRss
whitelist ${HOME}/quiterssfeeds.opml
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin quiterss
private-dev
# private-etc X11,ssl,pki,ca-certificates,crypto-policies

noexec ${HOME}
noexec /tmp
