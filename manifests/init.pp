# == Class: addontools
#
# Module to manage addontools
#
class addontools (
  $ensure                   = 'present',
  $common_packages          = [ 'dmidecode', 'smartmontools', 'OpenIPMI' ],
  $packages_ensure          = 'installed',
  $services_ensure          = 'running',
) {

  validate_re($ensure, '^(present|absent)$',
    "addontools::ensure is <${ensure}>. Must be present or absent.")

  case $::virtual {
    'physical': {
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
          }
          package { 'addontools_required_packages':
            ensure => $packages_ensure,
            name   => $common_packages,
          }
          service { 'smartd':
            ensure => $services_ensure,
          }
          service { 'ipmi':
            ensure => $services_ensure,
          }
        }
      }
    }
    'vmware': {
      include vmware
    }
  }
}
