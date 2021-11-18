# For platforms that come up without any configured software repos
# (e.g, RHEL), this class is used to configure repos pointing to
# our internal mirrors so that packages can be installed by other
# puppet classes (mainly vmtools.pp).
#
# TODO: Consolidate this and the vsphere repos manifest into a single
# module, which can be conditionally included in base.pp for targeted
# platforms and for all cases in vsphere.pp.
# == Class: packer::repos
#
# A define that manages repos
#
class packer::repos {

  if $facts['operatingsystem'] == 'RedHat' {

    $repo_mirror = 'https://artifactory.delivery.puppetlabs.net/artifactory'
    $os_mirror   = 'http://osmirror.delivery.puppetlabs.net'
    $gpgkey      = 'RPM-GPG-KEY-redhat-release'

    resources { 'yumrepo':
      purge => true,
    }

    # We don't have consistent mirror urls between RedHat versions:
    # TODO: RHEL 5 needs further refactoring
    $base_url = $::operatingsystemmajrelease ? {
      '8' => "${repo_mirror}/rpm__remote_rhel-8",
      '7' => "${repo_mirror}/rpm__remote_rhel-7",
    }

    if $facts['operatingsystemmajrelease'] == '8' {
      yumrepo { 'localmirror-base':
        descr    => 'localmirror-base',
        baseurl  => "${base_url}-base",
        gpgcheck => '1',
        gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-beta,file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release'
      }

      yumrepo { 'localmirror-appstream':
        descr    => 'localmirror-appstream',
        baseurl  => "${base_url}-appstream",
        gpgcheck => '1',
        gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-beta,file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release'
      }
    } else {

      yumrepo { 'localmirror-os':
        descr    => 'localmirror-os',
        baseurl  => "${base_url}-os",
        gpgcheck => '1',
        gpgkey   => "file:///etc/pki/rpm-gpg/${gpgkey}"
      }

      yumrepo { 'localmirror-optional':
        descr    => 'localmirror-optional',
        baseurl  => "${base_url}-optional",
        gpgcheck => '1',
        gpgkey   => "file:///etc/pki/rpm-gpg/${gpgkey}"
      }

      yumrepo { 'localmirror-extras':
        descr    => 'localmirror-extras',
        baseurl  => "${base_url}-extras",
        gpgcheck => '1',
        gpgkey   => "file:///etc/pki/rpm-gpg/${gpgkey}"
      }
    }

  }
}
