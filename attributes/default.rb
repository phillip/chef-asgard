#
# Cookbook Name:: asgard
# Attributes:: default
#
# Copyright 2012, Phillip Goldenburg
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

default['asgard']['port'] = '8080'

default['asgrad']['grails_version'] = "2.1.1"
#grails
default['asgard']['aws_accounts'] = [] # ["12345", "67890"]
default['asgard']['aws_account_names'] = {} # {"12345"=>"prod","67890"=>"test"}

#secret
default['asgard']['access_id'] = ""
default['asgard']['secret_key'] = ""

#cloud
default['asgard']['account_name'] = ""
default['asgard']['public_resource_accounts'] = []

default['asgard']['src_url'] = nil

default['asgard']['eureka']['active'] = false
default['asgard']['eureka']['regions_to_servers'] = { 'US_EAST_1' => 'eureka.us-east-1.mydomain.com' }
default['asgard']['eureka']['port'] = 80


default[:asgard][:http_proxy][:variant]              = nil
default[:asgard][:http_proxy][:www_redirect]         = "disable"
default[:asgard][:http_proxy][:listen_ports]         = [ 80 ]
default[:asgard][:http_proxy][:host_name]            = nil
default[:asgard][:http_proxy][:host_aliases]         = []
default[:asgard][:http_proxy][:client_max_body_size] = "1024m"


default[:asgard][:http_proxy][:htpasswd] = "disable"
default[:asgard][:http_proxy][:basic_auth_username] = "asgard"
default[:asgard][:http_proxy][:basic_auth_password] = "asgard"

default[:asgard][:http_proxy][:ssl] = false
default[:asgard][:http_proxy][:ssl_certificate_file] = ""
default[:asgard][:http_proxy][:ssl_certificate_key_file] = ""
