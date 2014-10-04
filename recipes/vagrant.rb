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

home = docs_base_directory
deploy_to = docs_deploy_directory
www_group = docs_www_group

# @todo vagrant context: check if that can be configured at the level of the Flow application instead of here
link "#{deploy_to}/current" do
  to "#{deploy_to}/vagrant"
  owner owner
  group www_group
end

# Symlink Configuration so it is available outside the box.
link "#{deploy_to}/vagrant/Configuration/Development/Vagrant" do
  to "#{shared_to}/Configuration/Development"
  owner owner
  group node['apache']['group']
end

# Create some files to apps.
%w{index.php _Resources .htaccess}.each do |file|
  link "#{document_root}/#{file}" do
    to "#{deploy_to}/current/Web/#{file}"
    owner owner
    group www_group
  end
end


