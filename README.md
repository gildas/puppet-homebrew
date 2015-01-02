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

If you do not have a compiler installed or if the compiler is out-of-date, you will want to load one with the class:

```Puppet
class {'homebrew':
  xcode_cli_source  => 'https://my_repo/commandline_tools_os_x_mavericks_for_xcode__march_2014.dmg',
  xcode_cli_version => '5.1',
}
```
Note: these 2 arguments are now optional. In that case, the installation will assume Xcode is installed properly.

  * Caveat: To download the Xcode command line tools, you must have an Apple ID.

By default, homebrew will be installed as root/wheel, which might not be the desired choice.
To install on behalf of another user, use these parameters:

```Puppet
class {'homebrew':
  user  => gildas,
  group => brew,
}
```

to test if Homebrew was installed, just check the Fact has_homebrew (or has_brew)

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

## Tapping repositories

To tap into new Github repositories, simply use the tap provider:

```puppet
package {'homebrew/binaries':
  ensure   => present,
  provider => tap,
}
```

You can untap a repository by setting ensure to absent.

## Hiera configuration
If you use hiera, the puppet class homebrew will search for an entry called "packages".
All packages inside that hash will get installed by the homebrew class.
Note that packages are merged via the hash method in Hiera. This allows to install common packages on nodes of the same OS, then specific packages on some nodes.

E.g:
```json
{
  "packages": {
    "homebrew/binaries": { "provider": "tap" },
    "vim": {},
    "macvim": {},
    "tree": {},
    "multitail": {}
  }
}
```

## Authors/Contributors

[Gildas Cherruel](https://github.com/gildas) [![endorse](https://api.coderwall.com/gildas/endorsecount.png)](https://coderwall.com/gildas)

[John Eckhart](https://github.com/jeckhart)

[Jasper Lievisse Adriaanse](https://github.com/jasperla)

[Dominic Scheirlinck](https://github.com/dominics)

[Martin Skinner](https://github.com/mask)


## License

Copyright (c) 2014 Gildas CHERRUEL (Apache License, Version 2.0)
