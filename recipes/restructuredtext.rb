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


# More stuff to configure probably targeting Latex
# --------------------------------------------------
#
# Latex:
# http://wiki.typo3.org/Rendering_reST_on_Linux#Installing_LaTeX

# Install TYPO3 theme (t3sphinx)
bash "install_t3sphinx" do
  user "root"
  cwd "#{app['deploy_to']}/current/Packages/Application/RestTools/ExtendingSphinxForTYPO3"
  code <<-EOH
  python setup.py install
  EOH
end

