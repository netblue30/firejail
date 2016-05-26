include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-devel.inc

whitelist ${HOME}/quiterssfeeds.opml
mkdir ~/.config
mkdir ~/.config/QuiteRss
whitelist ${HOME}/.config/QuiteRss/
whitelist ${HOME}/.config/QuiteRssrc
mkdir ~/.local
mkdir ~/.local/share
whitelist ${HOME}/.local/share/
mkdir ~/.cache
mkdir ~/.cache/QuiteRss
whitelist ${HOME}/.cache/QuiteRss

caps.drop all
seccomp
protocol unix,inet,inet6
netfilter
tracelog
nonewprivs
noroot
nogroups
shell none
private-dev
private-bin quiterss
#private-etc X11,ssl
include /etc/firejail/whitelist-common.inc
