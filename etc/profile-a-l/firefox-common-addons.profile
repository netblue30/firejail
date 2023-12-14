# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include firefox-common-addons.local

# Prevent whitelisting in ${RUNUSER}
ignore whitelist ${RUNUSER}/*firefox*
ignore whitelist ${RUNUSER}/psd/*firefox*
ignore whitelist ${RUNUSER}/kpxc_server
ignore whitelist ${RUNUSER}/org.keepassxc.KeePassXC.BrowserServer
ignore include whitelist-runuser-common.inc

ignore private-cache

noblacklist ${HOME}/.cache/mpv
noblacklist ${HOME}/.cache/youtube-dl
noblacklist ${HOME}/.config/kgetrc
noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.config/okularpartrc
noblacklist ${HOME}/.config/okularrc
noblacklist ${HOME}/.config/qpdfview
noblacklist ${HOME}/.config/youtube-dl
noblacklist ${HOME}/.kde/share/apps/kget
noblacklist ${HOME}/.kde/share/apps/okular
noblacklist ${HOME}/.kde/share/config/kgetrc
noblacklist ${HOME}/.kde/share/config/okularpartrc
noblacklist ${HOME}/.kde/share/config/okularrc
noblacklist ${HOME}/.kde4/share/apps/kget
noblacklist ${HOME}/.kde4/share/apps/okular
noblacklist ${HOME}/.kde4/share/config/kgetrc
noblacklist ${HOME}/.kde4/share/config/okularpartrc
noblacklist ${HOME}/.kde4/share/config/okularrc
noblacklist ${HOME}/.local/share/kget
noblacklist ${HOME}/.local/share/kxmlgui5/okular
noblacklist ${HOME}/.local/share/okular
noblacklist ${HOME}/.local/share/qpdfview
noblacklist ${HOME}/.local/state/mpv
noblacklist ${HOME}/.netrc

whitelist ${HOME}/.cache/gnome-mplayer/plugin
whitelist ${HOME}/.cache/mpv
whitelist ${HOME}/.cache/youtube-dl/youtube-sigfuncs
whitelist ${HOME}/.config/gnome-mplayer
whitelist ${HOME}/.config/kgetrc
whitelist ${HOME}/.config/mpv
whitelist ${HOME}/.config/okularpartrc
whitelist ${HOME}/.config/okularrc
whitelist ${HOME}/.config/pipelight-silverlight5.1
whitelist ${HOME}/.config/pipelight-widevine
whitelist ${HOME}/.config/qpdfview
whitelist ${HOME}/.config/youtube-dl
whitelist ${HOME}/.kde/share/apps/kget
whitelist ${HOME}/.kde/share/apps/okular
whitelist ${HOME}/.kde/share/config/kgetrc
whitelist ${HOME}/.kde/share/config/okularpartrc
whitelist ${HOME}/.kde/share/config/okularrc
whitelist ${HOME}/.kde4/share/apps/kget
whitelist ${HOME}/.kde4/share/apps/okular
whitelist ${HOME}/.kde4/share/config/kgetrc
whitelist ${HOME}/.kde4/share/config/okularpartrc
whitelist ${HOME}/.kde4/share/config/okularrc
whitelist ${HOME}/.keysnail.js
whitelist ${HOME}/.lastpass
whitelist ${HOME}/.local/share/kget
whitelist ${HOME}/.local/share/kxmlgui5/okular
whitelist ${HOME}/.local/share/okular
whitelist ${HOME}/.local/share/qpdfview
whitelist ${HOME}/.local/share/tridactyl
whitelist ${HOME}/.local/state/mpv
whitelist ${HOME}/.netrc
whitelist ${HOME}/.pentadactyl
whitelist ${HOME}/.pentadactylrc
whitelist ${HOME}/.tridactylrc
whitelist ${HOME}/.vimperator
whitelist ${HOME}/.vimperatorrc
whitelist ${HOME}/.wine-pipelight
whitelist ${HOME}/.wine-pipelight64
whitelist ${HOME}/.zotero
whitelist ${HOME}/dwhelper
whitelist /usr/share/lua*
whitelist /usr/share/mpv

# GNOME Shell integration (chrome-gnome-shell) needs dbus and python
noblacklist ${HOME}/.local/share/gnome-shell
whitelist ${HOME}/.local/share/gnome-shell
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.gnome.ChromeGnomeShell
dbus-user.talk org.gnome.Shell
# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

# KeePassXC Browser Integration
#private-bin keepassxc-proxy

# Flash plugin
# private-etc must first be enabled in firefox-common.profile and in profiles including it.
#private-etc adobe

# ff2mpv
#ignore noexec ${HOME}
#include allow-lua.inc
#private-bin env,mpv,python3*,waf,youtube-dl
