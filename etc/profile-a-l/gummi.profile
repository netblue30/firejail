# Firejail profile for gummi
# This file is overwritten after every install/update
# Persistent local customizations
include gummi.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/gummi
noblacklist ${HOME}/.config/gummi

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

private-bin dvipdf,dvips,env,gummi,latex,latexmk,lua*,pdflatex,pdftex,perl,ps2pdf,python3*,rubber,synctex,tex,xelatex,xetex

# Redirect
include latex-common.profile
