# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-perl.local

noblacklist ${PATH}/core_perl
noblacklist ${PATH}/cpan*
noblacklist ${PATH}/perl
noblacklist ${PATH}/site_perl
noblacklist ${PATH}/vendor_perl
noblacklist /usr/lib/perl*
noblacklist /usr/lib64/perl*
noblacklist /usr/share/perl*
