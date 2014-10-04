#
# Cookbook Name:: site-builddocstypo3org
# Attributes:: default

default['site-builddocstypo3org']['install']['libreoffice'] = true
default['site-builddocstypo3org']['install']['texlive'] = true
default['site-builddocstypo3org']['install']['cron'] = true

default['php']['secure_functions'] = false
default['php']['ini_settings']['memory_limit'] = '512M'
default['php']['ini_settings']['date.timezone'] = 'Europe/Berlin'

default['site-builddocstypo3org']['app']['owner'] = "builddocstypo3org"
default['site-builddocstypo3org']['app']['home'] = "/var/www/vhosts/build.docs.typo3.org"
default['site-builddocstypo3org']['app']['server_name'] = "build.docs.typo3.org"
default['site-builddocstypo3org']['app']['server_alias'] = nil
#default['site-builddocstypo3org']['app']['fqdn'] = "build.docs.typo3.org"
default['site-builddocstypo3org']['app']['context'] = "Production"

default['site-builddocstypo3org']['database']['name'] = "builddocstypo3org"
default['site-builddocstypo3org']['database']['username'] = "builddocs"
default['site-builddocstypo3org']['database']['password'] = nil
default['site-builddocstypo3org']['database']['hostname'] = "localhost"
