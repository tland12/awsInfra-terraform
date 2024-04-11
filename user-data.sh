#!/bin/bash
sudo yum install httpd -y
cat <<'EOF' >> /etc/httpd/conf.d/httpd-vhosts.conf
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_http_module modules/mod_proxy_http.so
<VirtualHost *:80>
  ProxyRequests off
  ProxyPreserveHost On
  ProxyPass / http://a23cd4098eb3547a38f7eb4811b81d1f-205952151.us-west-2.elb.amazonaws.com:8080/ acquire=3000 timeout=600 Keepalive=On
  ProxyPassReverse / http://a23cd4098eb3547a38f7eb4811b81d1f-205952151.us-west-2.elb.amazonaws.com:8080/
</VirtualHost>
EOF
sudo systemctl enable --now httpd
