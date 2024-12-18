#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

export MALLOC_CHECK_=3
export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))
export LC_ALL=C

# These directories are required by some tests:
mkdir -p ~/Desktop ~/Documents ~/Downloads ~/Music ~/Pictures ~/Videos

echo "TESTING: tab completion (test/fs/tab.exp)"
./tab.exp

rm -fr ~/_firejail_test_*
echo "TESTING: mkdir/mkfile (test/fs/mkdir_mkfile.exp)"
./mkdir_mkfile.exp
rm -fr ~/_firejail_test_*

echo "TESTING: recursive mkdir (test/fs/mkdir.exp)"
./mkdir.exp
rm -fr ~/_firejail_test_*
rm -fr /tmp/_firejail_test_*

echo "TESTING: read/write (test/fs/read-write.exp)"
./read-write.exp
rm -fr ~/_firejail_test_dir

echo "TESTING: whitelist readonly (test/fs/whitelist-readonly.exp)"
./whitelist-readonly.exp
rm -f ~/_firejail_test_dir

echo "TESTING: /sys/fs access (test/fs/sys_fs.exp)"
./sys_fs.exp

if [[ -c /dev/kmsg ]]; then
	echo "TESTING: kmsg access (test/fs/kmsg.exp)"
	./kmsg.exp
else
	echo "TESTING SKIP: /dev/kmsg not available"
fi

echo "TESTING: read/write /var/tmp (test/fs/fs_var_tmp.exp)"
./fs_var_tmp.exp
rm -f /var/tmp/_firejail_test_file

echo "TESTING: read/write /var/lock (test/fs/fs_var_lock.exp)"
./fs_var_lock.exp
rm -f /var/lock/_firejail_test_file

if [[ -w /dev/shm ]]; then
	echo "TESTING: read/write /dev/shm (test/fs/fs_dev_shm.exp)"
	./fs_dev_shm.exp
	rm -f /dev/shm/_firejail_test_file
else
	echo "TESTING SKIP: /dev/shm not writable"
fi

echo "TESTING: private (test/fs/private.exp)"
./private.exp

echo "TESTING: private home (test/fs/private-home.exp)"
./private-home.exp
rm -f ~/_firejail_test_file1
rm -f ~/_firejail_test_file2
rm -fr ~/_firejail_test_dir1
rm -f ~/_firejail_test_link1
rm -f ~/_firejail_test_link2

echo "TESTING: private home dir (test/fs/private-home-dir.exp)"
./private-home-dir.exp
rm -fr ~/_firejail_test_dir1

echo "TESTING: private home dir same as user home (test/fs/private-homedir.exp)"
./private-homedir.exp
rm -f ~/_firejail_test_file1
rm -f ~/_firejail_test_file2
rm -fr ~/_firejail_test_dir1
rm -f ~/_firejail_test_link1
rm -f ~/_firejail_test_link2

echo "TESTING: private-bin (test/fs/private-bin.exp)"
./private-bin.exp

echo "TESTING: private-cache (test/fs/private-cache.exp)"
./private-cache.exp
rm -f ~/.cache/abcdefg

echo "TESTING: private-cwd (test/fs/private-cwd.exp)"
./private-cwd.exp

echo "TESTING: macros (test/fs/macro.exp)"
./macro.exp

echo "TESTING: whitelist empty (test/fs/whitelist-empty.exp)"
./whitelist-empty.exp
rm -f ~/Videos/_firejail_test_fil
rm -f ~/Pictures/_firejail_test_file
rm -f ~/Music/_firejail_test_file
rm -f ~/Downloads/_firejail_test_file
rm -f ~/Documents/_firejail_test_file
rm -f ~/Desktop/_firejail_test_file

echo "TESTING: private whitelist (test/fs/private-whitelist.exp)"
./private-whitelist.exp

echo "TESTING: invalid filename (test/fs/invalid_filename.exp)"
./invalid_filename.exp

echo "TESTING: blacklist directory (test/fs/option_blacklist.exp)"
./option_blacklist.exp

echo "TESTING: blacklist file (test/fs/option_blacklist_file.exp)"
./option_blacklist_file.exp
rm -fr ~/_firejail_test_dir

echo "TESTING: blacklist glob (test/fs/option_blacklist_glob.exp)"
./option_blacklist_glob.exp
rm -fr ~/_firejail_test_dir

echo "TESTING: noblacklist blacklist noexec (test/fs/noblacklist-blacklist-noexec.exp)"
./noblacklist-blacklist-noexec.exp

echo "TESTING: noblacklist blacklist readonly (test/fs/noblacklist-blacklist-readonly.exp)"
./noblacklist-blacklist-readonly.exp

echo "TESTING: bind as user (test/fs/option_bind_user.exp)"
./option_bind_user.exp

echo "TESTING: double whitelist (test/fs/whitelist-double.exp)"
./whitelist-double.exp
rm -f /tmp/_firejail_test_file

echo "TESTING: whitelist (test/fs/whitelist.exp)"
./whitelist.exp
rm -fr ~/_firejail_test_*

# TODO: whitelist /dev broken in 0.9.72
#echo "TESTING: whitelist dev, var(test/fs/whitelist-dev.exp)"
#./whitelist-dev.exp

echo "TESTING: whitelist noexec (test/fs/whitelist-noexec.exp)"
./whitelist-noexec.exp

echo "TESTING: whitelist with whitespaces (test/fs/whitelist-whitespace.exp)"
./whitelist-whitespace.exp

echo "TESTING: fscheck --bind non root (test/fs/fscheck-bindnoroot.exp)"
./fscheck-bindnoroot.exp

echo "TESTING: fscheck --tmpfs non root (test/fs/fscheck-tmpfs.exp)"
./fscheck-tmpfs.exp
rm -fr ~/_firejail_test_dir
rm -fr /tmp/_firejail_test_dir

echo "TESTING: fscheck --private= (test/fs/fscheck-private.exp)"
./fscheck-private.exp

echo "TESTING: fscheck --read-only= (test/fs/fscheck-readonly.exp)"
./fscheck-readonly.exp

#cleanup
rm -fr ~/_firejail_test*
