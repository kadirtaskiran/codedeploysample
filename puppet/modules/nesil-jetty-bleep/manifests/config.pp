class nesil-jetty-bleep::config(
  $my_module_name       = "nesil-jetty-bleep",
  $app_environment      = "",
  $home                 = "/opt",
  $jetty_version        = "",
  $jetty_homedir        = "/opt/jetty-server",
  $warfile_location     = "/opt/warfile",
  $warfile_name         = "",
  $application_xml      = ""
) {

  $require = Class["nesil-jetty-bleep::install"]
  
  ##myjetty.sh copy
  file { "${jetty_homedir }/bin/jetty.sh":
          ensure => present,
          content=> template("${my_module_name}/myjetty.sh.erb"),
          owner  => "root",
          group  => "root",
          mode   => 0755,
          notify  => Class["nesil-jetty-bleep::service"]
  } ->

  ##mystart.ini copy
  file { "${jetty_homedir }/start.ini":
          ensure => present,
          content=> template("${my_module_name}/mystart.ini.erb"),
          owner  => "root",
          group  => "root",
          mode   => 0664,
          notify  => Class["nesil-jetty-bleep::service"]
  } ->

  ##my_application.xml copy
  file { "${jetty_homedir }/webapps/${application_xml}":
          ensure => present,
          content=> template("${my_module_name}/myapplication.xml.erb"),
          owner  => "root",
          group  => "root",
          mode   => 0646,
          notify  => Class["nesil-jetty-bleep::service"]
  } ->

  ##jetty-requestlog.xml copy
  file { "${jetty_homedir }/etc/jetty-requestlog.xml":
          ensure => present,
          source => "puppet:///modules/${my_module_name}/requestlog.xml",
          owner  => "root",
          group  => "root",
          mode   => 0664,
          notify  => Class["nesil-jetty-bleep::service"]
  } ->

  ##jetty-logging.xml copy
  file { "${jetty_homedir }/etc/jetty-logging.xml":
          ensure => present,
          source => "puppet:///modules/${my_module_name}/logging.xml",
          owner  => "root",
          group  => "root",
          mode   => 0664,
          notify  => Class["nesil-jetty-bleep::service"]
  } ->

  file { "/opt/resources":
          ensure => directory,
          owner  => "root",
          group  => "root",
          mode   => 0755
  } ->


  
  file { "/etc/init.d/jetty":
          ensure => present,
          content=> template("${my_module_name}/myjetty.sh.erb"),
          owner  => "root",
          group  => "root",
          mode   => 0755
  } ->

    #/opt/tempwarfile directory
  file { "/opt/tempwarfile":
        ensure => directory,
        owner  => "root",
        group  => "root",
        mode   => 0755
  } ->

    file { "remove old war file":
        ensure  => absent,
        path    => "/opt/tempwarfile/${warfile_name}",
        recurse => true,
        purge   => true,
        force   => true
  } ->



  file { "${$warfile_location}":
         ensure => directory,
         owner  => "root",
         group  => "root",
         mode   => 0755,
         notify  => Class["nesil-jetty-bleep::service"]
  } ->

    exec { "warfile download from S3":
        cwd     => "/opt/tempwarfile",
        creates => "/opt/tempwarfile/${warfile_name}",
        command => "wget https://s3-eu-west-1.amazonaws.com/vaider-war/${warfile_name}",
        timeout => 0,
        require => Package['wget']
  } ->


    file { "${$warfile_location}/${warfile_name}":
        ensure  => present,
        source  => "/opt/tempwarfile/${warfile_name}",
        replace => true,
        owner   => "root",
        group   => "root",
        notify  => Class["nesil-jetty-bleep::service"]
  }

  
}