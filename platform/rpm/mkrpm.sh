#!/bin/bash
VERSION="0.9.30"
rm -fr ~/rpmbuild
rm -f firejail-$VERSION-1.x86_64.rpm

mkdir -p ~/rpmbuild/{RPMS,SRPMS,BUILD,SOURCES,SPECS,tmp}
cat <<EOF >~/.rpmmacros
%_topdir   %(echo $HOME)/rpmbuild
%_tmppath  %{_topdir}/tmp
EOF

cd ~/rpmbuild
echo "building directory tree"

mkdir -p firejail-$VERSION/usr/bin
install -m 755 /usr/bin/firejail firejail-$VERSION/usr/bin/.
install -m 755 /usr/bin/firemon firejail-$VERSION/usr/bin/.

mkdir -p  firejail-$VERSION/usr/lib/firejail
install -m 644 /usr/lib/firejail/libtrace.so  firejail-$VERSION/usr/lib/firejail/.
install -m 755 /usr/lib/firejail/ftee  firejail-$VERSION/usr/lib/firejail/.
install -m 755 /usr/lib/firejail/fshaper.sh  firejail-$VERSION/usr/lib/firejail/.

mkdir -p firejail-$VERSION/usr/share/man/man1
install -m 644 /usr/share/man/man1/firejail.1.gz firejail-$VERSION/usr/share/man/man1/.
install -m 644 /usr/share/man/man1/firemon.1.gz firejail-$VERSION/usr/share/man/man1/.

mkdir -p firejail-$VERSION/usr/share/man/man5
install -m 644 /usr/share/man/man5/firejail-profile.5.gz firejail-$VERSION/usr/share/man/man5/.
install -m 644 /usr/share/man/man5/firejail-login.5.gz firejail-$VERSION/usr/share/man/man5/.

mkdir -p firejail-$VERSION/usr/share/doc/packages/firejail
install -m 644 /usr/share/doc/firejail/COPYING firejail-$VERSION/usr/share/doc/packages/firejail/.
install -m 644 /usr/share/doc/firejail/README firejail-$VERSION/usr/share/doc/packages/firejail/.
install -m 644 /usr/share/doc/firejail/RELNOTES firejail-$VERSION/usr/share/doc/packages/firejail/.

mkdir -p firejail-$VERSION/etc/firejail
install -m 644 /etc/firejail/xchat.profile firejail-$VERSION/etc/firejail/xchat.profile
install -m 644 /etc/firejail/server.profile firejail-$VERSION/etc/firejail/server.profile
install -m 644 /etc/firejail/quassel.profile firejail-$VERSION/etc/firejail/quassel.profile
install -m 644 /etc/firejail/pidgin.profile firejail-$VERSION/etc/firejail/pidgin.profile
install -m 644 /etc/firejail/icecat.profile firejail-$VERSION/etc/firejail/icecat.profile
install -m 644 /etc/firejail/filezilla.profile firejail-$VERSION/etc/firejail/filezilla.profile
install -m 644 /etc/firejail/chromium-browser.profile firejail-$VERSION/etc/firejail/chromium-browser.profile
install -m 644 /etc/firejail/chromium.profile firejail-$VERSION/etc/firejail/chromium.profile
install -m 644 /etc/firejail/dropbox.profile firejail-$VERSION/etc/firejail/dropbox.profile
install -m 644 /etc/firejail/disable-common.inc firejail-$VERSION/etc/firejail/disable-common.inc
install -m 644 /etc/firejail/disable-history.inc firejail-$VERSION/etc/firejail/disable-history.inc
install -m 644 /etc/firejail/disable-secret.inc firejail-$VERSION/etc/firejail/disable-secret.inc
install -m 644 /etc/firejail/disable-mgmt.inc firejail-$VERSION/etc/firejail/disable-mgmt.inc
install -m 644 /etc/firejail/evince.profile firejail-$VERSION/etc/firejail/evince.profile
install -m 644 /etc/firejail/firefox.profile firejail-$VERSION/etc/firejail/firefox.profile
install -m 644 /etc/firejail/icedove.profile firejail-$VERSION/etc/firejail/icedove.profile
install -m 644 /etc/firejail/iceweasel.profile firejail-$VERSION/etc/firejail/iceweasel.profile
install -m 644 /etc/firejail/midori.profile firejail-$VERSION/etc/firejail/midori.profile
install -m 644 /etc/firejail/thunderbird.profile firejail-$VERSION/etc/firejail/thunderbird.profile
install -m 644 /etc/firejail/opera.profile firejail-$VERSION/etc/firejail/opera.profile
install -m 644 /etc/firejail/transmission-gtk.profile firejail-$VERSION/etc/firejail/transmission-gtk.profile
install -m 644 /etc/firejail/transmission-qt.profile firejail-$VERSION/etc/firejail/transmission-qt.profile
install -m 644 /etc/firejail/vlc.profile firejail-$VERSION/etc/firejail/vlc.profile
install -m 644 /etc/firejail/audacious.profile firejail-$VERSION/etc/firejail/audacious.profile
install -m 644 /etc/firejail/clementine.profile firejail-$VERSION/etc/firejail/clementine.profile
install -m 644 /etc/firejail/gnome-mplayer.profile firejail-$VERSION/etc/firejail/gnome-mplayer.profile
install -m 644 /etc/firejail/rhythmbox.profile firejail-$VERSION/etc/firejail/rhythmbox.profile
install -m 644 /etc/firejail/totem.profile firejail-$VERSION/etc/firejail/totem.profile
install -m 644 /etc/firejail/deluge.profile firejail-$VERSION/etc/firejail/deluge.profile
install -m 644 /etc/firejail/qbittorrent.profile firejail-$VERSION/etc/firejail/qbittorrent.profile
install -m 644 /etc/firejail/generic.profile firejail-$VERSION/etc/firejail/generic.profile
install -m 644 /etc/firejail/login.users firejail-$VERSION/etc/firejail/login.users
install -m 644 /etc/firejail/deadbeef.profile firejail-$VERSION/etc/firejail/deadbeef.profile
install -m 644 /etc/firejail/empathy.profile firejail-$VERSION/etc/firejail/empathy.profile


mkdir -p firejail-$VERSION/usr/share/bash-completion/completions
install -m 644 /usr/share/bash-completion/completions/firejail  firejail-$VERSION/usr/share/bash-completion/completions/.
install -m 644 /usr/share/bash-completion/completions/firemon  firejail-$VERSION/usr/share/bash-completion/completions/.

echo "building tar.gz archive"
tar -czvf firejail-$VERSION.tar.gz firejail-$VERSION

cp firejail-$VERSION.tar.gz SOURCES/.

echo "building config spec"
cat <<EOF > SPECS/firejail.spec
%define        __spec_install_post %{nil}
%define          debug_package %{nil}
%define        __os_install_post %{_dbpath}/brp-compress

Summary: Linux namepaces sandbox program
Name: firejail
Version: $VERSION
Release: 1
License: GPL+
Group: Development/Tools
SOURCE0 : %{name}-%{version}.tar.gz
URL: http://github.com/netblue30/firejail

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

%description
Firejail  is  a  SUID sandbox program that reduces the risk of security
breaches by restricting the running environment of untrusted applications
using Linux namespaces. It includes a sandbox profile for Mozilla Firefox.

%prep
%setup -q

%build

%install
rm -rf %{buildroot}
mkdir -p  %{buildroot}

cp -a * %{buildroot}


%clean
rm -rf %{buildroot}


%files
%defattr(-,root,root,-)
%config(noreplace) %{_sysconfdir}/%{name}/chromium-browser.profile
%config(noreplace) %{_sysconfdir}/%{name}/chromium.profile
%config(noreplace) %{_sysconfdir}/%{name}/disable-mgmt.inc
%config(noreplace) %{_sysconfdir}/%{name}/disable-secret.inc
%config(noreplace) %{_sysconfdir}/%{name}/dropbox.profile
%config(noreplace) %{_sysconfdir}/%{name}/evince.profile
%config(noreplace) %{_sysconfdir}/%{name}/firefox.profile
%config(noreplace) %{_sysconfdir}/%{name}/icedove.profile
%config(noreplace) %{_sysconfdir}/%{name}/iceweasel.profile
%config(noreplace) %{_sysconfdir}/%{name}/login.users
%config(noreplace) %{_sysconfdir}/%{name}/midori.profile
%config(noreplace) %{_sysconfdir}/%{name}/opera.profile
%config(noreplace) %{_sysconfdir}/%{name}/thunderbird.profile
%config(noreplace) %{_sysconfdir}/%{name}/transmission-gtk.profile
%config(noreplace) %{_sysconfdir}/%{name}/transmission-qt.profile
%config(noreplace) %{_sysconfdir}/%{name}/vlc.profile
%config(noreplace) %{_sysconfdir}/%{name}/audacious.profile
%config(noreplace) %{_sysconfdir}/%{name}/clementine.profile
%config(noreplace) %{_sysconfdir}/%{name}/gnome-mplayer.profile
%config(noreplace) %{_sysconfdir}/%{name}/rhythmbox.profile
%config(noreplace) %{_sysconfdir}/%{name}/totem.profile
%config(noreplace) %{_sysconfdir}/%{name}/deluge.profile
%config(noreplace) %{_sysconfdir}/%{name}/qbittorrent.profile
%config(noreplace) %{_sysconfdir}/%{name}/generic.profile
%config(noreplace) %{_sysconfdir}/%{name}/deadbeef.profile
%config(noreplace) %{_sysconfdir}/%{name}/disable-common.inc
%config(noreplace) %{_sysconfdir}/%{name}/disable-history.inc
%config(noreplace) %{_sysconfdir}/%{name}/empathy.profile
%config(noreplace) %{_sysconfdir}/%{name}/filezilla.profile
%config(noreplace) %{_sysconfdir}/%{name}/icecat.profile
%config(noreplace) %{_sysconfdir}/%{name}/pidgin.profile
%config(noreplace) %{_sysconfdir}/%{name}/quassel.profile
%config(noreplace) %{_sysconfdir}/%{name}/server.profile
%config(noreplace) %{_sysconfdir}/%{name}/xchat.profile

/usr/bin/firejail
/usr/bin/firemon
/usr/lib/firejail/libtrace.so
/usr/lib/firejail/ftee
/usr/lib/firejail/fshaper.sh
/usr/share/doc/packages/firejail/COPYING
/usr/share/doc/packages/firejail/README
/usr/share/doc/packages/firejail/RELNOTES
/usr/share/man/man1/firejail.1.gz
/usr/share/man/man1/firemon.1.gz
/usr/share/man/man5/firejail-profile.5.gz
/usr/share/man/man5/firejail-login.5.gz
/usr/share/bash-completion/completions/firejail
/usr/share/bash-completion/completions/firemon
 
%post
chmod u+s /usr/bin/firejail

%changelog
* Mon Sep 14 2015 netblue30 <netblue30@yahoo.com> 0.9.30-1
 - added a disable-history.inc profile as a result of Firefox PDF.js exploit;
   disable-history.inc included in all default profiles
 - Firefox PDF.js exploit (CVE-2015-4495) fixes
 - added --private-etc option
 - added --env option
 - added --whitelist option
 - support ${HOME} token in include directive in profile files
 - --private.keep is transitioned to --private-home
 - support ~ and blanks in blacklist option
 - support "net none" command in profile files
 - using /etc/firejail/generic.profile by default for user sessions
 - using /etc/firejail/server.profile by default for root sessions
 - added build --enable-fatal-warnings configure option
 - added persistence to --overlay option
 - added --overlay-tmpfs option
 - make install-strip implemented, make install renamed
 - bugfixes

* Sat Aug 1 2015 netblue30 <netblue30@yahoo.com> 0.9.28-1
 - network scanning, --scan option
 - interface MAC address support, --mac option
 - IP address range, --iprange option
 - traffic shaping, --bandwidth option
 - reworked printing of network status at startup
 - man pages rework
 - added firejail-login man page
 - added GNU Icecat, FileZilla, Pidgin, XChat, Empathy, DeaDBeeF default
   profiles
 - added an /etc/firejail/disable-common.inc file to hold common directory
   blacklists
 - blacklist Opera and Chrome/Chromium config directories in profile files
 - support noroot option for profile files
 - enabled noroot in default profile files
 - bugfixes

* Thu Apr 30 2015 netblue30 <netblue30@yahoo.com> 0.9.26-1
 - private dev directory
 - private.keep option for whitelisting home files in a new private directory
 - user namespaces support, noroot option
 - added Deluge and qBittorent profiles
 - bugfixes

* Sun Apr 5 2015  netblue30 <netblue30@yahoo.com> 0.9.24-1
 - whitelist and blacklist seccomp filters
 - doubledash option
 - --shell=none support
 - netfilter file support in profile files
 - dns server support in profile files
 - added --dns.print option
 - added default profiles for Audoacious, Clementine, Rhythmbox and Totem.
 - added --caps.drop=all in default profiles
 - new syscalls in default seccomp filter: sysfs, sysctl, adjtimex, kcmp
 -        clock_adjtime, lookup_dcookie, perf_event_open, fanotify_init
 - Bugfix: using /proc/sys/kernel/pid_max for the max number of pids
 - two build patches from Reiner Herman (tickets 11, 12)
 - man page patch from Reiner Herman (ticket 13)
 - output patch (ticket 15) from sshirokov

* Mon Mar 9 2015  netblue30 <netblue30@yahoo.com> 0.9.22-1
 - Replaced --noip option with --ip=none
 - Container stdout logging and log rotation
 - Added process_vm_readv, process_vm_writev and mknod to
     default seccomp blacklist
 - Added CAP_MKNOD to default caps blacklist
 - Blacklist and whitelist custom Linux capabilities filters
 - macvlan device driver support for --net option
 - DNS server support, --dns option
 - Netfilter support
 - Monitor network statistics, --netstats option
 - Added profile for Mozilla Thunderbird/Icedove
 - --overlay support for Linux kernels 3.18+
 - Bugfix: preserve .Xauthority file in private mode (test with ssh -X)
 - Bugfix: check uid/gid for cgroup

* Fri Feb 6 2015   netblue30 <netblue30@yahoo.com> 0.9.20-1
 - utmp, btmp and wtmp enhancements
 -    create empty /var/log/wtmp and /var/log/btmp files in sandbox
 -    generate a new /var/run/utmp file in sandbox
 - CPU affinity, --cpu option
 - Linux control groups support, --cgroup option
 - Opera web browser support
 - VLC support
 - Added "empty" attribute to seccomp command to remove the default
 -    syscall list form seccomp blacklist
 - Added --nogroups option to disable supplementary groups for regular
 -   users. root user always runs without supplementary groups.
 - firemon enhancements
 -   display the command that started the sandbox
 -   added --caps option to display capabilities for all sandboxes
 -   added --cgroup option to display the control groups for all sandboxes
 -   added --cpu option to display CPU affinity for all sandboxes
 -   added --seccomp option to display seccomp setting for all sandboxes
 - New compile time options: --disable-chroot, --disable-bind
 - bugfixes

* Sat Dec 27 2014  netblue30 <netblue30@yahoo.com> 0.9.18-1
 - Support for tracing system, setuid, setgid, setfsuid, setfsgid syscalls
 - Support for tracing setreuid, setregid, setresuid, setresguid syscalls
 - Added profiles for transmission-gtk and transmission-qt
 - bugfixes

* Tue Nov 4 2014  netblue30 <netblue30@yahoo.com> 0.9.16-1
 - Configurable private home directory
 - Configurable default user shell
 - Software configuration support for --docdir and DESTDIR
 - Profile file support for include, caps, seccomp and private keywords
 - Dropbox profile file
 - Linux capabilities and seccomp filters enabled by default for Firefox,
  Midori, Evince and Dropbox
 - bugfixes

* Wed Oct 8 2014  netblue30 <netblue30@yahoo.com> 0.9.14-1
 - Linux capabilities and seccomp filters are automatically enabled in 
   chroot mode (--chroot option) if the sandbox is started as regular
   user
 - Added support for user defined seccomp blacklists
 - Added syscall trace support
 - Added --tmpfs option
 - Added --balcklist option
 - Added --read-only option
 - Added --bind option
 - Logging enhancements
 - --overlay option was reactivated
 - Added firemon support to print the ARP table for each sandbox
 - Added firemon support to print the route table for each sandbox
 - Added firemon support to print interface information for each sandbox
 - bugfixes

* Tue Sep 16 2014 netblue30 <netblue30@yahoo.com> 0.9.12-1
 - Added capabilities support
 - Added support for CentOS 7
 - bugfixes

EOF

echo "building rpm"
rpmbuild -ba SPECS/firejail.spec
rpm -qpl RPMS/x86_64/firejail-$VERSION-1.x86_64.rpm
cd ..
rm -f firejail-$VERSION-1.x86_64.rpm
cp rpmbuild/RPMS/x86_64/firejail-$VERSION-1.x86_64.rpm .

