class nesil-jetty-bleep::service{

	  service { "jetty":
           enable     => true,
           ensure     => running,
           hasstatus  => false,
           hasrestart => true,
           require 	  => Class["nesil-jetty-bleep::config"]
  }
}