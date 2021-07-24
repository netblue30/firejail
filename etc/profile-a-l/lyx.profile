# Firejail profile for lyx
# Description: Open source document processor based on LaTeX typsetting
# This file is overwritten after every install/update
# Persistent local customizations
include lyx.local
# Persistent global definitions
include globals.local

ignore private-tmp

nodeny  ${HOME}/.config/LyX
nodeny  ${HOME}/.lyx

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

allow  /usr/share/lyx
allow  /usr/share/texinfo
allow  /usr/share/texlive
allow  /usr/share/texmf-dist
allow  /usr/share/tlpkg
include whitelist-usr-share-common.inc

apparmor
machine-id

# private-bin atril,dvilualatex,env,latex,lua*,luatex,lyx,lyxclient,okular,pdf2latex,pdflatex,pdftex,perl*,python*,qpdf,qpdfview,sh,tex2lyx,texmf,xelatex
private-etc alternatives,dconf,fonts,gtk-2.0,gtk-3.0,locale,locale.alias,locale.conf,lyx,machine-id,mime.types,passwd,texmf,X11,xdg

# Redirect
include latex-common.profile
