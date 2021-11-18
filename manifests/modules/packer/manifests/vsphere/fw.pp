# == Class: packer::fw
#
# A define that manages firewall
#
class packer::vsphere::fw {

  if ($facts['osfamily'] == 'RedHat')
  and ($facts['operatingsystemmajrelease'] == '7') {
    class { 'firewall':
      ensure => stopped,
    }
  }

  # RHEL 8 comes with firewalld, we need this specific declaration because puppetlabs-firewall only manages iptables
  if ($facts['osfamily'] == 'RedHat')
  and ($facts['operatingsystemmajrelease'] == '8') {
    service { 'firewalld':
      ensure => stopped,
      enable => false
    }
  }
}
