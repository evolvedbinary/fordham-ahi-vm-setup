###
# Puppet Script add a Custom User Account (e.g. for a Student) on Ubuntu 24.04
###

$default_custom_user = 'student'
$custom_user = [$override_custom_user, $default_custom_user][0]
$default_custom_user_password = 'student'
$custom_user_password = [$override_custom_user_password, $default_custom_user_password][0]

group { 'custom_user':
  ensure => present,
  name   => $custom_user,
}

user { 'custom_user':
  ensure     => present,
  name       => $custom_user,
  gid        => $custom_user,
  groups     => [
    'adm',
    'dialout',
    'cdrom',
    'floppy',
    'audio',
    'dip',
    'video',
    'plugdev',
    'lxd',
    'netdev',
  ],
  comment    => "${custom_user} custom user",
  managehome => true,
  shell      => '/usr/bin/zsh',
  password   => pw_hash($custom_user_password, 'SHA-512', 'mysalt'),
  require    => [
    Group['custom_user'],
    Package['zsh'],
  ],
}

file { 'custom_user_home':
  ensure  => directory,
  path    => "/home/${custom_user}",
  replace => false,
  owner   => $custom_user,
  group   => $custom_user,
  mode    => '0700',
  require => User['custom_user'],
}

file { 'custom_user_code_folder':
  ensure  => directory,
  path    => "/home/${custom_user}/code",
  replace => false,
  owner   => $custom_user,
  group   => $custom_user,
  require => [
    User['custom_user'],
    File['custom_user_home'],
  ],
}

exec { 'install-ohmyzsh-custom-user':
  command => 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"',
  path    => '/usr/bin',
  user    => $custom_user,
  require => [
    Package['curl'],
    Package['zsh'],
    Package['git'],
    User['custom_user']
  ],
  creates => "/home/${custom_user}/.oh-my-zsh",
}
