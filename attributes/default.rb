#
# Cookbook Name:: site-docstypo3org
# Attributes:: default

#default['site-docstypo3org']['flow']['context'] = "Production"
#default['site-docstypo3org']['flow']['root_path'] = "/var/www/vhosts/build.docs.typo3.org/releases/current/"
default['site-docstypo3org']['install']['libreoffice'] = false
default['site-docstypo3org']['install']['texlive'] = false

default['php']['secure_functions'] = false
default['php']['ini_settings']['memory_limit'] = '512M'
default['php']['ini_settings']['date.timezone'] = 'Europe/Berlin'

default['site-docstypo3org']['app']['owner'] = "docsbuilder"
default['site-docstypo3org']['app']['home'] = "/var/www/vhosts/build.docs.typo3.org"
default['site-docstypo3org']['app']['server_name'] = "build.docs.typo3.org"
default['site-docstypo3org']['app']['server_alias'] = nil
#default['site-docstypo3org']['app']['fqdn'] = "build.docs.typo3.org"
default['site-docstypo3org']['app']['context'] = "Production"

default['site-docstypo3org']['database']['name'] = "docsbuilder"
default['site-docstypo3org']['database']['username'] = "docsbuilder"
default['site-docstypo3org']['database']['password'] = nil
default['site-docstypo3org']['database']['hostname'] = "localhost"
