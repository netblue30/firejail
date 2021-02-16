#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2021 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

# These directories are required by some tests:
mkdir -p ~/Desktop ~/Documents ~/Downloads ~/Music ~/Pictures ~/Videos

rm -fr ~/_firejail_test_*
echo "TESTING: mkdir/mkfile (test/fs/mkdir_mkfile.exp)"
./mkdir_mkfile.exp
rm -fr ~/_firejail_test_*

mkdir ~/_firejail_test_dir
touch ~/_firejail_test_dir/a
mkdir ~/_firejail_test_dir/test1
touch ~/_firejail_test_dir/test1/b
echo "TESTING: read/write (test/fs/read-write.exp)"
./read-write.exp
echo "TESTING: whitelist readonly (test/fs/whitelist-readonly.exp)"
./whitelist-readonly.exp
rm -fr ~/_firejail_test_*

echo "TESTING: /sys/fs access (test/fs/sys_fs.exp)"
./sys_fs.exp

if [ -c /dev/kmsg ]; then
	echo "TESTING: kmsg access (test/fs/kmsg.exp)"
	./kmsg.exp
else
	echo "TESTING SKIP: /dev/kmsg not available"
fi

echo "TESTING: read/write /var/tmp (test/fs/fs_var_tmp.exp)"
./fs_var_tmp.exp

echo "TESTING: private-lib (test/fs/private-lib.exp)"
./private-lib.exp

echo "TESTING: read/write /var/lock (test/fs/fs_var_lock.exp)"
./fs_var_lock.exp

if [ -w /dev/shm ]; then
    echo "TESTING: read/write /dev/shm (test/fs/fs_dev_shm.exp)"
    ./fs_dev_shm.exp
else
    echo "TESTING SKIP: /dev/shm not writable"
fi

echo "TESTING: private (test/fs/private.exp)"
./private.exp

echo "TESTING: private home (test/fs/private-home.exp)"
./private-home.exp

echo "TESTING: private home dir (test/fs/private-home-dir.exp)"
./private-home-dir.exp

echo "TESTING: private home dir same as user home (test/fs/private-homedir.exp)"
./private-homedir.exp

echo "TESTING: private-etc (test/fs/private-etc.exp)"
./private-etc.exp

echo "TESTING: empty private-etc (test/fs/private-etc-empty.exp)"
./private-etc-empty.exp

echo "TESTING: private-bin (test/fs/private-bin.exp)"
./private-bin.exp

echo "TESTING: private-cache (test/fs/private-cache.exp)"
./private-cache.exp

echo "TESTING: private-cwd (test/fs/private-cwd.exp)"
./private-cwd.exp

echo "TESTING: macros (test/fs/macro.exp)"
./macro.exp

echo "TESTING: whitelist empty (test/fs/whitelist-empty.exp)"
./whitelist-empty.exp

echo "TESTING: private whitelist (test/fs/private-whitelist.exp)"
./private-whitelist.exp

echo "TESTING: invalid filename (test/fs/invalid_filename.exp)"
./invalid_filename.exp

echo "TESTING: blacklist directory (test/fs/option_blacklist.exp)"
./option_blacklist.exp

echo "TESTING: blacklist file (test/fs/option_blacklist_file.exp)"
./option_blacklist_file.exp

echo "TESTING: blacklist glob (test/fs/option_blacklist_glob.exp)"
./option_blacklist_glob.exp

echo "TESTING: noblacklist blacklist noexec (test/fs/noblacklist-blacklist-noexec.exp)"
./noblacklist-blacklist-noexec.exp

echo "TESTING: noblacklist blacklist readonly (test/fs/noblacklist-blacklist-readonly.exp)"
./noblacklist-blacklist-readonly.exp

echo "TESTING: bind as user (test/fs/option_bind_user.exp)"
./option_bind_user.exp

echo "TESTING: recursive mkdir (test/fs/mkdir.exp)"
./mkdir.exp

echo "TESTING: double whitelist (test/fs/whitelist-double.exp)"
./whitelist-double.exp

echo "TESTING: whitelist (test/fs/whitelist.exp)"
./whitelist.exp

echo "TESTING: whitelist dev, var(test/fs/whitelist-dev.exp)"
./whitelist-dev.exp

echo "TESTING: whitelist noexec (test/fs/whitelist-noexec.exp)"
./whitelist-noexec.exp

echo "TESTING: whitelist with whitespaces (test/fs/whitelist-whitespace.exp)"
./whitelist-whitespace.exp

echo "TESTING: fscheck --bind non root (test/fs/fscheck-bindnoroot.exp)"
./fscheck-bindnoroot.exp

echo "TESTING: fscheck --tmpfs non root (test/fs/fscheck-tmpfs.exp)"
./fscheck-tmpfs.exp

echo "TESTING: fscheck --private= (test/fs/fscheck-private.exp)"
./fscheck-private.exp

echo "TESTING: fscheck --read-only= (test/fs/fscheck-readonly.exp)"
./fscheck-readonly.exp

#cleanup
rm -fr ~/fjtest-dir
rm -fr ~/fjtest-dir-lnk
rm -f ~/fjtest-file
rm -f ~/fjtest-file-lnk
rm -f /tmp/fjtest-file
rm -fr /tmp/fjtest-dir
rm -fr ~/_firejail_test_*
