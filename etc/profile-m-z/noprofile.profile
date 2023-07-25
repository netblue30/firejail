# This is the weakest possible firejail profile.
# If a program still fails with this profile, it is incompatible with firejail.
# (from https://gist.github.com/rusty-snake/bb234cb3e50e1e4e7429f29a7931cc72)
#
# Usage:
# $ firejail --profile=noprofile.profile /path/to/program

# Keep in mind that even with this profile some things are done
# which can break the program:
# - some env-vars are cleared;
# - /etc/firejail/firejail.config can contain options such as 'force-nonewprivs yes';
# - a new private pid-namespace is created;
# - a minimal hardcoded blacklist is applied;
# - ...

noblacklist /sys/fs
noblacklist /sys/module

allow-debuggers
allusers
keep-config-pulse
keep-dev-shm
keep-fd all
keep-var-tmp
writable-etc
writable-run-user
writable-var
writable-var-log
