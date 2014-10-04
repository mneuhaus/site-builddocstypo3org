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

# Add a scheduler job starting the queue
#cron "start-queue" do
#  user owner
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
#    :server_name => server_name
#  )
#end
#
#cron "keep-alive" do
#  minute "*/5"
#  mailto "fabien.udriot@typo3.org"
#  command "sh /root/keep-alive.sh"
#end


