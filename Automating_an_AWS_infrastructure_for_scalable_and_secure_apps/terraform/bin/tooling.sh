#!/bin/bash

# This script just installs the EFS utlity but does not go further to mount the EFS on the server. You will have to do this manually.
yum update -y
yum install -y mysql git wget
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
yum install -y dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm

sudo yum -y install wget python3 git


# Download Pip depending on the python version available on the system

if [[ "$(python3 -V 2>&1)" =~ ^(Python 3.6.*) ]]; then
    sudo wget https://bootstrap.pypa.io/pip/3.6/get-pip.py -O /tmp/get-pip.py
elif [[ "$(python3 -V 2>&1)" =~ ^(Python 3.5.*) ]]; then
    sudo wget https://bootstrap.pypa.io/pip/3.5/get-pip.py -O /tmp/get-pip.py
elif [[ "$(python3 -V 2>&1)" =~ ^(Python 3.4.*) ]]; then
    sudo wget https://bootstrap.pypa.io/pip/3.4/get-pip.py -O /tmp/get-pip.py
else
    sudo wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
fi



sudo python3 /tmp/get-pip.py
pip install botocore


sudo setsebool -P httpd_can_network_connect=1
sudo setsebool -P httpd_can_network_connect_db=1
sudo setsebool -P httpd_execmem=1
sudo setsebool -P httpd_use_nfs 1

# this section is to install EFS util for mounting to the file system
# AWS documentation - https://docs.aws.amazon.com/efs/latest/ug/mounting-fs-mount-helper-ec2-linux.html

git clone https://github.com/aws/efs-utils

cd /efs-utils

sudo yum install -y make

sudo yum install -y rpm-build

make rpm 

sudo yum install -y  ./build/amazon-efs-utils*rpm

sudo mkdir /var/www
