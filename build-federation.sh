#!/bin/bash

cat <<EOF > /etc/shibboleth-ds/federation-metadata.xml
<?xml version="1.0" encoding="UTF-8"?>
<EntitiesDescriptor xmlns="urn:oasis:names:tc:SAML:2.0:metadata" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:shibmd="urn:mace:shibboleth:metadata:1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Name="https://your-federation.org/metadata/federation-name.xml">
EOF

if sed -i '/<\?.*?>/d' /etc/shibboleth-ds/* ; then
  echo "Federation sources cleaned up"
fi

if cat /etc/shibboleth-ds/idp_metadata/* >> /etc/shibboleth-ds/federation-metadata.xml ; then
  echo "Federation XML built"
else
  echo "No federation XML found"
fi

cat <<EOF >> /etc/shibboleth-ds/federation-metadata.xml
</EntitiesDescriptor>
EOF
