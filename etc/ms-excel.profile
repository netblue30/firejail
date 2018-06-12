# Firejail profile for Microsoft Office Online - Excel
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/ms-excel.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/ms-excel-online
private-bin ms-excel

# Redirect
include /etc/firejail/ms-office.profile
