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
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin quiterss
private-dev
#private-etc X11,ssl

include /etc/firejail/whitelist-common.inc
