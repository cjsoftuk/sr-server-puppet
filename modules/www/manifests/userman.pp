# Initial config attempt for nemesis/userman, superceded by nemesis.pp

class www::userman ( $root_dir, $git_root ) {
  package { ['python-flask', 'python-ldap']:
    ensure => present,
  }

  vcsrepo { "${root_dir}":
    ensure => present,
    user => 'wwwcontent',
    provider => git,
    source => "${git_root}/userman.git",
    force => true,
  }
}
