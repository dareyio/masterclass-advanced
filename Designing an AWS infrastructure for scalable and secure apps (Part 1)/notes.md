DevOps Masterclass with DAREY.IO

# Structure of the live sessions

- Saturdays only.

- A lot of home work and videos to catch up ahead of the class.

1. What is DevOps? 

2. What exactly is the cloud about?
   
    Private Cloud vs Public Cloud
   
    Public Cloud providers
   - AWS
   - Microoft Azure
   - Google GCP
   - Alibaba Cloud
   - Digital Ocean
   - Oracle Cloud


3. DAREY.IO Masterclass structure and all technologies to be covered
   
   - Designing Solutions in AWS (Hands On)
   - Operations 
     - Linux
     -  Terraform
   - Containerisation
     - Docker
   - Orchestration
     - Kubernetes
     - Helm
   - CI/CD
    - Jenkins
  - Monitoring
    - Prometheus
    - Grafana
  - Logging
    - Elasticsearch Stack
      - Kibana
      - Filebeat
      - Metricbeat
      - Journalbeat

1. AWS and the core areas our next project will focus on

- Data Centre

## Networking

Implementing an End to End AWS Solution - From Diagram ---> Manual Implementation ---> Automated Implementation

Business Requirement

Implement a solution that allows an organisation to host multiple websites or applications based on the same infrastructure. Consider security, scalability, Disaster recovery, High Availability, cost effectiveness, and operational excellence.

This solution must use virtual machines and not containers.


1. A virtual Network in AWS
2. How can we ensure we can easily recover from disaster?
   1. Implement a Multi AZ solution
3. Divide the network into logical groups (Gateway, Compute, Data)
   1. Should workloads storing data be within the same network as the workloads doing the computation?
   2. Should our servers be accessible directly over the public network? (Internet)
   3. How should our engineers access servers in the private network since private servers can never be reached over the internet.
4. Is there a requirement to access the product from the internet?
   1. We need an internet gateway
   2. Traffic Routes (Route Table and Routes configuration)
5. Do we need our private network to download stuff from the internet? - 2 Possible solutions
   1. Proxy server in the gateway or public network to initially download, scan and quarantine any packages or binaries downloaded from the internet
   2. Implement a Network Address Translator (NAT) gateway in the Private network.
6. Determine what workload will run where and implement firewall through security groups
7. How do we resolve IP addresses or Load balancer addresses to a human readable domain name? Route53
8. How should our servers dynamically scale?
   1. Autoscaling groups
9.  When servers scale in ASGs, new servers have IP addreses we never knew about. How can we reach applications deployed on these newly created servers, without prior knowledge of their address?
   2. Resolve the human readable domain name to a Load balancer
   3. Configure the load balancer to reach the ASG through target groups
10. How can we ensure that multiple applications can be deployed into the same infrastructure and re-use most of the cloud resources to save cost.
   4.  Route traffic from the internet to the human readable domain name pointing that is pointing to the public load balancer
   5.  Implement a reverse proxy to accept traffic from the load balancer and forward onto the respective application
   6.  Implement an internal load balancer to receive traffic from the reverse proxy which eventually delivers the traffic to the final application.


- Virtual Private Cloud (VPC)
- Internet Gateway
- NAT Gateway
- Route Tables
- Routes
- Security Groups
- Elastic IPs
- Subnets (Public and Private)
- DNS (Route53)
- Regions and Availability Groups


## Compute
- AWS Load Balancers (Public and Private)
- Listeners
- Target Groups
- Auto Scaling Groups
- Launch Templates
- EC2 Instances
- AWS AMIs

## Data
- Relational Database (RDS)
- Elastic File System (EFS)

Designing Solutions in the Cloud - Always think about the 6 Pillars

1. Operational Excellence
   - Perform operations as code
   - Make frequent, small, reversible changes
   - Refine operations procedures frequently
   - Anticipate failure
   - Learn from all operational failures

2. Security - Its all about protecting data, systems, and assets running in the cloud
   - In flight and At Rest protection through encryption
   - Automate secuity best practices
   - Prepare for security breaches
3. Reliability - The ability of a workload to perform its intended function correctly and consistently when it’s expected to
   - Availability
   - Disaster Recovery
   - Scalability
4. Performance Efficiency - The ability to use computing resources efficiently to meet system requirements.
   - Go global in a matter of minutes
   - Go serverless as much as you can to eliminate operational burden
5. Cost Optimization - The ability to run systems to deliver business value at the lowest price point

6. Sustainability - This pillar focuses on environmental impacts, especially energy consumption and efficiency. continuous effort focused primarily on energy reduction and efficiency across all components of a workload by achieving the maximum benefit from the resources provisioned and minimizing the total resources required

Business Requirement for Hands On Implementation

Implement a solution that allows the organisation to host multiple websites or applications based on the same infrastructure.

The goal is to consider the AWS Well Architected Framework as much as possible. Draw the architectural design, and implement a Proof of concept manually first, and then automate using Terraform.
