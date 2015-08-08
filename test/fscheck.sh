#!/bin/bash

mkdir fscheck-dir
ln -s fscheck-dir fscheck-dir-link
touch fscheck-file
ln -s fscheck-file fscheck-file-link
touch fscheck-file-hard1
ln fscheck-file-hard1 fscheck-file-hard2

echo "TESTING: fscheck netfilter"
./fscheck-netfilter.exp
echo "TESTING: fscheck shell"
./fscheck-shell.exp
echo "TESTING: fscheck private"
./fscheck-private.exp
echo "TESTING: fscheck private keep"
./fscheck-privatekeep.exp
echo "TESTING: fscheck profile"
./fscheck-profile.exp
echo "TESTING: fscheck chroot"
./fscheck-chroot.exp
echo "TESTING: fscheck output"
./fscheck-output.exp
echo "TESTING: fscheck bind nonroot"
./fscheck-bindnoroot.exp
echo "TESTING: fscheck tmpfs"
./fscheck-tmpfs.exp
echo "TESTING: fscheck readonly"
./fscheck-readonly.exp
echo "TESTING: fscheck blacklist"
./fscheck-blacklist.exp


rm -fr fscheck-dir 
rm -fr fscheck-dir-link 
rm -fr fscheck-file-link 
rm -fr fscheck-file
rm -fr fscheck-file-hard1
rm -fr fscheck-file-hard2
