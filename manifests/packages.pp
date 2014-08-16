# == Class: homebrew::packages
#
# Install brew packages configured in hiera
#
# === Hiera configuration
#
#
# If you use hiera, the puppet class homebrew will search for an entry called "packages".
# All packages inside that hash will get installed by the homebrew class.
# Note that packages are merged via the hash method in Hiera. This allows to install common packages on nodes of the same OS, then specific packages on some nodes.
#
# === Examples
#
# {
#   "packages": {
#     "vim": {},
#     "macvim": {},
#     "tree": {},
#     "multitail": {}
#   }
# }
#
# === Authors
#
# Author Name <gildas@breizh.org>
#
# === Copyright
#
# Copyright 2014, Gildas CHERRUEL.
#

class homebrew::packages {
  # Installs brews from hiera
  $packages = hiera_hash('packages', {})
  if (!empty($packages))
  {
    notice(" Checking packages: ${packages}")
    $package_defaults = {
      ensure   => latest,
      provider => brew,
      require  => Exec['install-homebrew'],
    }
    create_resources(package, $packages, $package_defaults)
  }

}
