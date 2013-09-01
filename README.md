# Route module for Puppet

This module manages route on Linux (RedHat/Debian) distros. 

Pluginsync needs to be enabled for this module to function properly.
Read more about pluginsync in our [docs](http://docs.puppetlabs.com/guides/plugins_in_modules.html#enabling-pluginsync)

## Description

This module depends on the [puppetlabs-stdlib](https://github.com/puppetlabs/puppetlabs-stdlib).

## Usage

Add route for network.

    $target_net = ['20.20.20.0/24', '10.20.0.0/16']
    route { $target_net: 
        gateway     => '10.10.10.1',
        target_type => 'net'
    }

Add route for host.

    $target_host = ['10.10.20.11', '10.10.20.21']
    route { $target_host:
        gateway     => '10.10.10.1',
        target_type => 'host'
    }

Delete route for host.

    $target_host_absent = ['10.10.20.51']
    route { $target_host_absent:
        ensure      => absent,
        gateway     => '10.10.10.1',
        target_type => 'host',
    }

Delete route for network.

    $target_net_absent = ['10.20.30.0/16']
    route { $target_net_absent:
        ensure      => absent,
        gateway     => '10.10.10.1',
        target_type => 'net',
    }
