Name: __NAME__
Version: __VERSION__
Release: 1
Summary: Linux namespaces sandbox program

License: GPLv2+
Group: Development/Tools
Source0: https://github.com/netblue30/firejail/archive/%{version}.tar.gz#/%{name}-%{version}.tar.gz
URL: https://github.com/netblue30/firejail

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

%description
Firejail is a SUID sandbox program that reduces the risk of security
breaches by restricting the running environment of untrusted applications
using Linux namespaces. It includes a sandbox profile for Mozilla Firefox.

%prep
%setup -q

%build
%configure __CONFIG_OPT__
make %{?_smp_mflags}

%install
rm -rf %{buildroot}
%make_install

%clean
rm -rf %{buildroot}

%files
%doc
%defattr(-, root, root, -)
%attr(4755, -, -) %{_bindir}/__NAME__
%{_bindir}/firecfg
%{_bindir}/firemon
%{_libdir}/__NAME__
%{_datarootdir}/bash-completion/completions/__NAME__
%{_datarootdir}/bash-completion/completions/firecfg
%{_datarootdir}/bash-completion/completions/firemon
%{_datarootdir}/zsh/site-functions/_firejail
%{_docdir}/__NAME__
%{_mandir}/man1/__NAME__.1.gz
%{_mandir}/man1/firecfg.1.gz
%{_mandir}/man1/firemon.1.gz
%{_mandir}/man5/__NAME__-login.5.gz
%{_mandir}/man5/__NAME__-profile.5.gz
%{_mandir}/man5/__NAME__-users.5.gz
%config(noreplace) %{_sysconfdir}/__NAME__
