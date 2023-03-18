#!/bin/bash

set -e

if ! command -v aws &> /dev/null; then
    echo "AWS CLI not found. Installing..."
    if ! command -v unzip &> /dev/null; then
        echo "unzip not found. Installing..."
        sudo yum install -y unzip
    fi
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -o awscliv2.zip
    sudo ./aws/install --update
    rm -rf aws awscliv2.zip
else
    echo "AWS CLI already installed."
fi



# Update system packages if necessary
echo "Checking for updates..."
if ! sudo yum check-update &> /dev/null; then
    echo "Updating system packages..."
    sudo yum update -y
fi

# Install required packages if necessary
echo "Checking for required packages..."
if ! rpm -q mysql git wget python3 dnf-utils &> /dev/null; then
    echo "Installing required packages..."
    sudo yum install -y mysql git wget python3 dnf-utils
fi

# Configure SELinux if necessary
echo "Checking SELinux configuration..."
if ! getsebool httpd_can_network_connect | grep -q on && \
   ! getsebool httpd_can_network_connect_db | grep -q on && \
   ! getsebool httpd_execmem | grep -q on && \
   ! getsebool httpd_use_nfs | grep -q on; then
    echo "Configuring SELinux..."
    sudo setsebool -P httpd_can_network_connect=1
    sudo setsebool -P httpd_can_network_connect_db=1
    sudo setsebool -P httpd_execmem=1
    sudo setsebool -P httpd_use_nfs=1
fi

# Install EPEL and Remi repositories if necessary
echo "Checking for EPEL and Remi repositories..."
if ! rpm -q epel-release-latest-8.noarch.rpm &> /dev/null && \
   ! rpm -q remi-release-8.rpm &> /dev/null; then
    echo "Installing EPEL and Remi repositories..."
    sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
    sudo yum install -y http://rpms.remirepo.net/enterprise/remi-release-8.rpm
fi

# Add /usr/local/bin to PATH if necessary
echo "Checking PATH configuration..."
if ! grep -q '/usr/local/bin' /etc/profile.d/custom.sh; then
    echo "Adding /usr/local/bin to PATH..."
    echo 'export PATH=$PATH:/usr/local/bin' | sudo tee -a /etc/profile.d/custom.sh >/dev/null
    sudo chmod +x /etc/profile.d/custom.sh
fi

# Add secure_path to sudoers file if necessary
echo "Checking sudoers configuration..."
if ! sudo grep -q 'Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' /etc/sudoers; then
    echo "Adding secure_path to sudoers file..."
    sudo sed -i '$aDefaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' /etc/sudoers
fi

# Install Python3 and pip
if ! rpm -q python3 &> /dev/null; then
    echo "Installing Python3 and pip..."
    sudo yum install -y python3
fi


# Install Python packages if necessary
echo "Checking Python packages..."
if ! rpm -q python3-pip &> /dev/null; then
    echo "Installing Python packages..."
    if [[ "$(python3 -V 2>&1)" =~ ^(Python 3.6.*) ]]; then
        sudo wget https://bootstrap.pypa.io/pip/3.6/get-pip.py -O /tmp/get-pip.py
    elif [[ "$(python3 -V 2>&1)" =~ ^(Python 3.5.*) ]]; then
        sudo wget https://bootstrap.pypa.io/pip/3.5/get-pip.py -O /tmp/get-pip.py
    elif [[ "$(python3 -V 2>&1)" =~ ^(Python 3.4.*) ]]; then
    sudo wget https://bootstrap.pypa.io/pip/3.4/get-pip.py -O /tmp/get-pip.py
    fi
fi

echo "Installing botocore package..."
if ! pip3 show botocore &> /dev/null; then
    sudo pip3 install -q botocore
else
    echo "botocore is already installed."
fi


# Install EFS utils for mounting to the file system
if [[ ! -d efs-utils ]]; then
    echo "Cloning EFS utils repository..."
    git clone https://github.com/aws/efs-utils.git
    cd efs-utils
    sudo yum install -y make
    sudo yum install -y rpm-build
    make rpm
    sudo yum install -y ./build/amazon-efs-utils*rpm
    cd ..
fi

# Create directory for Apache web server
if [[ ! -d /var/www ]]; then
    echo "Creating directory for Apache web server..."
    sudo mkdir /var/www
fi

#### Mounting the EFS mountpoint on /var/www ######

# Get AWS region
aws_region=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//')

# Get EFS file system ID
efs_file_system_id=$(aws efs describe-file-systems --query "FileSystems[0].FileSystemId" --output text)

# Construct EFS DNS name
efs_dns_name="$efs_file_system_id.efs.$aws_region.amazonaws.com"

echo "efs_dns_name: ${efs_dns_name}"

# Update /etc/fstab
echo "Updating /etc/fstab..."
if ! grep -q "efs" /etc/fstab; then
    echo "$efs_dns_name:/ /var/www efs tls,_netdev 0 0" | sudo tee -a /etc/fstab
    echo "Entry added to /etc/fstab."
else
    echo "Entry already exists in /etc/fstab."
fi

# Mount EFS file system
echo "Mounting EFS file system..."
if ! sudo mount -a -t efs,nfs4 defaults,_netdev; then
    echo "EFS file system failed to mount."
else
    echo "EFS file system mounted successfully."
fi



echo "Done."
