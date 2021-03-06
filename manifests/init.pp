# Define: route
#
#   This module manage route file(/etc/rc3.d/S27route).
#
# Parameters:
#
# Actions:
#
# Requires:
#
#   puppetlabs-stdlib
#
# Sample Usage:
#
#  $target_net = ['20.20.20.0/24', '10.20.0.0/16', '10.10.20.21']
#  route { $target_net: 
#    gateway     => '10.10.10.1',
#  }
#
#  $target_net_absent = ['10.20.30.0/16'， '10.10.20.51']
#  route { $target_net_absent:
#    ensure      => absent,
#    gateway     => '10.10.10.1',
#  }
#
define route (
  $ensure          = present,
  $gateway         = '',
  $route_file      = 'S27route',
  $route_file_path = '/etc/rc3.d'
) {

  validate_re($ensure, [present, 'add', absent, 'del'])
  validate_string($gateway)
  validate_string($route_file)
  validate_absolute_path($route_file_path)

  if ! is_ip_address($gateway) {
    fail("The gateway must be a ipaddress.")
  }

  if $name =~ /\// {
    $target_type = 'net'
  } else {
    $target_type = 'host'
  }

  if !defined(File["${route_file_path}/${route_file}"]){
    file { "${route_file_path}/${route_file}":
      ensure => "present",
      mode => "a+x",
    }
  }

  if ($ensure in [present, 'add']) {
    file_line { "$name":
      ensure  => present,
      line    => "${::route} add -${target_type} ${title} gw ${gateway}",
      path    => "${route_file_path}/${route_file}",
    }
    exec { "$name":
      command     => "${::route} add -${target_type} ${title} gw ${gateway}",
      refreshonly => true,
      subscribe   => File_line[$name],
    }
  } elsif ($ensure in [absent, 'del']) {
    file_line { "$name":
      ensure => absent,
      line   => "${::route} add -${target_type} ${title} gw ${gateway}",
      path   => "${route_file_path}/${route_file}",
    }
    exec { "$name":
      command     => "${::route} del -${target_type} ${title} gw ${gateway}",
      refreshonly => true,
      subscribe   => File_line[$name],
    }
  }

  File["${route_file_path}/${route_file}"] -> File_line["$name"]

}
