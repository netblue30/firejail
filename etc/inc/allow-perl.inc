# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-perl.local

nodeny  ${PATH}/core_perl
nodeny  ${PATH}/cpan*
nodeny  ${PATH}/perl
nodeny  ${PATH}/site_perl
nodeny  ${PATH}/vendor_perl
nodeny  /usr/lib/perl*
nodeny  /usr/lib64/perl*
nodeny  /usr/share/perl*
