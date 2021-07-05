# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include disable-shell.local

deny  ${PATH}/bash
deny  ${PATH}/csh
deny  ${PATH}/dash
deny  ${PATH}/fish
deny  ${PATH}/ksh
deny  ${PATH}/mksh
deny  ${PATH}/oksh
deny  ${PATH}/sh
deny  ${PATH}/tclsh
deny  ${PATH}/tcsh
deny  ${PATH}/zsh
