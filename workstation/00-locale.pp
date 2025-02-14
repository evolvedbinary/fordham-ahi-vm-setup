###
# Puppet Script for setting locale on Ubuntu 24.04
###

# Set the language
exec { 'generate-us-language':
  command => '/usr/sbin/locale-gen en_US.utf8',
  user    => 'root',
  unless  => '/usr/bin/localectl list-locales | /usr/bin/grep en_US.utf8',
}

exec { 'set-language':
  command => '/usr/sbin/update-locale LANG=en_US.utf8',
  user    => 'root',
  unless  => '/usr/bin/locale | /usr/bin/grep LANG=en_US.utf8',
  require => Exec['generate-us-language'],
}

file { '/etc/default/keyboard':
  ensure  => file,
  replace => false,
  owner   => 'root',
  group   => 'root',
  mode    => '0744',
}

# Set the keyboard layout
file_line { 'keyboard-layout':
  ensure => present,
  path   => '/etc/default/keyboard',
  line   => 'XKBLAYOUT="us"',
  match  => '^XKBLAYOUT\=',
}

# Set the time zone
exec { 'set-timezone':
  command => 'timedatectl set-timezone America/New_York',
  path    => '/usr/bin',
  user    => 'root',
  unless  => 'cat /etc/timezone | grep America/New_York',
}
