Name: firejail
Version: 0.9.30
Release: 1
Summary: Linux namepaces sandbox program

License: GPL+
Group: Development/Tools
Source0: https://github.com/netblue30/firejail/archive/%{version}.tar.gz#/%{name}-%{version}.tar.gz
URL: http://github.com/netblue30/firejail

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

%description
Firejail  is  a  SUID sandbox program that reduces the risk of security
breaches by restricting the running environment of untrusted applications
using Linux namespaces. It includes a sandbox profile for Mozilla Firefox.

%prep
%setup -q

%build
%configure
make %{?_smp_mflags}

%install
rm -rf %{buildroot}
%make_install

%clean
rm -rf %{buildroot}

%files
%doc
%defattr(-, root, root, -)
%attr(4755, -, -) %{_bindir}/firejail
%{_bindir}/firemon
%{_libdir}/firejail/ftee
%{_libdir}/firejail/fshaper.sh
%{_libdir}/firejail/libtrace.so
%{_libdir}/firejail/libtracelog.so
%{_datarootdir}/bash-completion/completions/firejail
%{_datarootdir}/bash-completion/completions/firemon
%{_docdir}/firejail
%{_mandir}/man1/firejail.1.gz
%{_mandir}/man1/firemon.1.gz
%{_mandir}/man5/firejail-login.5.gz
%{_mandir}/man5/firejail-profile.5.gz
%config %{_sysconfdir}/firejail

