#
# Cookbook Name:: site-docstypo3org
# Recipe:: default
#
# Copyright 2012, TYPO3 Association
#
# Licensed under the Apache License, Version 2.0 (the"site-docstypo3org::License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an"site-docstypo3org::AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Include Helper function
::Chef::Recipe.send(:include, TYPO3::Docs)

# Must be included in order to have the recipe succeeding at the first run.
include_recipe "apt"

# Continue provisioning...
include_recipe "site-docstypo3org::packages"
include_recipe "site-docstypo3org::user"
include_recipe "site-docstypo3org::mysql"
include_recipe "site-docstypo3org::php5"

include_recipe "site-docstypo3org::apache2"
include_recipe "site-docstypo3org::app"
include_recipe "site-docstypo3org::restructuredtext"
include_recipe "site-docstypo3org::libreoffice"
