#
# Author:: James Turnbull <james@puppetlabs.com>
# Module Name:: logentries
#
# Copyright 2013, Puppet Labs
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class nesil-logentries(
                        $my_module_name = 'nesil-logentries',
                        $token_key      = '',
                        $log_file_path  = '',
                        $log_file_tag   = ''


) {



  ##rsyslog.conf 
  file { "/etc/rsyslog.conf":
          ensure => present,
          content=> template("${my_module_name}/rsyslog.conf.erb"),
          owner  => "root",
          group  => "root",
          notify => Service["rsyslog"]
  } 

  service { 'rsyslog':
  ensure     => running,
  enable     => true,
  hasrestart => true,
  hasstatus  => false

  } 


}
