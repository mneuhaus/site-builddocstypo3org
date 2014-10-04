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

# default recipes to make sure git any pip are installed
include_recipe "python"
include_recipe "git"
include_recipe "composer"

######################################
# Create User and directories
######################################



# Application variables
owner = node['site-docstypo3org']['app']['owner']
home = node['site-docstypo3org']['app']['home']
deploy_to = "#{home}/releases"
shared_to = "#{home}/shared"
document_root = "#{home}/www"


# Database
database = node['site-docstypo3org']['database']['name']
username = node['site-docstypo3org']['database']['username']
password = node['site-docstypo3org']['database']['password']


#database = app['databases'][app['chef_environment']]

# Create home directory
directory deploy_to do
  owner owner
  group owner
  mode "0755"
  recursive true
  action :create
end

# Make sure context "Development" is always included
contexts = Array.new
contexts[0] = app['chef_environment'].capitalize
if app['chef_environment'] != 'development'
  contexts[1] = 'Development'
end

# Write Settings.yaml file for different contexts
contexts.each do |context|

  # Create shared configuration
  %W[ / /Configuration /Configuration/#{context} ].each do |path|
    directory "#{shared_to}#{path}" do
      owner owner
      group owner
      mode "0755"
      #recursive true
      action :create
    end
  end

  template "#{shared_to}/Configuration/#{context}/Settings.yaml" do
    source "settings.yaml.erb"
    owner owner
    group owner
    mode "0644"
    variables(
      :database => database,
      :user => username,
      :password => password
    )
  end
end


# @todo vagrant context: check if that can be configured at the level of the Flow application instead of here
if Chef::Config['solo']
  link "#{deploy_to}/current" do
    to "#{deploy_to}/vagrant"
    owner owner
    group node['apache']['group']
  end

  # Symlink Configuration so it is available outside the box.
  #     link "#{deploy_to}/vagrant/Configuration/Development/Vagrant" do
  #       to "#{shared_to}/Configuration/Development"
  #       owner owner
  #       group node['apache']['group']
  #     end
end

# Create some sysmlinks to apps.
%w{index.php _Resources .htaccess}.each do |file|
  link "#{document_root}/#{file}" do
    to "#{deploy_to}/current/Web/#{file}"
    owner owner
    group node['apache']['group']
  end
end

# Set profile file where global environment variables are defined
# Notice, it can be a bit dangerous to simply override the file which could evolve with the distrib...
# @todo put this at the level of the user.
#template "/etc/profile" do
#  source "profile"
#end



