#!/bin/bash

./chk_config.exp

./fscheck.sh

echo "TESTING: version"
./option_version.exp

echo "TESTING: help"
./option_help.exp

echo "TESTING: man"
./option_man.exp

echo "TESTING: list"
./option_list.exp

echo "TESTING: tree"
./option_tree.exp

if [ -f /proc/self/uid_map ];
then
	echo "TESTING: noroot"
	./noroot.exp
else
	echo "TESTING: user namespaces not available"
fi

echo "TESTING: doubledash"
mkdir -- -testdir
touch -- -testdir/ttt
cp -- /bin/bash -testdir/.
./doubledash.exp
rm -fr -- -testdir

echo "TESTING: trace1"
./option-trace.exp

echo "TESTING: trace2"
rm -f index.html*
./trace.exp
rm -f index.html*

echo "TESTING: extract command"
./extract_command.exp

echo "TESTING: rlimit"
./option_rlimit.exp

echo "TESTING: shutdown"
./option-shutdown.exp

echo "TESTING: join"
./option-join.exp

echo "TESTING: firejail in firejail"
./firejail-in-firejail.exp

echo "TESTING: chroot overlay"
./option_chroot_overlay.exp

echo "TESTING: tmpfs"
./option_tmpfs.exp

echo "TESTING: blacklist directory"
./option_blacklist.exp

echo "TESTING: blacklist file"
./option_blacklist_file.exp

echo "TESTING: bind as user"
./option_bind_user.exp

if [ -d /home/bingo ];
then
	echo "TESTING: home sanitize"
	./option_version.exp
fi

echo "TESTING: chroot as user"
./fs_chroot.exp

echo "TESTING: /sys"
./fs_sys.exp

echo "TESTING: readonly"
ls -al > tmpreadonly
./option_readonly.exp
sleep 5
rm -f tmpreadonly

echo "TESTING: name"
./name.exp

echo "TESTING: zsh"
./shell_zsh.exp

echo "TESTING: csh"
./shell_csh.exp

which dash
if [ "$?" -eq 0 ];
then
        echo "TESTING: dash"
        ./shell_dash.exp
else
        echo "TESTING: dash not found"
fi

which firefox
if [ "$?" -eq 0 ];
then
	echo "TESTING: firefox"
	./firefox.exp
else
	echo "TESTING: firefox not found"
fi

which midori
if [ "$?" -eq 0 ];
then
	echo "TESTING: midori"
	./midori.exp
else
	echo "TESTING: midori not found"
fi

which chromium-browser
if [ "$?" -eq 0 ];
then
	echo "TESTING: chromium"
	./chromium.exp
else
	echo "TESTING: chromium not found"
fi

which opera
if [ "$?" -eq 0 ];
then
	echo "TESTING: opera"
	./opera.exp
else
	echo "TESTING: opera not found"
fi

which transmission-gtk
if [ "$?" -eq 0 ];
then
	echo "TESTING: transmission-gtk"
	./transmission-gtk.exp
else
	echo "TESTING: transmission-gtk not found"
fi

which transmission-qt
if [ "$?" -eq 0 ];
then
	echo "TESTING: transmission-qt"
	./transmission-qt.exp
else
	echo "TESTING: transmission-qt not found"
fi

which evince
if [ "$?" -eq 0 ];
then
	echo "TESTING: evince"
	./evince.exp
else
	echo "TESTING: evince not found"
fi

echo "TESTING: PID"
./pid.exp

echo "TESTING: output"
./output.exp

echo "TESTING: profile no permissions"
./profile_noperm.exp

echo "TESTING: profile syntax"
./profile_syntax.exp

echo "TESTING: profile syntax 2"
./profile_syntax2.exp

echo "TESTING: profile rlimit"
./profile_rlimit.exp

echo "TESTING: profile read-only"
./profile_readonly.exp

echo "TESTING: profile tmpfs"
./profile_tmpfs.exp

echo "TESTING: profile applications"
./profile_apps.exp

echo "TESTING: private"
./private.exp `whoami`

echo "TESTING: private directory"
rm -fr dirprivate
mkdir dirprivate
./private_dir.exp
rm -fr dirprivate

echo "TESTING: private directory profile"
rm -fr dirprivate
mkdir dirprivate
./private_dir_profile.exp
rm -fr dirprivate

echo "TESTING: private keep"
./private-keep.exp

uname -r | grep "3.18"
if [ "$?" -eq 0 ];
then
	echo "TESTING: overlayfs on 3.18 kernel"
	./fs_overlay.exp
fi

grep "openSUSE" /etc/os-release
if [ "$?" -eq 0 ];
then
	echo "TESTING: overlayfs"
	./fs_overlay.exp
fi

grep "Ubuntu" /etc/os-release
if [ "$?" -eq 0 ];
then
	echo "TESTING: overlayfs"
	./fs_overlay.exp
fi

echo "TESTING: seccomp debug"
./seccomp-debug.exp

echo "TESTING: seccomp su"
./seccomp-su.exp

echo "TESTING: seccomp ptrace"
./seccomp-ptrace.exp

echo "TESTING: seccomp chmod (seccomp lists)"
./seccomp-chmod.exp

echo "TESTING: seccomp chmod profile (seccomp lists)"
./seccomp-chmod-profile.exp

echo "TESTING: seccomp empty"
./seccomp-empty.exp

echo "TESTING: seccomp bad empty"
./seccomp-bad-empty.exp

echo "TESTING: read/write /var/tmp"
./fs_var_tmp.exp

echo "TESTING: read/write /var/lock"
./fs_var_lock.exp

echo "TESTING: read/write /dev/shm"
./fs_dev_shm.exp

echo "TESTING: local network"
./net_local.exp

echo "TESTING: no network"
./net_none.exp

echo "TESTING: network IP"
./net_ip.exp

echo "TESTING: network MAC"
./net_mac.exp

echo "TESTING: network bad IP"
./net_badip.exp

echo "TESTING: network no IP test 1"
./net_noip.exp

echo "TESTING: network no IP test 2"
./net_noip2.exp

echo "TESTING: network default gateway test 1"
./net_defaultgw.exp

echo "TESTING: network default gateway test 2"
./net_defaultgw2.exp

echo "TESTING: network default gateway test 3"
./net_defaultgw3.exp

echo "TESTING: netfilter"
./net_netfilter.exp

echo "TESTING: 4 bridges ARP"
./4bridges_arp.exp

echo "TESTING: 4 bridges IP"
./4bridges_ip.exp

echo "TESTING: login SSH"
./login_ssh.exp

echo "TESTING: ARP"
./net_arp.exp

echo "TESTING: DNS"
./dns.exp

echo "TESTING: firemon --arp"
./firemon-arp.exp

echo "TESTING: firemon --route"
./firemon-route.exp

echo "TESTING: firemon --seccomp"
./firemon-seccomp.exp

echo "TESTING: firemon --caps"
./firemon-caps.exp

