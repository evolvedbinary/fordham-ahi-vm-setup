###
# Puppet Script for a Python Developer Environment on Ubuntu 24.04
###

package { 'python3':
  ensure => installed,
}

package { 'python3-pip':
  ensure  => installed,
  require => Package['python3'],
}

exec { 'download-miniconda3':
  command => '/usr/bin/curl -L https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/Miniconda3-latest-Linux-x86_64.sh',
  user    => 'root',
  unless  => '/usr/bin/test -d /opt/miniconda',
  require => Package['curl'],
}

exec { 'install-miniconda3':
  command  => '/tmp/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda',
  user     => 'root',
  provider => 'shell',
  unless   => '/usr/bin/test -d /opt/miniconda',
  require  => Exec['download-miniconda3'],
}
