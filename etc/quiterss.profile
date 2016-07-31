include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-devel.inc

whitelist ${HOME}/quiterssfeeds.opml
mkdir ~/.config/QuiteRss
whitelist ${HOME}/.config/QuiteRss/
whitelist ${HOME}/.config/QuiteRssrc
mkdir ~/.local/share
whitelist ${HOME}/.local/share/
mkdir ~/.cache/QuiteRss
whitelist ${HOME}/.cache/QuiteRss

caps.drop all
netfilter
nonewprivs
nogroups
noroot
private-bin quiterss
private-dev
nosound
#private-etc X11,ssl
protocol unix,inet,inet6
seccomp
shell none
tracelog

include /etc/firejail/whitelist-common.inc
