#
# Cookbook Name:: site-docstypo3org
#
# Copyright 2012, TYPO3 Association
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

######################################
# Install Apache
######################################
include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_expires"
include_recipe "apache2::mod_headers"

# Fix warning when restarting apache2
# [warn] NameVirtualHost *:443 has no VirtualHosts]
template "/etc/apache2/ports.conf" do
  source "ports.conf"
end

######################################
# Configure Virtual Host
######################################
owner = node['site-docstypo3org']['app']['owner']
home = node['site-docstypo3org']['app']['home']
server_alias = node['site-docstypo3org']['app']['server_alias']
log_directory = "#{home}/log"
document_root = "#{home}/www"
group = node['apache']['group']

server_name = node['site-docstypo3org']['app']['server_name']

directories = [log_directory, document_root]
directories.each do |directory|
  directory "#{directory}" do
    owner owner
    group group
    mode "0755"
    recursive true
    action :create
  end
end

template "#{server_name}" do
  path "#{node[:apache][:dir]}/sites-available/#{server_name}"
  source "apache2-site-vhost.erb"
  owner node[:apache][:user]
  group node[:apache][:group]
  mode 0644
  variables(
    :log_dir => "#{log_directory}",
    :document_root => "#{document_root}",
    :server_name => "#{server_name}",
    :server_alias => "#{server_alias}"
  )
end

# Enable Virtual Host
apache_site "#{server_name}" do
  enable true
  notifies  :restart, 'service[apache2]'
end

apache_module "speling" do
  enable true
end

