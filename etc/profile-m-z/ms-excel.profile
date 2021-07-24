# Firejail profile for Microsoft Office Online - Excel
# This file is overwritten after every install/update
# Persistent local customizations
include ms-excel.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.cache/ms-excel-online
private-bin ms-excel

# Redirect
include ms-office.profile
