###
# Puppet Script for MySQL Workbench on Ubuntu 22.04
###

$mysql_workbench_community_version = '8.0.38-1ubuntu24.04_amd64'

exec { 'download-mysql-workbench-community-deb':
  command => "/usr/bin/curl -L https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community_${mysql_workbench_community_version}.deb -o /tmp/mysql-workbench-community_${mysql_workbench_community_version}.deb",
  unless  => '/usr/bin/dpkg -s mysql-workbench-community',
  require => Package['curl'],
}

package { 'mysql-workbench-community':
  ensure  => installed,
  source  => "/tmp/mysql-workbench-community_${mysql_workbench_community_version}.deb",
  require => [
    Package['desktop'],
    Exec['download-mysql-workbench-community-deb'],
  ],
}

# Add Desktop shortcut
file { 'mysql-workbench-community-shortcut':
  ensure  => file,
  path    => "/home/${default_user}/Desktop/mysql-workbench.desktop",
  source  => '/usr/share/applications/mysql-workbench.desktop',
  owner   => $default_user,
  group   => $default_user,
  mode    => '0644',
  require => [
    Package['desktop'],
    File['default_user_desktop_folder'],
    Package['mysql-workbench-community'],
  ],
}

exec { 'gvfs-trust-mysql-workbench-community-shortcut':
  command     => "/usr/bin/gio set /home/${default_user}/Desktop/mysql-workbench.desktop metadata::trusted true",
  unless      => "/usr/bin/gio info --attributes=metadata::trusted /home/${default_user}/Desktop/mysql-workbench.desktop | /usr/bin/grep trusted",
  user        => $default_user,
  environment => [
    'DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus',
  ],
  require     => File['mysql-workbench-community-shortcut'],
}

ini_setting { 'mysql-workbench-community-shortcut-position':
  ensure  => present,
  path    => "/home/${default_user}/.config/pcmanfm-qt/lxqt/desktop-items-0.conf",
  section => 'mysql-workbench.desktop',
  setting => 'pos',
  value   => '@Point(266 138)',
  require => [
    File['desktop-items-0'],
    File['mysql-workbench-community-shortcut'],
  ],
}