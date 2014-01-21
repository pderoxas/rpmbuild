# VERSION is subbed out during rake srpm process
%global realversion 0.0.1
%global rpmversion 0.0.1

Name:		paypal-puppet-agent
Version:	%{rpmversion}
Release:	1%{?dist}
Summary:	DEMO version of the PayPal POS SDK Puppet RPM

Group:		PayPal Puppet DEMO
License:	GPL
URL:		http://www.paypal.com
Source0:	%{name}-%{realversion}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

#BuildRequires:	
BuildArch:      noarch
Requires:	puppet >= 3.4.2

%description
PayPal Puppet Package

%package setup
Group:          System Environment/Base
Summary:        PayPal Puppet Package DEMO
Requires:       puppet = %{version}-%{release}

%description setup
Provides the setup scripts for the PayPal Puppet Agent.

%prep
%setup -q

%build

%install
install -m 0777 paypal-puppet-agent-setup.sh %{buildroot}/paypal-puppet-agent-setup.sh

%post
echo "=========================================================================="
echo "PayPal Puppet Agent Install is almost complete."
echo "Please execute the /paypal-puppet-agent-setup.sh script to complete the setup."
echo "=========================================================================="

%clean

%files
/paypal-puppet-agent-setup.sh

%defattr(-,root,root,-)
%doc



%changelog

