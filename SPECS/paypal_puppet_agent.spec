# VERSION is subbed out during rake srpm process
%global realversion 1.0
%global rpmversion 1.0

Name:		paypal-puppet-agent
Version:	%{rpmversion}
Release:	1%{?dist}
Summary:	PayPay Retail POS SDK Puppet RPM

Group:		PayPal Puppet
License:	GPL
URL:		http://www.paypal.com
Source0:	%{name}-%{realversion}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

#BuildRequires:	
BuildArch:      noarch
Requires:	puppet >= 3.4.2

%description
PayPal Puppet Package

%prep
%setup -q

%build

%install
install -m 0777 paypal-puppet-agent-setup.sh %{buildroot}/paypal-puppet-agent-setup.sh

%post

%clean

%files
/paypal-puppet-agent-setup.sh

%defattr(-,root,root,-)
%doc



%changelog

