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

####################################################
# Install MySQL server and create databases
####################################################
include_recipe "mysql::server"
include_recipe "mysql::client"
include_recipe "database"

####################################################
# Install required Gems
####################################################
include_recipe "build-essential"
#chef_gem "mysql" do
#  action :install
#end

####################################################
# Create database and user
####################################################

connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}

app = node.run_state[:current_app]


# "production" should be fetched from the environment

if app['databases'][app['chef_environment']]

  stage = app['databases'][app['chef_environment']]

  # Generate a password for user
  ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
  node.set_unless[:mysql][:users][stage['username']][:password] = secure_password

  # Create new database
  mysql_database "#{stage['database']}" do
    connection connection_info
    action :create
  end

  # Create new user
  mysql_database_user stage['username'] do
    connection connection_info
    password node[:mysql][:users][stage['username']][:password]
    database_name stage['database']
    host stage['host']
    privileges [:select,:update,:insert,:create,:alter,:drop,:delete]
    action :grant
  end

end
