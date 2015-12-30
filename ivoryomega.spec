Name:		ivoryomega
Version:	VERSION
Release:	RELEASE
Summary:	installs repo file

License:	GNU GPL3
URL:		https://github.com/oldgamma/ivoryomega
Source0:	%{name}-%{version}.tar.gz

BuildRequires:	coreutils

%description
Installs the repo file

%prep
%setup -q
%global debug_package %{nil}

%build

%install
rm -rf ${RPM_BUILD_ROOT} &&
mkdir --parents ${RPM_BUILD_ROOT}/etc/yum.repos.d &&
cp dancingleather.repo ${RPM_BUILD_ROOT}/etc/yum.repos.d &&
true

%files
/etc/yum.repos.d/dancingleather.repo
