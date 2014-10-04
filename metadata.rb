name "site-builddocstypo3org"
maintainer       "TYPO3 Association"
maintainer_email "fabien.udriot@typo3.org"
license          "Apache 2.0"
description      "Installs/Configures docs.typo3.org"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.3.0"

depends "apt", '~> 2.6.0'
depends "composer", '~> 1.0.5'
depends "database", '~> 2.3.0'
depends "mysql", '~> 5.5.3'
depends "php"
depends "git", '~> 4.0.2'
depends "apache2", '~> 2.0.0'
depends "python", '~> 1.4.6'
depends "mercurial", '~> 2.0.4'
