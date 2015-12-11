# == Class: addontools
#
# Module to manage addontools
#
class addontools (
  $ensure                   = 'present',
  $packages_ensure          = 'installed',
  $services_ensure          = 'running',
) {

  validate_re($ensure, '^(present|absent)$',
    "addontools::ensure is <${ensure}>. Must be present or absent.")

  if $::virtual == 'physical' {
    case $::osfamily {
      'RedHat': {
        case $::lsbmajdistrelease {
          '5': {
            package { 'OpenIPMI-tools':
              ensure  => $packages_ensure,
            }
          }
          '6','7': {
            package { 'ipmitool':
              ensure => $packages_ensure,
            }
          }
          default: {
            fail("Unsupported RHEL version ${::lsbmajdistrelease}")
          }
          package { 'addontools_required_packages':
            ensure => $packages_ensure,
            name   => [ 'dmidecode', 'smartmontools', OpenIPMI' ],
          }
          service { 'addontools_required_services':
            ensure => $services_ensure,
            name   => [ 'smartd', 'ipmi' ]
          }
        }
      }
    }
    default: {
    }
  }
}
