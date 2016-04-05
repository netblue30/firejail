#!/bin/bash

./chk_config.exp

./test-profiles.sh

./fscheck.sh

echo "TESTING: caps.print (caps-print.exp)
./caps-print.exp

echo "TESTING: sound (sound.exp)"
./sound.exp

echo "TESTING: nice (nice.exp)"
./nice.exp

echo "TESTING: tty (tty.exp)"
./tty.exp

echo "TESTING: protocol (protocol.exp)"
./protocol.exp

echo "TESTING: invalid filename (invalid_filename.exp)"
./invalid_filename.exp

echo "TESTING: environment variables (env.exp)"
./env.exp

echo "TESTING: whitelist empty (whitelist-empty.exp)"
./whitelist-empty.exp

echo "TESTING: ignore command (ignore.exp)"
./ignore.exp

echo "TESTING: private-etc (private-etc.exp)"
./private-etc.exp

echo "TESTING: private-bin (private-bin.exp)"
./private-bin.exp

echo "TESTING: private whitelist (private-whitelist.exp)"
echo "TESTING:    failing on OpenSUSE"
./private-whitelist.exp

sleep 1
rm -fr dir\ with\ space
mkdir dir\ with\ space
echo "TESTING: blacklist (blacklist.exp)"
./blacklist.exp
sleep 1
rm -fr dir\ with\ space

ln -s auto auto2
ln -s /bin auto3
ln -s /usr/bin auto4
echo "TESTING: blacklist directory link (blacklist-link.exp)"
./blacklist-link.exp
rm -fr auto2
rm -fr auto3
rm -fr auto4


echo "TESTING: version (option_version.exp)"
./option_version.exp

echo "TESTING: help (option_help.exp)"
./option_help.exp

echo "TESTING: man (option_man.exp)"
./option_man.exp

echo "TESTING: list (option_list.exp)"
./option_list.exp

echo "TESTING: tree (option_tree.exp)"
./option_tree.exp

if [ -f /proc/self/uid_map ];
then
	echo "TESTING: noroot (noroot.exp)"
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

echo "TESTING: trace1 (option-trace.exp)"
./option-trace.exp

echo "TESTING: trace2 (trace.exp)"
rm -f index.html*
./trace.exp
rm -f index.html*

echo "TESTING: extract command (extract_command.exp)"
./extract_command.exp

echo "TESTING: kmsg access (kmsg.exp)"
./kmsg.exp

echo "TESTING: rlimit (option_rlimit.exp)"
./option_rlimit.exp

echo "TESTING: shutdown (option_shutdown.exp)"
./option-shutdown.exp

echo "TESTING: join (option-join.exp)"
./option-join.exp

echo "TESTING: join2 (option-join2.exp)"
./option-join2.exp

echo "TESTING: join3 (option-join3.exp)"
./option-join3.exp

echo "TESTING: join profile (option-join-profile.exp)"
./option-join-profile.exp

echo "TESTING: firejail in firejail - single sandbox (firejail-in-firejail.exp)"
./firejail-in-firejail.exp

echo "TESTING: firejail in firejail - force new sandbox (firejail-in-firejail2.exp)"
./firejail-in-firejail2.exp

echo "TESTING: chroot overlay (option_chroot_overlay.exp)"
./option_chroot_overlay.exp

echo "TESTING: blacklist directory (option_blacklist.exp)"
./option_blacklist.exp

echo "TESTING: blacklist file (opiton_blacklist_file.exp)"
./option_blacklist_file.exp

echo "TESTING: bind as user (option_bind_user.exp)"
./option_bind_user.exp

if [ -d /home/bingo ];
then
	echo "TESTING: home sanitize (opiton_version.exp)"
	./option_version.exp
fi

echo "TESTING: chroot as user (fs_chroot.exp)"
./fs_chroot.exp

echo "TESTING: /sys (fs_sys.exp)"
./fs_sys.exp

echo "TESTING: readonly (option_readonly.exp)"
ls -al > tmpreadonly
./option_readonly.exp
sleep 5
rm -f tmpreadonly

echo "TESTING: zsh (shell_zsh.exp)"
./shell_zsh.exp

echo "TESTING: csh (shell_csh.exp)"
./shell_csh.exp

which dash
if [ "$?" -eq 0 ];
then
        echo "TESTING: dash (shell_dash.exp)"
        ./shell_dash.exp
else
        echo "TESTING: dash not found"
fi

./test-apps.sh
./test-apps-x11.sh

echo "TESTING: PID (pid.exp)"
./pid.exp

echo "TESTING: output (output.exp)"
./output.exp

echo "TESTING: profile no permissions (profile_noperm.exp)"
./profile_noperm.exp

echo "TESTING: profile syntax (profile_syntax.exp)"
./profile_syntax.exp

echo "TESTING: profile syntax 2 (profile_syntax2.exp)"
./profile_syntax2.exp

echo "TESTING: profile rlimit (profile_rlimit.exp)"
./profile_rlimit.exp

echo "TESTING: profile read-only (profile_readonly.exp)"
./profile_readonly.exp

echo "TESTING: private (private.exp)"
./private.exp `whoami`

echo "TESTING: private directory (private_dir.exp)"
rm -fr dirprivate
mkdir dirprivate
./private_dir.exp
rm -fr dirprivate

echo "TESTING: private directory profile (private_dir_profile.exp)"
rm -fr dirprivate
mkdir dirprivate
./private_dir_profile.exp
rm -fr dirprivate

echo "TESTING: overlayfs (fs_overlay.exp)"
./fs_overlay.exp

echo "TESTING: seccomp debug  (seccomp-debug.exp)"
./seccomp-debug.exp

echo "TESTING: seccomp errno (seccomp-errno.exp)"
./seccomp-errno.exp

echo "TESTING: seccomp su (seccomp-su.exp)"
./seccomp-su.exp

echo "TESTING: seccomp ptrace (seccomp-ptrace.exp)"
./seccomp-ptrace.exp

echo "TESTING: seccomp chmod - seccomp lists (seccomp-chmod.exp)"
./seccomp-chmod.exp

echo "TESTING: seccomp chmod profile - seccomp lists (seccomp-chmod-profile.exp)"
./seccomp-chmod-profile.exp

echo "TESTING: seccomp empty (seccomp-empty.exp)"
./seccomp-empty.exp

echo "TESTING: seccomp bad empty (seccomp-bad-empty.exp)"
./seccomp-bad-empty.exp

echo "TESTING: seccomp dual filter (seccomp-dualfilter.exp)"
./seccomp-dualfilter.exp

echo "TESTING: read/write /var/tmp (fs_var_tmp.exp)"
./fs_var_tmp.exp

echo "TESTING: read/write /var/lock (fs_var_lock.exp)"
./fs_var_lock.exp

echo "TESTING: read/write /dev/shm (fs_dev_shm.exp)"
./fs_dev_shm.exp

echo "TESTING: quiet (quiet.exp)"
./quiet.exp

echo "TESTING: IPv6 support (ip6.exp)"
echo "TESTING:    broken on Centos - todo"
./ip6.exp

echo "TESTING: local network (net_local.exp)"
./net_local.exp

echo "TESTING: no network (net_none.exp)"
./net_none.exp

echo "TESTING: network IP (net_ip.exp)"
./net_ip.exp

echo "TESTING: network MAC (net_mac.exp)"
sleep 2
./net_mac.exp

echo "TESTING: network MTU (net_mtu.exp)"
./net_mtu.exp

echo "TESTING: network hostname (hostname.exp)"
./hostname.exp

echo "TESTING: network bad IP (net_badip.exp)"
./net_badip.exp

echo "TESTING: network no IP test 1 (net_noip.exp)"
./net_noip.exp

echo "TESTING: network no IP test 2 (net_noip2.exp)"
./net_noip2.exp

echo "TESTING: network default gateway test 1 (net_defaultgw.exp)"
./net_defaultgw.exp

echo "TESTING: network default gateway test 2 (net_defaultgw2.exp)"
./net_defaultgw2.exp

echo "TESTING: network default gateway test 3 (net_defaultgw3.exp)"
./net_defaultgw3.exp

echo "TESTING: netfilter (net_netfilter.exp)"
./net_netfilter.exp

echo "TESTING: 4 bridges ARP (4bridges_arp.exp)"
./4bridges_arp.exp

echo "TESTING: 4 bridges IP (4bridges_ip.exp)"
./4bridges_ip.exp

echo "TESTING: login SSH (login_ssh.exp)"
./login_ssh.exp

echo "TESTING: ARP (net_arp.exp)"
./net_arp.exp

echo "TESTING: DNS (dns.exp)"
./dns.exp

echo "TESTING: firemon --arp (firemon-arp.exp)"
./firemon-arp.exp

echo "TESTING: firemon --route (firemon-route.exp)"
./firemon-route.exp

echo "TESTING: firemon --seccomp (firemon-seccomp.exp)"
./firemon-seccomp.exp

echo "TESTING: firemon --caps (firemon-caps.exp)"
./firemon-caps.exp

