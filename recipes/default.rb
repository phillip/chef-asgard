#
# Cookbook Name:: asgard
# Recipe:: default
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

node.default["tomcat"]["use_security_manager"] = false
node.default["tomcat"]["java_options"] = "-Djava.awt.headless=true  -Xmx768M -XX:MaxPermSize=144m"

node["tomcat"]["base_version"] = "7"

include_recipe "tomcat"

file "/var/lib/tomcat#{node["tomcat"]["base_version"]}/conf/Catalina/localhost/ROOT.xml" do
  action :delete
end

directory "/var/lib/tomcat#{node["tomcat"]["base_version"]}/webapps/ROOT" do
  not_if "test -f /var/lib/tomcat#{node["tomcat"]["base_version"]}/webapps/asgard.war"
  action :delete
  recursive true
end

resources(:template => "/etc/tomcat#{node["tomcat"]["base_version"]}/server.xml").instance_exec do
  cookbook "asgard"
end

directory"/usr/share/tomcat#{node["tomcat"]["base_version"]}/.asgard" do
  mode "0774"
  group "tomcat#{node["tomcat"]["base_version"]}"
  recursive true
end

if node['asgard']['aws_account_names'].kind_of?(Array)
  aws_account_names = Hash[*node['asgard']['aws_account_names']]
else
  aws_account_names = node['asgard']['aws_account_names']
end

template "/usr/share/tomcat#{node["tomcat"]["base_version"]}/.asgard/Config.groovy" do
  source "Config.groovy.erb"
  owner "tomcat#{node["tomcat"]["base_version"]}"
  group "tomcat#{node["tomcat"]["base_version"]}"
  variables( :aws_account_names => aws_account_names)
  notifies :restart, resources(:service => "tomcat")
end

if node['asgard']['src_url'] and node['asgard']['src_url'][0,4] == "http"
  package "unzip"
  
  remote_file "/tmp/asgard.tar.gz" do
    source node['asgard']['src_url'] #"https://github.com/Netflix/asgard/tarball/master"
    owner "root"
    group "root"
  end
  
  grails_version = "1.3.7"
  remote_file "/tmp/grails-#{grails_version}.zip" do
    source "http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/grails-#{grails_version}.zip"
    owner "root"
    group "root"
    not_if "test -d /tmp/grails-#{grails_version}"
  end
  
  bash "install_asgard" do
    user "root"
    not_if "test -f /var/lib/tomcat#{node["tomcat"]["base_version"]}/webapps/asgard.war"
    code <<-EOH
    cd /tmp
    unzip grails-#{grails_version}.zip
    tar -zxf asgard.tar.gz
    mv *-asgard-* asgard
    cd asgard
    /tmp/grails-#{grails_version}/bin/grails war
    mv target/asgard.war /var/lib/tomcat#{node["tomcat"]["base_version"]}/webapps/
    EOH
    notifies :restart, resources(:service => "tomcat")
  end
else
  remote_file "/var/lib/tomcat#{node["tomcat"]["base_version"]}/webapps/asgard.war" do
    source "https://github.com/downloads/Netflix/asgard/asgard.war"
    checksum "66d1ed7c0708c2fb163b95c756561ca55b7c33aa28634f85bdc894676cd48871"
    owner "tomcat#{node["tomcat"]["base_version"]}"
    group "tomcat#{node["tomcat"]["base_version"]}"
    # needs to notify to delete the extracted asgard folder before tomcat restart
    notifies :restart, resources(:service => "tomcat")
  end
end
