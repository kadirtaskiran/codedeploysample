class nesil-jetty-bleep(
  $my_module_name       = "nesil-jetty-bleep",
  $app_environment       = "",
  $home                 = "/opt",
  $jetty_version        = "9.2.7.v20150116",
  $jetty_homedir        = "/opt/jetty-server",
  $jetty_update         = true,
  $warfile_location     = "/opt/warfile",
  $warfile_name         = "",
  $application_xml      = ""
) {

Exec { path => ["/usr/local/bin", "/usr/bin", "/usr/bin", "/bin", "/sbin"] }
package { ["wget"]:
        ensure => installed
    }

class { nesil-jetty-bleep::install :
        home                 =>"${home}",
        jetty_version        =>"${jetty_version}",
        jetty_homedir        =>"${jetty_homedir}",
        jetty_update         =>"${jetty_update}" 
}

class { nesil-jetty-bleep::config:
        my_module_name       =>"${my_module_name}",
        app_environment      =>"${app_environment}",
        home                 =>"${home}",
        jetty_version        =>"${jetty_version}",
        jetty_homedir        =>"${jetty_homedir}",
        warfile_location     =>"${warfile_location}",
        warfile_name         =>"${warfile_name}",
        application_xml      =>"${application_xml}"
  }

include nesil-jetty-bleep::service

}
