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
  cd #{app['deploy_to']}/current; git checkout #{app['revision'][app['chef_environment']]}
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


  # Add cron task to start the queue
  bash "post-installation" do
    user 'root'
    cwd app['release_to']
    code <<-EOF
#!/bin/sh

# Usage: ./flow3 core:setfilepermissions <commandlineuser> <webuser> <webgroup>

FLOW3_CONTEXT=Production ./flow3 flow3:core:setfilepermissions builddocstypo3org www-data www-data
FLOW3_CONTEXT=Production ./flow3 doctrine:update

cd #{app['release_to']}/Packages/Application/RestTools; git config core.filemode false
cd #{app['release_to']}/Packages/Application/TYPO3.Docs; git config core.filemode false

    EOF

  end

  # Add a scheduler job starting the queue
  # However, it must not be set for in Vagrant context
  unless Chef::Config['solo']
    cron "start-queue" do
      user app['owner']
      minute "*/5"
      command "cd #{app['release_to']}; FLOW3_CONTEXT=Production ./flow3 queue:start"
    end

    template "/root/keep-alive.sh" do
      source "keep-alive.sh"
      mode "0755"
      variables(
          :release_to => app['release_to'],
          :server_name => app['stages'][app['chef_environment']]['server_name']
      )
    end

    cron "keep-alive" do
      minute "*/5"
      command "sh /root/keep-alive.sh"
    end
  end

end



