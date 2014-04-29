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
# Install system packages
######################################

packages = %w{
	tidy
	acl
	zip
	mercurial
	graphicsmagick
	graphviz

	python
	python-pygments
	python-jinja2
	python-docutils
	python-pip
	python-pygraphviz
	python-mysqldb
	python3-setuptools

	php5-mysql
	php5-curl
	php5-gd
	php5-adodb
	php5-mcrypt
	php5-sqlite
	php5-xsl
	php5-ldap
}.each do |pkg|
    package pkg do
      action :install
    end
end

# Only install LibreOffice is configured so, default is false.
if node['site-docstypo3org']['install']['libreoffice']

  packages = %w{
    libreoffice
  }.each do |pkg|
      package pkg do
        action :install
      end
  end
end

# Only install TextLive is configured so, default is false.
if node['site-docstypo3org']['install']['texlive']

  packages = %w{
    texlive
    texlive-base
    texlive-latex-extra
    texlive-fonts-extra
  }.each do |pkg|
      package pkg do
        action :install
      end
  end
end
