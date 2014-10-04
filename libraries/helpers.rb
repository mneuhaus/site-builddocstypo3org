#
# Author::  Fabien Udriot <fabien.udriot@ecodev.ch>
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

# Can be added via:
# ::Chef::Recipe.send(:include, TYPO3::Docs)

module TYPO3
  module Docs

    # Return the Owner of the application.
    #
    # @return string
    def docs_application_owner
      node['site-builddocstypo3org']['app']['owner']
    end

    # Return the Owner of the application
    #
    # @return string
    def docs_user_home
      owner = docs_application_owner
      "/home/#{owner}"
    end

    # Return the "base" directory.
    #
    # @return string
    def docs_base_directory
      node['site-builddocstypo3org']['app']['home']
    end

    # Return the "deploy" directory.
    #
    # @return string
    def docs_deploy_directory
      base_directory = docs_base_directory
      "#{base_directory}/releases"
    end

    # Return the "shared" directory.
    #
    # @return string
    def docs_shared_directory
      base_directory = docs_base_directory
      "#{base_directory}/shared"
    end

    # Return the "shared" directory.
    #
    # @return string
    def docs_document_root_directory
      base_directory = docs_base_directory
      "#{base_directory}/www"
    end

    # Return the "log" directory.
    #
    # @return string
    def docs_log_directory
      base_directory = docs_base_directory
      "#{base_directory}/log"
    end

    # Return the "www" group.
    #
    # @return string
    def docs_www_group
      node['apache']['group']
    end
  end
end
