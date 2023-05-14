Deploying applications in kubernetes

Services - In Kubernetes, a service is an abstraction layer that groups a set of pods and provides a stable endpoint (an IP address and a port) to access them

When you create a service in Kubernetes, it automatically creates an endpoint object that contains the IP address and port number of the pods that the service is directing traffic to


Annotations and labels 

labels and annotations are used to attach metadata to Kubernetes objects

- Labels are key-value pairs that are used to identify and organize Kubernetes objects
- Annotations, on the other hand, are used to attach arbitrary metadata to Kubernetes objects. They provide a way to store additional information about an object that is not part of its core definition


The core difference between labels and annotations is their purpose. Labels are used to identify and organize objects, while annotations are used to attach arbitrary metadata to objects

Examples where annotations may be used:

Debugging: Annotations can be used to store debugging information or error logs for your objects. For example, you might add an annotation to a pod to store the last time it was restarted:

```
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
  annotations:
    last-restart: "2022-05-01T12:00:00Z"
spec:
  containers:
  - name: my-container
    image: my-image:latest
```

Audit logs: Annotations can be used to store audit logs for your objects. For example, you might add an annotation to a deployment to store information about who made changes to it:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  annotations:
    audit-log: "Changed by user123 at 2022-05-01T12:00:00Z"
spec:
  replicas: 3
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-container
        image: my-image:latest
```

The data for annotations can be added manually or automatically through admission controllers.

An admission controller can be configured to automatically add annotations to pods as they are created or updated based on certain criteria

Admission Controllers --> https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/

An admission controller is a piece of code that intercepts requests to the Kubernetes API server prior to persistence of the object

An example of admission controllers in action is when you edit an already persisted object and see the additional injected data.


# Service types

ClusterIP, NodePort, LoadBalancer, and ExternalName

ClusterIP: is a type of Kubernetes service that provides a stable virtual IP address for accessing a set of pods within a cluster, which is only accessible from within the cluster and used for secure internal communication between pods


NodePort: Maps a static port on each node in the cluster to a service, allowing external access to pods running in the cluster.

LoadBalancer: Distributes traffic across nodes and provides high availability and redundancy for the application using a load balancer

ExternalName: An ExternalName service provides a DNS record for an external service outside the cluster. This type of service is used when you need to access an external service from within the cluster using a custom DNS name. When a request is made to the ExternalName service, the DNS resolution is done externally to the cluster, and the response is returned to the client.

# Ingress

Ingress is a Kubernetes resource that provides an external entry point into a cluster, allowing you to route traffic from the outside world to your services running inside the cluster.

In other words, Ingress allows you to expose HTTP and HTTPS routes from outside the cluster to services within the cluster. It acts as a reverse proxy that sits in front of one or more services and forwards requests to them based on rules defined in the Ingress resource

In Kubernetes, a Service is a way to expose a set of pods and provide network connectivity to them. Services can have different types (such as ClusterIP, NodePort, LoadBalancer, and ExternalName) to meet different use cases for exposing your application or service to the network.

Ingress, on the other hand, is a Kubernetes resource that provides an external entry point into a cluster. It allows you to route traffic from the outside world to your services running inside the cluster based on rules defined in the Ingress resource.

While Ingress and Service both provide ways to expose your application to the network, they serve different purposes. Services are used to provide connectivity to a set of pods within the cluster, while Ingress is used to route traffic from outside the cluster to your services based on rules defined in the Ingress resource.


# Deploying an Ingress Controller 
An ingress controller is a component in a Kubernetes cluster that manages inbound network traffic and routes it to the appropriate services within the cluster. It acts as an entry point or gateway for external requests to reach the services running inside the cluster.

https://kubernetes.io/docs/concepts/services-networking/ingress/

-- Install latest helm 
-- Deploy Ingress controller

helm repo add nginx https://helm.nginx.com/stable
helm repo update
helm install my-nginx-ingress nginx/nginx-ingress --version 0.17.0

-- Deploy an application using deployment
-- Create a service using ClusterIP to access to application. (With this you can only reach the application internally/privately)

kubectl port-forward service/nginx-service 8080:80

-- Create an ingress resource to access the application from the public.

Note: Open up all your security groups for now to avoid potential issues during testing

-- Ingress Resource

- Connect the DNS name to the Ingress controller's load balancer 
- 

Using AWS EKS 

-- Frontend app 
-- backend (5 microservices)
-- Database (RDS)

Ingress controller

Ingress resources 
    -- Frontend ingress --> IC LB (Ingressclass nginx-public) React --> payment-app.liveclass.training.darey.io/pricing
    -- payment service --> IC LB (Internal)

# helm charts

1. Introduce Helm 
2. helm installation 
3. helm create nginx
4. Deploy all yaml files with "Helm Install"
5. Artifacthub.io 
6. Helm Upgrade
7. Rolling update in action
8. Introduce Values 
9. If condition
10. Helm Rollback and forward
11. deploy a public chart
12. Clean up

### Cert-manager 
Cert-manager is an open-source certificate management solution specifically designed for Kubernetes. It automates the management and provisioning of TLS (Transport Layer Security) certificates within a Kubernetes cluster. Certificates issued by cert-manager are used to secure communication over HTTPS, ensuring data encryption and authenticity.

Cert-manager integrates with the Kubernetes API to provide certificate automation features. It supports multiple certificate authorities (CAs), including Let's Encrypt, Venafi, and self-signed certificates. With cert-manager, users can request, validate, renew, and revoke certificates without manual intervention.

### Order of resources created 

- Issuer/ClusterIssuer: An Issuer or ClusterIssuer resource is created first, defining the certificate authority or issuer.

- Certificate: A Certificate resource is created, specifying the desired properties for the certificate and referencing the issuer or cluster issuer.

- CertificateRequest: After creating a Certificate resource, cert-manager automatically creates a CertificateRequest resource. This resource represents the actual request for the certificate. It includes information such as the requested common name, DNS names, and the reference to the certificate and issuer.

- Order/Challenge: As part of the certificate issuance process, cert-manager creates Order and Challenge resources. Challenges are issued to prove ownership of the domain.

- ACME Solver: If using an ACME issuer, cert-manager sets up an ACME solver Pod or Job to solve the challenges and validate domain ownership.

- Certificate Secret: Once the challenges are successfully completed and the certificate is obtained from the CA, cert-manager stores it securely as a Kubernetes Secret, typically named "tls-secret" or similar. The Certificate Secret contains the TLS certificate, private key, and any intermediate certificates.


CICD (Github actions and Gitlab CI)

-- CI pipeline for Terraform 
-- Software pipeline (Docker)
-- Release tagging