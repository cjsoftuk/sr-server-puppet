class www::ide ( $git_root, $root_dir ) {
  package { ['pylint', 'php-cli', 'java-1.7.0-openjdk', 'ant']:
    ensure => present,
    before => Vcsrepo["${root_dir}"],
  }

  # NB: the applet is deliberately unconfigured because everyone I speak to
  # doesn't want it to exist any more.
  vcsrepo { "${root_dir}":
    ensure => present,
    provider => git,
    source => "${git_root}/cyanide.git",
    revision => "master",
    force => true,
    owner => 'wwwcontent',
    group => 'apache',
    require => Class['srweb'],
  }

  file { "${root_dir}/config/ide-key.key":
    ensure => present,
    owner => 'wwwcontent',
    group => 'apache',
    mode => '640',
    content => extlookup('ide_cookie_key'),
    require => Vcsrepo["${root_dir}"],
  }

  $ide_key_file = "${root_dir}/config/ide-key.key"
  $ide_ldap_pw = extlookup('ide_ldap_user_pw')
  file { "${root_dir}/config/local.ini":
    ensure => present,
    owner => 'wwwcontent',
    group => 'apache',
    mode => '640',
    content => template('www/ide_config.ini.erb'),
    require => Vcsrepo["${root_dir}"],
  }

  $ide_user = extlookup('ide_ldap_user_uid')
  ldapres { "uid=${ide_user},ou=users,o=sr":
    ensure => present,
    uid => $ide_user,
    cn => "IDE account",
    sn => "IDE account",
    uidnumber => 2321,
    gidnumber => 1999, # srusers
    homedirectory => '/home/ide',
    userpassword => extlookup('ide_ldap_user_ssha_pw'),
  }
}
