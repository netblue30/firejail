# Firejail profile for gummi
# This file is overwritten after every install/update
# Persistent local customizations
include gummi.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/gummi

include allow-lua.inc
include allow-perl.inc
include allow-python3.inc

private-bin dvipdf,dvips,env,gummi,latex,latexmk,lua*,lualatex,luatex,pdflatex,pdftex,perl,ps2pdf,python3*,rubber,synctex,tex,xelatex,xetex

# Redirect
include latex-common.profile

