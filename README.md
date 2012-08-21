Description
===========

Installs and configures Netflix Asgard.

Can also proxy via nginx with optional http basic authentication.

Requirements
============

Tested Platforms:

* Ubuntu (Oracle)

The following Opscode cookbooks are dependencies:

* java (requires Oracle version 6)
* tomcat (requires version 7 - available from https://github.com/phillip/tomcat) 

Attributes
==========

* `default['asgard']['aws_accounts']` - An array of aws_accounts for Config.groovy
* `default['asgard']['aws_account_names']` A hash of account ids and names for Config.groovy
* `default['asgard']['access_id']` - The AWS Access Key that asgard will use
* `default['asgard']['secret_key']` - The AWS Secret Key that asgard will use
* `default['asgard']['account_name']` - Asgard account name, ex: "prod"
* `default['asgard']['public_resource_accounts']` - An array of public resource accounts for Config.groovy
* `default['asgard']['src_url']` - Allows building from source, ex: https://github.com/netflix/asgard/tarball/master

Usage
=====

Simply include the recipe where you want Asgard installed.

License and Author
==================

Author:: Phillip Goldenburg (<phillip.goldenburg@sailpoint.com>)

Copyright 2012, Phillip Goldenburg

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
