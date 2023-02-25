# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include feh-network.inc.local

ignore net none
netfilter
protocol unix,inet,inet6
private-etc @tls-ca
