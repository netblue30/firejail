#######################################
# OpenBox window manager profile
# - all applications started in OpenBox will run in this profile
#######################################
include /etc/firejail/disable-common.inc

caps.drop all
netfilter
noroot
protocol unix,inet,inet6
seccomp
