puppet-homebrew
===============


## Description

Homebrew for Mac OS/X package installer and provider for PuppetLabs.

=======

Overview
--------

The Homebrew module provides manifest classes to install Homebrew as well as a package provider to install brews from [homebrew](http://brew.sh).

Setup
-----

Simply load the module via [Puppet Forge](https://forge.puppetlabs.com/gildas/homebrew):

```sh
puppet module install gildas-homebrew
```

Usage
-----

## Installing Homebrew

To install Homebrew, include the main class in your node definition:

Caveat: 

```Puppet
include homebrew
```

Provided you already have a compiler installed!

If you do not have a compiler installed, you will want to load one with the class:

```Puppet
class { 'homebrew':
  xcode_cli_source  => 'https://my_repo/command_line_tools_os_x_mavericks_for_xcode__late_october_2013.dmg',
}
```

  * Caveat: To download the Xcode command line tools, you must have an Apple ID.

By default, homebrew will be installed as root/wheel, which might not be the desired choice.
To install on behalf of another user, use these parameters:

```Puppet
class { 'homebrew':
  user  => gildas,
  group => brew,
}
```

## Installing brews

To install brews, use the package provider as follows:

```puppet
package {'macvim':
  ensure   => installed,
  provider => brew,
  linkapps => true, 
}
```
Setting linkapps to true will run "brew linkapps" once the package is installed.
This is necessary if the installed application should be visible in Finder's Applications. 

brew will run under the user that was used to install it.

Install-time options are given as follows:

```puppet
package {'macvim':
  ensure          => installed,
  provider        => brew,
  linkapps        => true, 
  install_options => [ '--override-system-vim' ],
}
```
## License

Copyright (c) 2014 Gildas CHERRUEL (Apache License, Version 2.0)
