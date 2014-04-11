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

app = node.run_state[:current_app]

# Install python packages
%w{sphinx PyYAML docutils pygments}.each do |package|
  python_pip "#{package}" do
    action :install
  end
end

# Create directory for Sphinx contrib
directory "#{app['home']}/Sphinx-Contrib" do
  owner "#{app['home']}/Sphinx-Contrib"
  group "#{app['group']}"
  mode "0755"
  recursive true
  action :create
end

# Clone Sphinx-Contrib
hg "#{app['home']}/Sphinx-Contrib" do
  repository "https://bitbucket.org/xperseguers/sphinx-contrib"
  reference "tip"
  action :sync
end

# Create directory for Rest Tool
directory "#{app['home']}/RestTools" do
  owner "#{app['owner']}"
  group "#{app['group']}"
  mode "0755"
  recursive true
  action :create
end

# Clone reST tools for TYPO3.
git "#{app['home']}/RestTools" do
  user "#{app['owner']}"
  group "#{app['group']}"
  repository "git://git.typo3.org/Documentation/RestTools.git"
  action :sync
end

# ... install TYPO3 theme (t3sphinx)
bash "install_t3sphinx" do
  user "root"
  cwd "#{app['home']}/RestTools/ExtendingSphinxForTYPO3"
  code <<-EOH
  python setup.py install
  EOH
end

# ... and convert the Share font
bash "convert_sharefont" do
  user "root"
  cwd "#{app['home']}/RestTools/LaTeX/font"
  code <<-EOH
  ./convert-share.sh
  EOH
end
