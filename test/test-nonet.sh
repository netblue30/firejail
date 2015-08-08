#!/bin/bash

echo "TESTING: version"
./option_version.exp

echo "TESTING: help"
./option_help.exp

echo "TESTING: man"
./option_man.exp

echo "TESTING: list"
./option_list.exp

echo "TESTING: PID"
./pid.exp

echo "TESTING: profile no permissions"
./profile_noperm.exp

echo "TESTING: profile syntax"
./profile_syntax.exp

echo "TESTING: profile read-only"
./profile_readonly.exp

echo "TESTING: profile tmpfs"
./profile_tmpfs.exp

echo "TESTING: private"
./private.exp `whoami`

echo "TESTING: read/write /var/tmp"
./fs_var_tmp.exp

echo "TESTING: read/write /var/run"
./fs_var_run.exp

echo "TESTING: read/write /var/lock"
./fs_var_lock.exp

echo "TESTING: read/write /dev/shm"
./fs_dev_shm.exp

