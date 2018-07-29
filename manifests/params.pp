# == Class consul::params
#
# This class is meant to be called from consul
# It sets variables according to platform
#
class consul::params {
  $acls                  = {}
  $archive_path          = ''
  $bin_dir               = '/usr/local/bin'
  $checks                = {}
  $config_defaults       = {}
  $config_hash           = {}
  $config_mode           = '0664'
  $docker_image          = 'consul'
  $download_extension    = 'zip'
  $download_url_base     = 'https://releases.hashicorp.com/consul/'
  $extra_groups          = []
  $extra_options         = ''
  $group                 = 'consul'
  $log_file              = '/var/log/consul'
  $install_method        = 'url'
  $join_wan              = false
  $manage_group          = true
  $manage_service        = true
  $manage_user           = true
  $package_ensure        = 'latest'
  $package_name          = 'consul'
  $pretty_config         = false
  $pretty_config_indent  = 4
  $purge_config_dir      = true
  $restart_on_change     = true
  $service_enable        = true
  $service_ensure        = 'running'
  $services              = {}
  $user                  = 'consul'
  $version               = '0.7.4'
  $watches               = {}

  case $::architecture {
    'x86_64', 'x64', 'amd64': { $arch = 'amd64' }
    'i386':                   { $arch = '386'   }
    'aarch64':                { $arch = 'arm64' }
    /^arm.*/:                 { $arch = 'arm'   }
    default:                  {
      fail("Unsupported kernel architecture: ${::architecture}")
    }
  }

  $config_dir = $::osfamily ? {
    'FreeBSD' => '/usr/local/etc/consul.d',
    'windows' => 'c:/Consul/config',
    default   => '/etc/consul'
  }

  $os = downcase($::kernel)

  case $::operatingsystem {
    'windows': {
      $binary_group = 'Administrators'
      $binary_mode = '0755'
      $binary_name = 'consul.exe'
      $binary_owner = 'Administrator'
    }
    default: {
      # 0 instead of root because OS X uses "wheel".
      $binary_group = 0
      $binary_mode = '0555'
      $binary_name = 'consul'
      $binary_owner = 'root'
    }
  }

  if $::operatingsystem == 'Ubuntu' {
    $shell = '/usr/sbin/nologin'
  } elsif $::osfamily == 'RedHat' {
    $shell = '/sbin/nologin'
  } elsif $::operatingsystem == 'Debian' {
    $shell = '/usr/sbin/nologin'
  } elsif $::operatingsystem == 'Archlinux' {
    $shell = '/sbin/nologin'
  } elsif $::operatingsystem == 'OpenSuSE' {
    $shell = '/usr/sbin/nologin'
  } elsif $::operatingsystem =~ /SLE[SD]/ {
    $shell = '/usr/sbin/nologin'
  } elsif $::operatingsystem == 'Darwin' {
    $shell = undef
  } elsif $::operatingsystem == 'FreeBSD' {
  } elsif $::operatingsystem == 'windows' {
    $shell = undef
  }

  if $facts['operatingsystem'] == 'windows' {
    $init_style = 'unmanaged'
  } else {
    $init_style = $facts['service_provider']
  }
}
