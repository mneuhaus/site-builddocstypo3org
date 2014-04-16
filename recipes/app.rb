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

if app['deploy_to'] && app['stages'][app['chef_environment']] && app['revision'][app['chef_environment']]

  stage = app['stages'][app['chef_environment']]
  database = app['databases'][app['chef_environment']]

  # Create home directory
  directory app['deploy_to'] do
    owner app['owner']
    group app['owner']
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
    directory "#{app['shared_to']}/Configuration/#{context}" do
      owner app['owner']
      group app['owner']
      mode "0755"
      recursive true
      action :create
    end

    template "#{app['shared_to']}/Configuration/#{context}/Settings.yaml" do
      source "settings.yaml.erb"
      owner app['owner']
      group app['owner']
      mode "0644"
      variables(
        :database => database['database'],
        :user => database['username'],
        :password => node[:mysql][:users][database['username']][:password]
      )
    end
  end

  # @todo vagrant context: check if that can be configured at the level of the Flow application instead of here
  if Chef::Config['solo']
    link "#{app['deploy_to']}/current" do
      to "#{app['deploy_to']}/vagrant"
      owner app['owner']
      group app['group']
    end

    # Symlink Configuration so it is available outside the box.
#     link "#{app['deploy_to']}/vagrant/Configuration/Development/Vagrant" do
#       to "#{app['shared_to']}/Configuration/Development"
#       owner app['owner']
#       group app['group']
#     end
  end

  # Create some sysmlinks to apps.
  %w{index.php _Resources .htaccess}.each do |file|
    link "#{stage['document_root']}/#{file}" do
      to "#{app['deploy_to']}/current/Web/#{file}"
      owner app['owner']
      group app['group']
    end
  end

  # Add a scheduler job starting the queue
  # However, it must not be set for in Vagrant context
  unless Chef::Config['solo']
    #cron "start-queue" do
    #  user app['owner']
    #  minute "*/5"
    #  mailto "fabien.udriot@typo3.org"
    #  command "cd #{app['release_to']}; FLOW_CONTEXT=Production ./flow queue:start"
    #end
    #
    #template "/root/keep-alive.sh" do
    #  source "keep-alive.sh"
    #  mode "0755"
    #  variables(
    #    :release_to => app['release_to'],
    #    :server_name => app['stages'][app['chef_environment']]['server_name']
    #  )
    #end
    #
    #cron "keep-alive" do
    #  minute "*/5"
    #  mailto "fabien.udriot@typo3.org"
    #  command "sh /root/keep-alive.sh"
    #end
  end
end


# Set profile file where global environment variables are defined
# Notice, it can be a bit dangerous to simply override the file which could evolve with the distrib...
template "/etc/profile" do
  source "profile"
end



