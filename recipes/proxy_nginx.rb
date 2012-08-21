#
# Cookbook Name:: asgard
# Recipe:: proxy_nginx
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

include_recipe "nginx::source"
include_recipe "asgard"

www_redirect = (node[:asgard][:http_proxy][:www_redirect] == "enable")

htpasswd = (node[:asgard][:http_proxy][:htpasswd] == "enable")

ssl = (node[:asgard][:http_proxy][:ssl] == "enable")

host_name = node[:asgard][:http_proxy][:host_name] || node[:fqdn]

template "#{node[:nginx][:dir]}/sites-available/asgard.conf" do
  source      "nginx_asgard.conf.erb"
  owner       'root'
  group       'root'
  mode        '0644'
  variables(
    :host_name        => host_name,
    :host_aliases     => node[:asgard][:http_proxy][:host_aliases],
    :listen_ports     => node[:asgard][:http_proxy][:listen_ports],
    :www_redirect     => www_redirect,
    :max_upload_size  => node[:asgard][:http_proxy][:client_max_body_size],
    :htpasswd         => htpasswd,
    :ssl              => ssl
  )

  if File.exists?("#{node[:nginx][:dir]}/sites-enabled/asgard.conf")
    notifies  :restart, 'service[nginx]'
  end
end

nginx_site "asgard.conf" do
  if node[:asgard][:http_proxy][:variant] == "nginx"
    enable true
  else
    enable false
  end
end

nginx_site "default" do
  enable false
end

nginx_site "000-default" do
  enable false
end

if htpasswd
  template "#{node.nginx.dir}/htpasswd" do
    variables( :username => node.asgard.http_proxy.basic_auth_username,
               :password => node.asgard.http_proxy.basic_auth_password)
    owner node.nginx.user
    group "nogroup"
    mode 0640
  end
end