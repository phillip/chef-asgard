maintainer       "Phillip Goldenburg"
maintainer_email "phillip.goldenburg@sailpoint.com"
license          "Apache 2.0"
description      "Installs/Configures asgard"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"


%w{ tomcat }.each do |cb|
  depends cb
end