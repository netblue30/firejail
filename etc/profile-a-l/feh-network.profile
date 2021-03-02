# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include feh-network.local

ignore net none
netfilter
protocol unix,inet,inet6
private-etc ca-certificates,crypto-policies,hosts,pki,resolv.conf,ssl
