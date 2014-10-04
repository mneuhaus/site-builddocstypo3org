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

# default recipes to make sure git any pip are installed
include_recipe "python"
include_recipe "git"
include_recipe "composer"

######################################
# Create User and directories
######################################

# Application variables
owner = docs_application_owner
home = docs_base_directory
deploy_to = docs_deploy_directory
shared_to = docs_shared_directory
document_root = docs_document_root_directory

# Database
database = node['site-builddocstypo3org']['database']['name']
username = node['site-builddocstypo3org']['database']['username']
password = node['site-builddocstypo3org']['database']['password']

# Create home directory
directory deploy_to do
  owner owner
  group owner
  mode "0755"
  recursive true
  action :create
end

# Fetch the default context
default_context = node['site-builddocstypo3org']['app']['context']

# Write Settings.yaml file for different contexts
contexts = %W[ Production Development ]
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


# Set profile file where global environment variables are defined
# Notice, it can be a bit dangerous to simply override the file which could evolve with the distrib...
# @todo put this at the level of the user.
#template "/etc/profile" do
#  source "profile"
#end



