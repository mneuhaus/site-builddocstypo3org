#
# Cookbook Name:: site-docs
# Recipe:: default
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

search(:apps, 'id:docs-typo3-org') do |app|
  # condition "& node.run_list.roles" was removed
  (app["roles"]).each do |app_role, role|
    role.each do |recipe|

      # Hack for chef-solo which does not support environment
      if Chef::Config['solo']
        app['chef_environment']= "production"
      else
        app['chef_environment'] = node.chef_environment
      end

      # Store app to the node
      node.run_state[:current_app] = app
      include_recipe "site-docs::#{recipe}"
    end
  end
end

node.run_state.delete(:current_app)
