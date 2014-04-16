#
# Cookbook Name:: site-docstypo3org
# Attributes:: default

default['site-docstypo3org']['flow']['context'] = "Production"
default['site-docstypo3org']['flow']['root_path'] = "/var/www/vhosts/build.docs.typo3.org/releases/current/"


override['php']['secure_functions'] = false
override['php']['ini_settings'] = {
  'memory_limit' => '512M',
  'date.timezone' => 'Europe/Berlin'
}

