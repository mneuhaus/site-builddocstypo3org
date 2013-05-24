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
# Create User and directories
######################################

app = node.run_state[:current_app]

if app['owner'] && app['home']

  # Create directory first, sometimes :manage_home=>true from resource "user" does not work
  directory "#{app['home']}" do
    owner "#{app['owner']}"
    group "#{app['owner']}"
    mode "0755"
    recursive true
    action :create
  end

  user "#{app['owner']}" do
    comment "User for docs.typo3.org Virtual Host"
    shell "/bin/bash"
    home "#{app['home']}"
    supports :manage_home=>true
  end

  # Make sure the user is part of www-data group for write permission
  group "www-data" do
    action :modify
    members app['owner']
    append true
  end

  # Add some git default shortcut for convenience sake
  template "#{app['home']}/.gitconfig" do
    path "#{app['home']}/.gitconfig"
    source "gitconfig.erb"
    owner "#{app['owner']}"
    group "#{app['owner']}"
  end

end
