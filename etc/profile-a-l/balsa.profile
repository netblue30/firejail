# Firejail profile for balsa
# Description: GNOME mail client
# This file is overwritten after every install/update
# Persistent local customizations
include balsa.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.balsa
noblacklist ${HOME}/mail

include disable-shell.inc

mkdir ${HOME}/.balsa
mkdir ${HOME}/mail
whitelist ${HOME}/.balsa
whitelist ${HOME}/mail
whitelist /usr/share/balsa

# Add "pinentry-curses,pinentry-emacs,pinentry-fltk,pinentry-gnome3,pinentry-gtk,pinentry-gtk2,pinentry-gtk-2,pinentry-qt,pinentry-qt4,pinentry-tty,pinentry-x2go,pinentry-kwallet" for gpg.
#private-bin balsa,balsa-ab,fireurl,gpg,gpg-agent,gpg2,gpgsm

dbus-user.own org.desktop.Balsa

# Redirect
include email-common.profile
