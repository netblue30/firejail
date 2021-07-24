# Firejail profile for quiterss
# Description: RSS/Atom news feeds reader
# This file is overwritten after every install/update
# Persistent local customizations
include quiterss.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/QuiteRss
nodeny  ${HOME}/.config/QuiteRss
nodeny  ${HOME}/.config/QuiteRssrc
nodeny  ${HOME}/.local/share/QuiteRss

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.cache/QuiteRss
mkdir ${HOME}/.config/QuiteRss
mkdir ${HOME}/.local/share/data
mkdir ${HOME}/.local/share/data/QuiteRss
mkdir ${HOME}/.local/share/QuiteRss
mkfile ${HOME}/quiterssfeeds.opml
allow  ${HOME}/.cache/QuiteRss
allow  ${HOME}/.config/QuiteRss
allow  ${HOME}/.config/QuiteRssrc
allow  ${HOME}/.local/share/data/QuiteRss
allow  ${HOME}/.local/share/QuiteRss
allow  ${HOME}/quiterssfeeds.opml
include whitelist-common.inc

caps.drop all
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
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin quiterss
private-dev
# private-etc alternatives,ca-certificates,crypto-policies,pki,ssl,X11

