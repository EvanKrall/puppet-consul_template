# == Class: consul_template::install
#
# Installs the consul-template package.
#
class consul_template::install {
  if $consul_template::install_method == 'url' {
    validate_string($consul_template::download_url)
    validate_string($consul_template::bin_dir)
    staging::file { 'consul-template.tar.gz':
      source => $consul_template::download_url
    } ->
    staging::extract { 'consul-template.tar.gz':
      target  => $consul_template::bin_dir,
      strip   => 1,
      creates => "${consul_template::bin_dir}/consul-template",
    } ->
    file { "${consul_template::bin_dir}/consul-template":
      owner => 'root',
      group => 'root',
      mode  => '0555',
    }
  } elsif $consul_template::install_method == 'package' {
    package { 'consul-template':
      ensure => 'present',
    }
  } else {
    fail("The provided install method ${consul_template::install_method} is invalid")
  }
}
