#!/bin/bash

# tooling userdata 

sudo yum update -y
sudo yum install -y mysql git wget 
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo yum install -y dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm


# this section is to install EFS util for mounting to the file system

git clone https://github.com/aws/efs-utils
cd efs-utils
sudo yum install -y make rpm-build
make rpm 
sudo yum install -y  ./build/amazon-efs-utils*rpm

# install botocore - https://docs.aws.amazon.com/efs/latest/ug/install-botocore.html

if [[ "$(python3 -V 2>&1)" =~ ^(Python 3.5.*) ]]; then
    sudo wget https://bootstrap.pypa.io/3.5/get-pip.py -O /tmp/get-pip.py
elif [[ "$(python3 -V 2>&1)" =~ ^(Python 3.4.*) ]]; then
    sudo wget https://bootstrap.pypa.io/3.4/get-pip.py -O /tmp/get-pip.py
else
    sudo wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
fi

sudo python3 /tmp/get-pip.py
sudo pip3 install botocore

# Remember to update the EFS file system ID below
sudo mount -t efs -o tls fs-05b1d7ee92422d438:/ /var/www/html/

sudo mount -t efs -o tls fs-05ac7019200457b56:/ /var/www/html/

sudo mount -t efs -o tls,accesspoint=fsap-0e20bd7d3f6b6630f fs-05ac7019200457b56:/ /var/www/html/


sudo yum install httpd 

sudo systemctl restart httpd

# Configure the tooling app

# Selinux configuration
setsebool -P httpd_can_network_connect=1
setsebool -P httpd_can_network_connect_db=1
setsebool -P httpd_execmem=1
setsebool -P httpd_use_nfs 1


git clone https://github.com/darey-devops/tooling.git
sudo systemctl enable httpd
sudo yum module reset php -y
sudo yum module enable php:remi-7.4 -y
sudo yum install -y php php-common php-mbstring php-opcache php-intl php-xml php-gd php-curl php-mysqlnd php-fpm php-json
sudo systemctl start php-fpm
sudo systemctl enable php-fpm
 cp -R tooling/html/* /var/www/html/

chcon -t httpd_sys_rw_content_t /var/www/html/ -R
systemctl restart httpd

# Update the tooling database
mysql -h acs-database.cdqpbjkethv0.us-east-1.rds.amazonaws.com -u ACSadmin -p toolingdb < tooling-db.sql

sed -i "s/$db = mysqli_connect('mysql.tooling.svc.cluster.local', 'admin', 'admin', 'tooling');/$db = mysqli_connect('acs-database.cdqpbjkethv0.us-east-1.rds.amazonaws.com', 'ACSadmin', 'admin12345', 'toolingdb');/g" functions.php







































vi /etc/httpd/conf.d/welcome.conf

<LocationMatch "^/+$">
    Options -Indexes
    ErrorDocument 403 /.noindex.html
</LocationMatch>

<Directory /var/www/html>
    AllowOverride None
    Require all granted
</Directory>

Alias /index.php /var/www/html/index.php

