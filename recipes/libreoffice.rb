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

# Install packages at first
%w{
  libreoffice
}.each do |pkg|
  package pkg do
    action :install
  end
end

# Create the daemon init starter
owner = docs_application_owner

# Install LibreOffice daemon
template "/etc/init.d/libreoffice" do
  path "/etc/init.d/libreoffice"
  source "libreoffice.erb"
  owner "root"
  group "root"
  mode 0755
  variables(
    :user => owner
  )
  notifies :restart, "service[libreoffice]"
end

service "libreoffice" do
  start_command "/etc/init.d/libreoffice start"
  stop_command "/etc/init.d/libreoffice stop"
  restart_command "/etc/init.d/libreoffice stop; /etc/init.d/libreoffice start"
  supports [:start, :stop, :restart]
  #starts the service if it's not running and enables it to start at system boot time
  action [:enable, :start]
end

