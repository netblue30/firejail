#######################################
# OpenBox window manager profile
# - all applications started in OpenBox will run in this profile
#######################################
include /etc/firejail/disable-common.inc

caps.drop all
seccomp
protocol unix,inet,inet6
netfilter
noroot

