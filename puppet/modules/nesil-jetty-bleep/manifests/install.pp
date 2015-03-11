class nesil-jetty-bleep::install(
  $home                 = "/opt",
  $jetty_version        = "",
  $jetty_homedir        = "/opt/jetty-server",
  $jetty_update         = true
) {
  
  if $jetty_update {
      wget::fetch { "jetty_download":
        source      => "http://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${jetty_version}/jetty-distribution-${jetty_version}.tar.gz",
        destination => "/usr/local/src/jetty-distribution-${jetty_version}.tar.gz",
      } ->

      exec { "jetty_untar":
        command => "tar xf /usr/local/src/jetty-distribution-${jetty_version}.tar.gz && chown -R root:root ${home}/jetty-distribution-${jetty_version}",
        cwd     => $home,
        creates => "${home}/jetty-distribution-${jetty_version}"
      } ->

      file { "${jetty_homedir}":
          ensure  => directory,
          source  => "${home}/jetty-distribution-${jetty_version}",
          recurse => true,
          owner   => "root",
          group   => "root",
          mode    => 0644
      } ->

      file {"remove jetty-distribution-${jetty_version} dir":
        ensure  => absent,
        path    => "${home}/jetty-distribution-${jetty_version}",
        recurse => true,
        purge   => true,
        force   => true,
        notify   => Class["nesil-jetty-bleep::config"],
      } 
    }
}