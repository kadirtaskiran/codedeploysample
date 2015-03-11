stage { 'first': before => Stage['main'],}
stage { 'last': }
Stage['main'] -> Stage['last']
if versioncmp($::puppetversion,'3.6.1') >= 0 { $allow_virtual_packages = hiera('allow_virtual_packages',false) Package { allow_virtual => $allow_virtual_packages, }}




  class { 'java':
          stage => first
        } 
  class { 'nesil-jetty-bleep' :
          stage                   => main,
          jetty_version           => "9.2.7.v20150116",
          jetty_update            => true,
          application_xml         => "vaider.xml",
          warfile_name            => "vaider.war",
          app_environment 		  => "test"
 }






