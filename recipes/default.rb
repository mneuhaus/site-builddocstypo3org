#
# Cookbook Name:: site-builddocstypo3org
# Recipe:: default
#
# Copyright 2012, TYPO3 Association
#
# Licensed under the Apache License, Version 2.0 (the"site-builddocstypo3org::License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an"site-builddocstypo3org::AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Include Helper function
::Chef::Recipe.send(:include, TYPO3::Docs)

# Must be included in order to have the recipe succeeding at the first run.
include_recipe "apt"

# Continue provisioning...
include_recipe "site-builddocstypo3org::packages"

# Only install TextLive is configured so, default is "true" to be production ready.
if node['site-builddocstypo3org']['install']['texlive']
  include_recipe "site-builddocstypo3org::packages_textlive"
end

# Continue the deployment of the application...
include_recipe "site-builddocstypo3org::user"
include_recipe "site-builddocstypo3org::mysql"
include_recipe "site-builddocstypo3org::php5"

include_recipe "site-builddocstypo3org::apache2"
include_recipe "site-builddocstypo3org::app"
include_recipe "site-builddocstypo3org::restructuredtext"

# Only install LibreOffice if configured so, default is "true" to be production ready.
if node['site-builddocstypo3org']['install']['libreoffice']
  include_recipe "site-builddocstypo3org::libreoffice"
end
