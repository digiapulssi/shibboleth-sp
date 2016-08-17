## Overview

This is a fork of [jtgasper's centos-shibboleth-sp](https://github.com/jtgasper3/docker-images/tree/master/centos-shib-sp).

The main purpose of this fork is to fix errors, add features and review possible future updates before applying them to this container.

### Features

- Shibboleth SP, OpenSuse repository, latest
- Apache, latest with mod_ssl

Ports 80 and 443 are exposed for traffic.

### Usage

Mount the files to the container you wish to change. The most common files to change are:

- /etc/shibboleth/shibboleth2.xml
  - Shibboleth SP configuration
- /etc/httpd/conf.d/shib.conf
  - Shibboleth protected content configuration
-  /etc/pki/tls/certs/*
  - Apache certificates for SSL

### Example configuration

Protect and reverse proxy a url
```
shib.conf

<Location /software>
  AuthType shibboleth
  ShibRequestSetting requireSession 1
  require shib-session

  ProxyPreserveHost On
  ProxyPass http://softwaredomain:port
  ProxyPassReverse http://softwaredomain:port
</Location>
```

Configure a single IdP to contact
```
shibboleth2.xml

...

<ApplicationDefaults entityID="https://yourspdomain/shibboleth" REMOTE_USER="eppn persistent-id targeted-id">

...

<SSO entityID="https://youridpdomain/idp/shibboleth">
  SAML2
</SSO>

...

<MetadataProvider type="XML" validate="true" uri="https://youridpdomain/idp/shibboleth" backingFilePath="federation-metadata.xml" reloadInterval="7200">
</MetadataProvider>

...
```

### Pitfalls

If you have a proxy before this container it may become difficult to configure a combination of HTTP and HTTPS. For easiest configuration use either HTTP or HTTPS for all traffic up to this container:
`Client - HTTPS -> HAProxy - HTTPS -> Shibboleth-SP - HTTP -> Software`
`Client - HTTP -> HAProxy - HTTP -> Shibboleth-SP - HTTP -> Software`

Not

`Client - HTTPS -> HAProxy - HTTP -> Shibboleth-SP - HTTP -> Software`

## Authors

  * John Gasper (<https://jtgasper.github.io>, <jgasper@unicon.net>, <jtgasper3@gmail.com>)
  * Ville Valtonen (<ville.valtonen@digia.com>)

## Changes

  * Added mod_ssl

## LICENSE

Copyright 2015 John Gasper

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
