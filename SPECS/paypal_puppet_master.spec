# VERSION is subbed out during rake srpm process
%global realversion 1.0
%global rpmversion 1.0

Name:		paypal-puppet-master
Version:	%{rpmversion}
Release:	1%{?dist}
Summary:	PayPal POS SDK Puppet RPM

Group:		PayPal Puppet DEMO
License:	GPL
URL:		http://www.paypal.com
Source0:	%{name}-%{realversion}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

#BuildRequires:	
BuildArch:      noarch
Requires:	puppet-server >= 3.4.2

%description
PayPal Puppet Package

%prep
%setup -q

%build

%install
install -m 0777 paypal-puppet-master-setup.sh %{buildroot}/paypal-puppet-master-setup.sh

%clean

%files
/paypal-puppet-master-setup.sh

%defattr(-,root,root,-)
%doc



%changelog

