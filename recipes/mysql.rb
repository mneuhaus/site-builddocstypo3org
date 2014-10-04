#
# Cookbook Name:: site-builddocstypo3org
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

####################################################
# Install MySQL server and create databases
####################################################
include_recipe "mysql::server"
include_recipe "mysql::client"
include_recipe "database::mysql"

####################################################
# Install required Gems
####################################################

#gem_package "mysql" do
#  action :install
#  # @todo check how the gem path can be less hard-coded...
#  gem_binary "/opt/chef/embedded/bin/gem"
#  options("--no-rdoc --no-ri")
#
#  # I tried this approach:
#  # ruby_home = ::File.expand_path('bin',ruby_prefix_path)
#  # gem_binary "#{ruby_home}/gem"
#end

####################################################
# Create database and user
####################################################

connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}

# "production" should be fetched from the environment
database = node['site-builddocstypo3org']['database']['name']
username = node['site-builddocstypo3org']['database']['username']
hostname = node['site-builddocstypo3org']['database']['hostname']


# Generate a password for user
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless['site-builddocstypo3org']['database']['password'] = secure_password

# Create new database
mysql_database database do
  connection connection_info
  action :create
end

# Create new user
mysql_database_user username do
  connection connection_info
  password node['site-builddocstypo3org']['database']['password']
  database_name database
  host hostname
  privileges [:select,:update,:insert,:create,:alter,:drop,:delete,:index]
  action :grant
end
