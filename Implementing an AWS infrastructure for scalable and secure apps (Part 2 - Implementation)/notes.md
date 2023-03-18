Implementation guide 


1. Create a VPC
2. Create the subnets 
3. Create the Internet Gateway
4. Create route table for the public subnet to use  (Public Route Table)
5. Create a route in the public route table and point to the Internet gateway
6. Associate the public subnets to the created route table
7. Create a NAT Gateway so that servers in the private subnet can reach the internet to for example download stuff (Outbound)
8. Create route table for the private subnet to use (Private Route Table)
9. Create a route in the created route table and point to the NAT Gateway
10. Associate the private subnets (for compute only) to the private route table

## FIREWALL SECTION
Read a bit more about Security Groups here - https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html

Understand the major differences between Security Groups and NACLs - https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Security.html#VPC_Security_Comparison
```
A security group in Amazon Web Services (AWS) is stateless, which means that it does not track or remember the state of network traffic flows. The rules in a security group are evaluated based solely on the incoming network traffic, regardless of any previous network traffic flows.

In a stateless security group, incoming network traffic is evaluated based on the following criteria:

    - Source IP address
    - Destination IP address
    - Port number
    - Protocol (TCP, UDP, ICMP, etc.)

The security group only allows network traffic that matches the rules defined in the security group, and all other traffic is automatically denied. The security group does not remember the state of a connection or the previous network traffic, so it evaluates each incoming network traffic flow independently based on the rules defined in the security group.

Because security groups are stateless, they provide a simple and efficient way to control inbound and outbound network traffic in AWS. They also offer a scalable and flexible security solution that can be updated as needed to reflect changes in network traffic patterns and security requirements.
```
Note! As much as possible, use security group IDs to reference firewall rules.

11. Create Bastion security group. Allow all DevOps engineers to connect over SSH to the Bastion server
12. Create Public ALB security group and allow the entire world to talk to the ALB (HTTP/HTTS)
13. Create Nginx Proxy security group and allow the ALB to talk to the Nginx proxy server. (Nginx). Also allow Bastion to talk to nginx
14. 
15. Create internal ALB security group. (Alow traffic from Nginx proxy)
16. Create Wordpress site Security group (Allow traffic from internal ALB)
29. Create Security group for Tooling site (Allow traffic from internal ALB)
30. Create SG for data layer (RDS and EFS)

## Compute resources section 
30. Create an External facing Application Load Balancer (ALB)
31. Create a Listener (port 80) and target group
32. Update VPC settings to enable DNS Hostnames
33. Update public subnet settings to auto assign public IP address
34. Create Key Pair for SSH
35. Create a Launch Template for Bastion (Use a redhat based AMI) (include subnet settings for auto scaling in templates) Instamce type - Micro
36. Create ASG for Bastion
37. Connect to Bastion server launched in the Public Subnet over SSH
38. Create a Launch Template for nginx (Use a Ubuntu based AMI) (Private network)
39. Create ASG for nginx
40. Connect to the nginx server launched in the Private Subnet (Use SSH Agent to forward the public IP)

## SSH Config Sample



Host *
     StrictHostKeyChecking no

Host bastion
    ForwardAgent yes
    HostName ec2-3-8-180-199.eu-west-2.compute.amazonaws.com
    Port 22
    User ec2-user
    IdentityFile ~/Downloads/practice.pem

Host proxy
    ForwardAgent yes
    HostName ip-10-0-4-64.eu-west-2.compute.internal
    Port 22
    User ubuntu
    IdentityFile ~/Downloads/practice.pem
    ProxyCommand ssh bastion -W %h:%p

Host tooling
    ForwardAgent yes
    HostName 10.0.5.183
    Port 22
    User ec2-user
    IdentityFile ~/Downloads/practice.pem
    ProxyCommand ssh bastion -W %h:%p




1.  Ensure that the nginx Target group is healthy
    1.  Check the security of the instance and ensure it allows port 80
2.  Connect to server and Install nginx
3.  Create Route53 entry. Point the Domain name to the public ALB (CNAME Record) (check /etc/resolv.conf if your web browser does not resolve)
4.  Create default target group for the internal ALB
5.  Create target group for Wordpress site
6.  Create target group for tooling site
7.  Create internal ALB and configure listeners with Host header rules for default web page, wordpress and tooling sites

8.  Configure instance profile and give the tooling and wordpress instances relevant permissions to access AWS resources (for example, S3, EFS)
9.  Create Launch Template for Tooling ASG (Ensure the IAM for instance profile is configured) (RedHat Linux)
10. Create Launch Template for Wordpress ASG (Ensure the IAM for instance profile is configured)  (RedHat Linux)
11. Create ASG for Tooling instances
12. Create ASG for Wordpress instances
13. Configure nginx to upstream to internal ALB

# Configure Proxy

sudo apt update -y 
sudo apt install nginx -y
sudo unlink /etc/nginx/sites-enabled/default


sudo vi /etc/nginx/sites-available/tooling-reverse-proxy.conf

## Configure Tooling Reverse Proxy

server {
    listen 80;
    server_name tooling.masterclass.dev.zone.uk.darey.io;
    location / {
        proxy_pass http://internal-masterclass-feb-internal-alb-2020549966.eu-west-2.elb.amazonaws.com/;
        proxy_set_header Host $host;
    }
  }

sudo ln -s /etc/nginx/sites-available/tooling-reverse-proxy.conf /etc/nginx/sites-enabled/tooling-reverse-proxy.conf

## Configure Wordpress Reverse Proxy
sudo vi /etc/nginx/sites-available/wordpress-reverse-proxy.conf

server {
    listen 80;
    server_name wordpress.dev.zone.darey.io;
    location / {
        proxy_pass http://internal-practice-internal-alb-638271166.eu-west-2.elb.amazonaws.com/;
        proxy_set_header Host $host;
    }
  }


sudo ln -s /etc/nginx/sites-available/wordpress-reverse-proxy.conf /etc/nginx/sites-enabled/wordpress-reverse-proxy.conf 

sudo nginx -t
systemctl reload nginx

1.  Check target groups and ensure they have registered instances
2.  Configure Tooling and Wordpress (A simulation)

## Userdata for nginx
sudo yum update -y
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
sudo yum install -y dnf-utils http://rpms.remirepo.net/enterprise/remi-release-9.rpm
sudo yum install -y nginx git
sudo systemctl restart nginx
### Update the web page  
sudo vi /usr/share/nginx/html/index.html

40. Create Security Group for EFS - Allow access from Tooling and Wordpress on NFS port
41. Install **botocore** - https://docs.aws.amazon.com/efs/latest/ug/install-botocore.html


sudo yum update -y
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
sudo yum install -y dnf-utils http://rpms.remirepo.net/enterprise/remi-release-9.rpm
sudo yum -y install wget python3 git



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


git clone https://github.com/aws/efs-utils
cd efs-utils
sudo yum install -y make
sudo yum install -y rpm-build
sudo make rpm 
sudo yum install -y  ./build/amazon-efs-utils*rpm

sudo mkdir /var/www
sudo mount -t efs -o tls fs-05816de868c46ecae.efs.us-east-1.amazonaws.com:/ /var/www

sudo mount -t efs -o tls 100.0.5.222:/ /var/www


42.  Create EFS File system (SG)
    
43. Create Security Group for RDS
44. Create the KMS key for RDS data encryption
45. Create DB subnet group
46. Create RDS/Aurora Database

47. Configure cloud watch agent 

curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
sudo yum install python2 -y
sudo python2 ./awslogs-agent-setup.py --region us-east-1 --non-interactive --configfile ./config-file.txt



[general]
state_file = /var/awslogs/state/agent-state

[/var/log/messages]
datetime_format = %b %d %H:%M:%S
file = /var/log/messages
buffer_duration = 5000
log_stream_name = {instance_id}/var/log/messages
initial_position = start_of_file
log_group_name = /aws/ec2/instance/user-data

[/var/log/syslog]
datetime_format = %b %d %H:%M:%S
file = /var/log/syslog
buffer_duration = 5000
log_stream_name = {instance_id}/var/log/syslog
initial_position = start_of_file
log_group_name = my-log-group



### Home Work

Relying on your recent experience working with Tooling website, NFS, MySQL Database and cloud concepts. Implement the entire project end to end deploying the real tooling application. Ensure that its configuration points to the RDS/Aurora Database you created.

-- Use any performance testing tool to stress the servers so that autoscaling can be triggered.
-- Implement more sub domain websites
-- Using your knowledge and experience working with lets encrypt to configure TLS/SSL. Learn how ACM works, and terminate SSL on the public load balancer
-- Ensure to configure /etc/fstab after mounting EFS






Annex

Enabling ssh-agent without using the SSH config file. (Although not recommended. Use SSH Config)

Mac OS
ssh-add --apple-use-keychain ~/.ssh/devops.cer

Windows
ssh-add ~/.ssh/devops.cer

Then SSH using the "-A" flag

ssh -A -i ~/.ssh/devops.cer ubuntu@server-ip 






