# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include rtv-addons.local
# You can configure rtv to open different type of links
# in external applications. Configuration here:
# https://github.com/michael-lazar/rtv#viewing-media-links
# This include is meant to facilitate that configuration
# with the use of a .local file.

ignore nosound
ignore private-bin
ignore dbus-user none

nodeny  ${HOME}/.config/mpv
nodeny  ${HOME}/.mailcap
nodeny  ${HOME}/.netrc
nodeny  ${HOME}/.w3m

allow  ${HOME}/.cache/youtube-dl/youtube-sigfuncs
allow  ${HOME}/.config/mpv
allow  ${HOME}/.mailcap
allow  ${HOME}/.netrc
allow  ${HOME}/.w3m

#private-bin w3m,mpv,youtube-dl

# tells rtv, which browser to use
#env RTV_BROWSER=w3m
