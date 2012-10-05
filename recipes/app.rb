#
# Cookbook Name:: site-docs
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

if app['deploy_to'] && app['stages'][app['chef_environment']] && app['revision'][app['chef_environment']]

  # Create directory
  directory app['deploy_to'] do
    owner app['owner']
    group app['owner']
    mode "0755"
    recursive true
    action :create
  end

  # Clone repository
  bash app['id'] do
    user app['owner']
    cwd app['deploy_to']
    code "git clone --recursive #{app['repository']} current"
    not_if { ::File.exists? "#{app['deploy_to']}/current" }
  end

  # Write a small script for convenience sake
  bash "pull-revision" do
    user app['owner']
    cwd app['deploy_to']
    code <<-EOF
  #!/bin/sh
  cd #{app['deploy_to']}/current; git fetch
  if [ "#{app['revision'][app['chef_environment']]}"="HEAD" || "#{app['revision'][app['chef_environment']]}"="" ]; then
    cd #{app['deploy_to']}/current; git checkout #{app['revision'][app['chef_environment']]}
  else
    cd #{app['deploy_to']}/current; git merge origin origin/master
  fi
  cd #{app['deploy_to']}/current; git submodule init
  cd #{app['deploy_to']}/current; git submodule update
    EOF

  end

  # Create symlink
  link "#{app['stages'][app['chef_environment']]['document_root']}" do
    to "#{app['deploy_to']}/current/Web"
  end

  # Write Settings.yaml file
  if app['databases'][app['chef_environment']]
    stage = app['databases'][app['chef_environment']]

    # Make sure context "Development" is always included
    contexts = Array.new
    contexts[0] = app['chef_environment'].capitalize
    if app['chef_environment'] != 'development'
      contexts[1] = 'Development'
    end

    contexts.each do |context|
      template "#{app['deploy_to']}/current/Configuration/#{context}/Settings.yaml" do
        source "settings.yaml.erb"
        owner app['owner']
        group app['owner']
        mode "0644"
        variables(
            :database => stage['database'],
            :user => stage['username'],
            :password => node[:mysql][:users][stage['username']][:password]
        )
      end
    end
  end

  # Write htaccess
  template "#{app['deploy_to']}/current/Web/.htaccess" do
    source "htaccess.erb"
    owner app['owner']
    group app['owner']
    mode "0644"
    variables(
        :context => app['chef_environment'].capitalize
    )
  end

  # Run doctrine update
  #bash "doctrine-update" do
  #  user app['owner']
  #  cwd "#{app['deploy_to']}/current"
  #  code <<-EOF
  ##!/bin/bash
  #FLOW3_CONTEXT=Production ./flow3 doctrine:update
  #  EOF
  #end
end

