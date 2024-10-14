###
# Puppet Script to build and install Guacamole Client on Ubuntu 24.04
###

$guacamole_client_source_folder = "/home/${default_user}/code/guacamole-client"

$default_custom_user = 'student'
$custom_user = [$override_custom_user, $default_custom_user][0]
$default_custom_user_password = 'student'
$custom_user_password = [$override_custom_user_password, $default_custom_user_password][0]

file { 'guacamole-client-source-folder':
  ensure  => directory,
  path    => $guacamole_client_source_folder,
  replace => false,
  owner   => $default_user,
  group   => $default_user,
  require => File['default_user_code_folder'],
}

vcsrepo { 'guacamole-client-source':
  ensure             => latest,
  path               => $guacamole_client_source_folder,
  provider           => git,
  source             => 'https://github.com/apache/guacamole-client.git',
  revision           => 'master',
  keep_local_changes => false,  # TODO(AR) change this to 'true' once https://github.com/puppetlabs/puppetlabs-vcsrepo/pull/623 is merged and released
  owner              => $default_user,
  group              => $default_user,
  require            => [
    Package['git'],
    File['guacamole-client-source-folder'],
  ],
}

exec { 'guacamole-client-compile':
  cwd      => $guacamole_client_source_folder,
  command  => '/opt/maven/bin/mvn package',
  provider => shell,
  user     => $default_user,
  creates  => "${guacamole_client_source_folder}/target",
  require  => [
    Vcsrepo['guacamole-client-source'],
    Package['openjdk-17-jdk-headless'],
    File['/opt/maven'],
  ],
}

file { '/etc/guacamole':
  ensure  => directory,
  replace => false,
  owner   => 'root',
  group   => 'root',
  mode    => '0755',
}

file { '/etc/guacamole/lib':
  ensure  => directory,
  replace => false,
  owner   => 'root',
  group   => 'root',
  mode    => '0755',
  require => File['/etc/guacamole'],
}

file { '/etc/guacamole/extensions':
  ensure  => directory,
  replace => false,
  owner   => 'root',
  group   => 'root',
  mode    => '0755',
  require => File['/etc/guacamole'],
}

$guacamole_properties = @("GUACAMOLE_PROPERTIES_EOF"/L)
  allowed-languages: en
  guacd-hostname: localhost
  guacd-port: 4822
  | GUACAMOLE_PROPERTIES_EOF

file { '/etc/guacamole/guacamole.properties':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0744',
  content => $guacamole_properties,
  require => File['/etc/guacamole'],
}

$user_mapping = @("USER_MAPPING_EOF":xml/L)
  <user-mapping>
      <authorize username="${custom_user}@fordham.edu" password="${custom_user_password}">
          <connection name="fordham-ahi-01">
              <protocol>rdp</protocol>
              <param name="hostname">fordham-ahi-01.evolvedbinary.com</param>
              <param name="port">3389</param>
              <param name="username">${custom_user}</param>
              <param name="password">${custom_user_password}</param>
              <param name="enable-touch">false</param>
              <param name="resize-method">display-update</param>
              <param name="disable-audio">true</param>
              <param name="enable-printing">true</param>
              <param name="printer-name">guacamole-client</param>
              <param name="enable-drive">true</param>
              <param name="drive-name">guacamole</param>
              <param name="drive-path">/guacamole-drive</param>
          </connection>
      </authorize>
      <authorize username="${custom_user}@fordham.edu" password="${custom_user_password}">
          <connection name="fordham-ahi-02">
              <protocol>rdp</protocol>
              <param name="hostname">fordham-ahi-02.evolvedbinary.com</param>
              <param name="port">3389</param>
              <param name="username">${custom_user}</param>
              <param name="password">${custom_user_password}</param>
              <param name="enable-touch">false</param>
              <param name="resize-method">display-update</param>
              <param name="disable-audio">true</param>
              <param name="enable-printing">true</param>
              <param name="printer-name">guacamole-client</param>
              <param name="enable-drive">true</param>
              <param name="drive-name">guacamole</param>
              <param name="drive-path">/guacamole-drive</param>
          </connection>
      </authorize>
      <authorize username="${custom_user}@fordham.edu" password="${custom_user_password}">
          <connection name="fordham-ahi-03">
              <protocol>rdp</protocol>
              <param name="hostname">fordham-ahi-03.evolvedbinary.com</param>
              <param name="port">3389</param>
              <param name="username">${custom_user}</param>
              <param name="password">${custom_user_password}</param>
              <param name="enable-touch">false</param>
              <param name="resize-method">display-update</param>
              <param name="disable-audio">true</param>
              <param name="enable-printing">true</param>
              <param name="printer-name">guacamole-client</param>
              <param name="enable-drive">true</param>
              <param name="drive-name">guacamole</param>
              <param name="drive-path">/guacamole-drive</param>
          </connection>
      </authorize>
      <authorize username="${custom_user}@fordham.edu" password="${custom_user_password}">
          <connection name="fordham-ahi-04">
              <protocol>rdp</protocol>
              <param name="hostname">fordham-ahi-04.evolvedbinary.com</param>
              <param name="port">3389</param>
              <param name="username">${custom_user}</param>
              <param name="password">${custom_user_password}</param>
              <param name="enable-touch">false</param>
              <param name="resize-method">display-update</param>
              <param name="disable-audio">true</param>
              <param name="enable-printing">true</param>
              <param name="printer-name">guacamole-client</param>
              <param name="enable-drive">true</param>
              <param name="drive-name">guacamole</param>
              <param name="drive-path">/guacamole-drive</param>
          </connection>
      </authorize>
      <authorize username="${custom_user}@fordham.edu" password="${custom_user_password}">
          <connection name="fordham-ahi-05">
              <protocol>rdp</protocol>
              <param name="hostname">fordham-ahi-05.evolvedbinary.com</param>
              <param name="port">3389</param>
              <param name="username">${custom_user}</param>
              <param name="password">${custom_user_password}</param>
              <param name="enable-touch">false</param>
              <param name="resize-method">display-update</param>
              <param name="disable-audio">true</param>
              <param name="enable-printing">true</param>
              <param name="printer-name">guacamole-client</param>
              <param name="enable-drive">true</param>
              <param name="drive-name">guacamole</param>
              <param name="drive-path">/guacamole-drive</param>
          </connection>
      </authorize>
      <authorize username="${custom_user}@fordham.edu" password="${custom_user_password}">
          <connection name="fordham-ahi-06">
              <protocol>rdp</protocol>
              <param name="hostname">fordham-ahi-06.evolvedbinary.com</param>
              <param name="port">3389</param>
              <param name="username">${custom_user}</param>
              <param name="password">${custom_user_password}</param>
              <param name="enable-touch">false</param>
              <param name="resize-method">display-update</param>
              <param name="disable-audio">true</param>
              <param name="enable-printing">true</param>
              <param name="printer-name">guacamole-client</param>
              <param name="enable-drive">true</param>
              <param name="drive-name">guacamole</param>
              <param name="drive-path">/guacamole-drive</param>
          </connection>
        </authorize>
        <authorize username="${custom_user}@fordham.edu" password="${custom_user_password}">
          <connection name="fordham-ahi-07">
              <protocol>rdp</protocol>
              <param name="hostname">fordham-ahi-07.evolvedbinary.com</param>
              <param name="port">3389</param>
              <param name="username">${custom_user}</param>
              <param name="password">${custom_user_password}</param>
              <param name="enable-touch">false</param>
              <param name="resize-method">display-update</param>
              <param name="disable-audio">true</param>
              <param name="enable-printing">true</param>
              <param name="printer-name">guacamole-client</param>
              <param name="enable-drive">true</param>
              <param name="drive-name">guacamole</param>
              <param name="drive-path">/guacamole-drive</param>
          </connection>
        </authorize>
        <authorize username="${custom_user}@fordham.edu" password="${custom_user_password}">
          <connection name="fordham-ahi-08">
              <protocol>rdp</protocol>
              <param name="hostname">fordham-ahi-08.evolvedbinary.com</param>
              <param name="port">3389</param>
              <param name="username">${custom_user}</param>
              <param name="password">${custom_user_password}</param>
              <param name="enable-touch">false</param>
              <param name="resize-method">display-update</param>
              <param name="disable-audio">true</param>
              <param name="enable-printing">true</param>
              <param name="printer-name">guacamole-client</param>
              <param name="enable-drive">true</param>
              <param name="drive-name">guacamole</param>
              <param name="drive-path">/guacamole-drive</param>
          </connection>
      </authorize>
      <authorize username="${custom_user}@fordham.edu" password="${custom_user_password}">
          <connection name="fordham-ahi-09">
              <protocol>rdp</protocol>
              <param name="hostname">fordham-ahi-09.evolvedbinary.com</param>
              <param name="port">3389</param>
              <param name="username">${custom_user}</param>
              <param name="password">${custom_user_password}</param>
              <param name="enable-touch">false</param>
              <param name="resize-method">display-update</param>
              <param name="disable-audio">true</param>
              <param name="enable-printing">true</param>
              <param name="printer-name">guacamole-client</param>
              <param name="enable-drive">true</param>
              <param name="drive-name">guacamole</param>
              <param name="drive-path">/guacamole-drive</param>
          </connection>
      </authorize>
      <authorize username="${custom_user}@fordham.edu" password="${custom_user_password}">
          <connection name="fordham-ahi-10">
              <protocol>rdp</protocol>
              <param name="hostname">fordham-ahi-10.evolvedbinary.com</param>
              <param name="port">3389</param>
              <param name="username">${custom_user}</param>
              <param name="password">${custom_user_password}</param>
              <param name="enable-touch">false</param>
              <param name="resize-method">display-update</param>
              <param name="disable-audio">true</param>
              <param name="enable-printing">true</param>
              <param name="printer-name">guacamole-client</param>
              <param name="enable-drive">true</param>
              <param name="drive-name">guacamole</param>
              <param name="drive-path">/guacamole-drive</param>
          </connection>
      </authorize>
  </user-mapping>
  | USER_MAPPING_EOF

file { '/etc/guacamole/user-mapping.xml':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0744',
  content => $user_mapping,
  require => File['/etc/guacamole'],
}

$tomcat_packages = ['tomcat9', 'tomcat9-admin', 'tomcat9-user']
package { $tomcat_packages:
  ensure  => installed,
  require => Package['openjdk-17-jdk-headless'],
}

file { 'guacamole-war':
  ensure  => file,
  path    => '/var/lib/tomcat9/webapps/guacamole.war',
  source  => "${guacamole_client_source_folder}/guacamole/target/guacamole-1.5.5.war",
  require => [
    File['/etc/guacamole/guacamole.properties'],
    File['/etc/guacamole/user-mapping.xml'],
    File['/etc/guacamole/lib'],
    File['/etc/guacamole/extensions'],
    Exec['guacamole-client-compile'],
    Package['tomcat9'],
  ],
}

service { 'tomcat9':
  ensure  => running,
  enable  => true,
  require => [
    File['guacamole-war'],
    Package['tomcat9'],
  ],
}
