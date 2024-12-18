# Firejail profile for lyx
# Description: Open source document processor based on LaTeX typsetting
# This file is overwritten after every install/update
# Persistent local customizations
include lyx.local
# Persistent global definitions
include globals.local

ignore private-tmp

noblacklist ${HOME}/.config/LyX
noblacklist ${HOME}/.lyx

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

whitelist /usr/share/lyx
whitelist /usr/share/texinfo
whitelist /usr/share/texmf-dist
whitelist /usr/share/tlpkg
include whitelist-usr-share-common.inc

apparmor
machine-id

#private-bin atril,dvilualatex,env,latex,lua*,luatex,lyx,lyxclient,okular,pdf2latex,pdflatex,pdftex,perl*,python*,qpdf,qpdfview,sh,tex2lyx,texmf,xelatex
private-etc @x11,lyx,mime.types,texmf

# Redirect
include latex-common.profile
