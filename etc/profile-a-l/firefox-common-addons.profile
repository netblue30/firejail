# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include firefox-common-addons.local

ignore include whitelist-runuser-common.inc
ignore private-cache

nodeny  ${HOME}/.cache/youtube-dl
nodeny  ${HOME}/.config/kgetrc
nodeny  ${HOME}/.config/mpv
nodeny  ${HOME}/.config/okularpartrc
nodeny  ${HOME}/.config/okularrc
nodeny  ${HOME}/.config/qpdfview
nodeny  ${HOME}/.config/youtube-dl
nodeny  ${HOME}/.kde/share/apps/kget
nodeny  ${HOME}/.kde/share/apps/okular
nodeny  ${HOME}/.kde/share/config/kgetrc
nodeny  ${HOME}/.kde/share/config/okularpartrc
nodeny  ${HOME}/.kde/share/config/okularrc
nodeny  ${HOME}/.kde4/share/apps/kget
nodeny  ${HOME}/.kde4/share/apps/okular
nodeny  ${HOME}/.kde4/share/config/kgetrc
nodeny  ${HOME}/.kde4/share/config/okularpartrc
nodeny  ${HOME}/.kde4/share/config/okularrc
nodeny  ${HOME}/.local/share/kget
nodeny  ${HOME}/.local/share/kxmlgui5/okular
nodeny  ${HOME}/.local/share/okular
nodeny  ${HOME}/.local/share/qpdfview
nodeny  ${HOME}/.netrc

allow  ${HOME}/.cache/gnome-mplayer/plugin
allow  ${HOME}/.cache/youtube-dl/youtube-sigfuncs
allow  ${HOME}/.config/gnome-mplayer
allow  ${HOME}/.config/kgetrc
allow  ${HOME}/.config/mpv
allow  ${HOME}/.config/okularpartrc
allow  ${HOME}/.config/okularrc
allow  ${HOME}/.config/pipelight-silverlight5.1
allow  ${HOME}/.config/pipelight-widevine
allow  ${HOME}/.config/qpdfview
allow  ${HOME}/.config/youtube-dl
allow  ${HOME}/.kde/share/apps/kget
allow  ${HOME}/.kde/share/apps/okular
allow  ${HOME}/.kde/share/config/kgetrc
allow  ${HOME}/.kde/share/config/okularpartrc
allow  ${HOME}/.kde/share/config/okularrc
allow  ${HOME}/.kde4/share/apps/kget
allow  ${HOME}/.kde4/share/apps/okular
allow  ${HOME}/.kde4/share/config/kgetrc
allow  ${HOME}/.kde4/share/config/okularpartrc
allow  ${HOME}/.kde4/share/config/okularrc
allow  ${HOME}/.keysnail.js
allow  ${HOME}/.lastpass
allow  ${HOME}/.local/share/kget
allow  ${HOME}/.local/share/kxmlgui5/okular
allow  ${HOME}/.local/share/okular
allow  ${HOME}/.local/share/qpdfview
allow  ${HOME}/.local/share/tridactyl
allow  ${HOME}/.netrc
allow  ${HOME}/.pentadactyl
allow  ${HOME}/.pentadactylrc
allow  ${HOME}/.tridactylrc
allow  ${HOME}/.vimperator
allow  ${HOME}/.vimperatorrc
allow  ${HOME}/.wine-pipelight
allow  ${HOME}/.wine-pipelight64
allow  ${HOME}/.zotero
allow  ${HOME}/dwhelper
allow  /usr/share/lua
allow  /usr/share/lua*
allow  /usr/share/vulkan

# GNOME Shell integration (chrome-gnome-shell) needs dbus and python
nodeny  ${HOME}/.local/share/gnome-shell
allow  ${HOME}/.local/share/gnome-shell
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
