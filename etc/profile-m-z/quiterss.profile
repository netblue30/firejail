# Firejail profile for quiterss
# Description: RSS/Atom news feeds reader
# This file is overwritten after every install/update
# Persistent local customizations
include quiterss.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/QuiteRss
noblacklist ${HOME}/.config/QuiteRss
noblacklist ${HOME}/.config/QuiteRssrc
noblacklist ${HOME}/.local/share/QuiteRss

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.cache/QuiteRss
mkdir ${HOME}/.config/QuiteRss
mkdir ${HOME}/.local/share/data
mkdir ${HOME}/.local/share/data/QuiteRss
mkdir ${HOME}/.local/share/QuiteRss
mkfile ${HOME}/quiterssfeeds.opml
whitelist ${HOME}/.cache/QuiteRss
whitelist ${HOME}/.config/QuiteRss
whitelist ${HOME}/.config/QuiteRssrc
whitelist ${HOME}/.local/share/data/QuiteRss
whitelist ${HOME}/.local/share/QuiteRss
whitelist ${HOME}/quiterssfeeds.opml
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
tracelog

disable-mnt
private-bin quiterss
private-dev
#private-etc alternatives,ca-certificates,crypto-policies,pki,ssl,X11

restrict-namespaces
