# Firejail profile for gnome-sudoku
# Description: puzzle game for the popular Japanese sudoku logic puzzle
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-sudoku.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.local/share/gnome-sudoku

mkdir ${HOME}/.local/share/gnome-sudoku
allow  ${HOME}/.local/share/gnome-sudoku

private-bin gnome-sudoku

dbus-user.own org.gnome.Sudoku

# Redirect
include gnome_games-common.profile
