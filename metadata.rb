name "site-docstypo3org"
maintainer       "TYPO3 Association"
maintainer_email "fabien.udriot@typo3.org"
license          "Apache 2.0"
description      "Installs/Configures docs.typo3.org"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.1.0"

depends "apt", '~> 2.6.0'
depends "composer", '~> 1.0.5'
depends "database", '~> 2.3.0'
depends "mysql", '~> 5.5.3'
depends "php"
depends "git", '~> 4.0.2'
depends "apache2", '~> 2.0.0'
depends "python", '~> 1.4.6'
#depends "build-essential",
depends "mercurial", '~> 2.0.4'

#php[url] = git://github.com/TYPO3-cookbooks/php.git
#php[revision] = 1c7121217e0c82735161fbcb937dfe3d81846ae6
#locales[url] = git://github.com/TYPO3-cookbooks/locales.git
#locales[revision] = 21326c3a1a8eece0d8bcad6ff8763f5356988f09
#chef-solo-search[url] = git://github.com/edelight/chef-solo-search.git
#chef-solo-search[revision] = 4079db540b9b2b00fb383cba8c30f24c2c3bfbb4
#site-docstypo3org[url] = https://github.com/TYPO3-cookbooks/site-docstypo3org.git
#site-docstypo3org[revision] = HEAD
#hg[url] = https://github.com/TYPO3-cookbooks/hg.git
#hg[revision] = 3f376faadc9d5ef45cc2cd676a6760278db1aa46
#
#
#syncGit = true
