Name:		apt-file
Summary:	APT package search utility
Version:	0.2.4
Release:	2
Source:		%{name}-%{version}.tar.gz
Group:		System
Copyright:	GPL
BuildRoot:	/tmp/making_of_%{name}_%{version}
Patch:		%{name}-%{version}-rpm
URL:            http://apt4rpm.sourceforge.net
Packager:       apt4rpm-devel@lists.sourceforge.net
Requires:	perl-libwww-perl >= 5.53, perl-AppConfig >= 1.52, gzip >= 1.2.4 

#----------------------------------------------------------
%define PREFIX /usr
%define DOCS debian/copyright changelog README TODO

#----------------------------------------------------------
%description
apt-file is a command line tool for searching packages for the APT
packaging system.
Unlike apt-cache, you can search in which package a file is inclued
or list the contents of a package without installing or fetching it.


#----------------------------------------------------------
%prep
[ "$RPM_BUILD_ROOT" != "/" ] && [ -d $RPM_BUILD_ROOT ] && rm -rf $RPM_BUILD_ROOT

#----------------------------------------------------------
%setup

#----------------------------------------------------------
%build

#----------------------------------------------------------
%install
install -d -m 755 $RPM_BUILD_ROOT/etc/apt
install -d -m 755 $RPM_BUILD_ROOT%{PREFIX}/bin 
install -d -m 755 $RPM_BUILD_ROOT%{PREFIX}/share/man/man1
install -m 755 apt-file   $RPM_BUILD_ROOT%{PREFIX}/bin
install -m 644 apt-file.1 $RPM_BUILD_ROOT%{PREFIX}/share/man/man1
install -m 644 apt-file.conf $RPM_BUILD_ROOT/etc/apt

#----------------------------------------------------------
%clean
[ "$RPM_BUILD_ROOT" != "/" ] && [ -d $RPM_BUILD_ROOT ] && rm -rf $RPM_BUILD_ROOT

#----------------------------------------------------------
%files
%defattr(-,root,root)
%config(noreplace) /etc/apt/apt-file.conf
%{PREFIX}/bin/*
%doc %{DOCS}
%doc %{_mandir}/man1/*

%changelog
* Mon May 02 2002 R Bos
- Initial rpm version

