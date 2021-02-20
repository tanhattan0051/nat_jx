#!/bin/bash

domain=
echo "domain: "
read domain
cat <<EOF >/etc/nginx/vhosts/$domain.conf
#testcookie được phép bật với các game không có cơ chế check update hoặc gọi web để login
#1 số game được phép bật testcookie: SRO, jx1, jx2, minecraft
#1 số game không được phép bật testcookie: TLBB, CLTB (Cửu long tranh bá)

server {
        listen      103.90.227.208:443 ssl;
        server_name www.$domain   $domain;
        #include     /etc/nginx/conf.d/sec-vhosts.conf;
        ssl_certificate /etc/nginx/ssl/$domain.pem;
        ssl_certificate_key /etc/nginx/ssl/$domain.key;
#        access_log      /var/log/nginx/domain.log combined;
#        error_log      /var/log/nginx/domain.log error;

#Block bad user agent
        if (\$badbot = 1) { return 444; }

#Protect from bad referer
        if (\$badreferer = 1) { return 499; }

#Block bot from proxy free and accept cloudfare ips      
        if ( \$http_x_real_ip )  { return 406; }
        if ( \$http_x_forwarded_for ) { return 406; }
        if ( \$http_x_via ) { return 406; }

        location / {
                #testcookie  on;


                proxy_pass  https://103.90.227.234;
                include     /etc/nginx/conf.d/proxy.inc;
        }
}
EOF


scp  Tuanweb.VPS.Com:/usr/local/directadmin/data/users/admin/domains/$domain.key /etc/nginx/ssl/
scp  Tuanweb.VPS.Com:/usr/local/directadmin/data/users/admin/domains/$domain.cert.combined  /etc/nginx/ssl/
mv /etc/nginx/ssl/$domain.cert.combined  /etc/nginx/ssl/$domain.pem



echo "vim  /etc/nginx/ssl/$domain.pem"
echo "vim /etc/nginx/ssl/$domain.key"