name             "postfix"
maintainer       "Christian Rodriguez"
maintainer_email "chrodriguez@gmail.com"
license          "All rights reserved"
description      "Installs/Configures postfix with ldap support"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends "apt"
depends 'certificate'
depends 'clamav'
depends "certificate"
depends "clamav"
