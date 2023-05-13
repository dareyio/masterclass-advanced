DEPLOYING APPLICATIONS INTO KUBERNETES CLUSTER

## Pre-requisite
   - Understanding YAML configuration syntax 
# Kubernetes architecture and videos to watch around building the cluster from scratch

   Kubernetes is a powerful and flexible platform for managing containerized applications and provides many benefits for organizations that deploy and manage applications at scale. Here are some of the reasons why Kubernetes is widely used:

           -   Scalability and flexibility: Kubernetes allows you to scale your applications up or down based on demand, making it easy to manage large or complex applications with many components.

           -   Resilience and availability: Kubernetes is designed to be highly available and fault-tolerant, ensuring that applications continue to run even in the event of node failures or other issues.

           -   Portability: Kubernetes provides a consistent way to deploy and manage applications across different environments, making it easier to move applications between different clouds or on-premises environments.

           -   Automation and orchestration: Kubernetes provides a powerful set of APIs and tools for automating the deployment and management of applications, allowing for a high degree of automation and orchestration.

           -   Resource utilization: Kubernetes provides a way to manage and optimize the use of resources such as CPU, memory, and storage, ensuring that resources are used efficiently and effectively.

           -   Ecosystem and community: Kubernetes has a large and growing ecosystem of tools and integrations, as well as an active and supportive community of developers and users.

   - Master node: The master node is the control plane that manages and coordinates the entire Kubernetes cluster. It is responsible for managing the state of the cluster and making decisions about scheduling and scaling.

   -   API server: The API server is the front-end for the Kubernetes control plane. It exposes the Kubernetes API and provides a single entry point for all cluster operations.

   -   etcd: etcd is a distributed key-value store that stores the state of the Kubernetes cluster. It is the source of truth for the entire cluster and is used by the Kubernetes control plane to store configuration data and metadata about the cluster.

   -   Controller manager: The controller manager is responsible for running a set of controllers that automate cluster management tasks. Controllers watch the state of the cluster and make changes to bring the actual state of the system in line with the desired state.

         Examples:
            - Replication controller
            - Deployment controller
            - StatefulSet controller
            - DaemonSet controller
            - Job controller

   -   Scheduler: The scheduler is responsible for deciding where to place new pods (the smallest deployable units in Kubernetes) in the cluster. It takes into account resource availability, quality of service requirements, and other factors to make optimal placement decisions.

   -   Worker nodes: Worker nodes are the nodes in the Kubernetes cluster that run the actual workloads. Each worker node runs a container runtime (such as Docker) and a kubelet, which communicates with the control plane to receive instructions about what workloads to run.

   -   Kubelet: The kubelet is an agent that runs on each worker node and is responsible for managing the state of the node. It communicates with the control plane to receive instructions about what workloads to run and monitors the health of the node and the workloads running on it.

   -   Container runtime: The container runtime is responsible for running the containers that make up the workloads in the cluster. Kubernetes supports a variety of container runtimes, Docker is now deprecated but there is support for containerd, podman, mesos etc... Kubernetes uses a container runtime interface (CRI) to interact with container runtimes, which means that any container runtime that implements the CRI API can be used with Kubernetes. This provides flexibility and allows users to choose the container runtime that best suits their needs.
   -   kube-proxy: is a network proxy that runs on each node in a Kubernetes cluster. Its primary function is to handle the network routing for services in the cluster.

## From a high level 
Control Plane
         Master (3 nodes)
            -- Api server
            -- Controller Manager
              Deployment Controller
              Replicationset controller
              Replication 
              statefulset controller
            -- scheduler
            
         ETCD cluster (3 nodes)

Data plane
         Worker (X number of servers)
           -- kubelet
           -- container runtime
           -- kubeproxy

# The Kubernetes API 

-   The Kubernetes API (Application Programming Interface) is a RESTful (Representational State Transfer) API that exposes the control plane of a Kubernetes cluster. The API allows you to manage the entire lifecycle of Kubernetes objects, including pods, services, deployments, and more.

   The Kubernetes API is the primary way that developers and administrators interact with Kubernetes. It provides a standardized interface for managing Kubernetes objects, regardless of the underlying implementation or cloud provider. The API allows you to perform a wide range of tasks, including:

   -  Creating, modifying, and deleting Kubernetes objects
   -  Inspecting the status of Kubernetes objects
   -  Scaling applications up and down
   -  Rolling out updates to applications using rolling updates
   -  Exposing applications to the network using services
   -  Monitoring the health of applications and the cluster
  
   It is designed to be extensible, which means that you can define custom resources and controllers that -  extend the core functionality of Kubernetes.

   It is implemented as a set of HTTP endpoints, which are typically exposed through a Kubernetes API server. Clients interact with the API using standard HTTP methods like GET, POST, PUT, and DELETE, and can access the API using a variety of programming languages and tools.

   Note: REST (Representational State Transfer) is a software architectural style for designing distributed systems that use the HTTP protocol to exchange data. Resources are represented by URIs (Uniform Resource Identifiers) 

   ### Some Principles of RESTful 

   Note: "FUL" stands for "Follows Uniform Interface and Layered System. 
   
   The principle means that the web service should have a uniform interface for accessing resources, with resources identified by URIs and accessed using standard HTTP methods. This allows clients to interact with the service in a consistent way, regardless of the underlying implementation or data format.

   - Client-server architecture: The system is divided into two separate parts: a client that makes requests, and a server that processes those requests and returns a response.

   - Statelessness: Each request from the client to the server should contain all the necessary information to complete the request, without requiring the server to retain any state information between requests.

```
   curl -X POST -H "Content-Type: application/json" -d '{"apiVersion": "v1", "kind": "Pod", "metadata": {"name": "my-pod"}, "spec": {"containers": [{"name": "nginx", "image": "nginx"}]}}' http://<api-server>:<port>/api/v1/namespaces/<namespace>/pods
```

Equivalent using kubectl 

```
kubectl create -f pod-definition.json
```

pod-definition.json content 
```
{
"apiVersion": "v1",
"kind": "Pod",
"metadata": {
   "name": "my-pod"
},
"spec": {
   "containers": [
      {
      "name": "nginx",
      "image": "nginx"
      }
   ]
}
}

```

YAML Equivalent 

```
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: nginx
    image: nginx
```

# Working with AWS EKS
   1. Installing kubernetes with Kind 
      1. https://kind.sigs.k8s.io/
      2. kind create cluster --name liveclasses
   2. Terraform module
   3. Accessing the Kubernetes cluster 
      aws eks update-kubeconfig --name liveclasses --profile liveclasses  --region eu-west-2 --kubeconfig ~/.kube/config
1. Kubernetes objects
    -- Pods
       a pod is the smallest and simplest unit of deployment. Containers that run in it see each other as localhost. Best practice is to run 1 container per pod. But there are use cases for multiple containers in the same pod.

    -- ReplicationControllers
    Replication Controller is a resource that ensures that a specified number of replicas of a pod are running at any given time. It is a higher-level abstraction that provides replication and self-healing capabilities for pods.

    -  ReplicaSets
       ReplicaSet is a higher-level abstraction that provides replication and self-healing capabilities for pods. It is similar to a Replication Controller, but provides more advanced rolling update capabilities and other features.

       -  The major difference between replica set and replication controller is the selector types. The replication controller supports equality based selectors whereas the replica set supports equality based as well as set based selectors.
  
   Differences Highlighted:

                  Selector support: Replication Controllers only support equality-based selectors, while ReplicaSets support set-based selectors. This means that ReplicaSets can select pods based on more complex criteria than Replication Controllers, allowing for more fine-grained control over which pods are managed.

                  Label support: ReplicaSets have stricter label requirements than Replication Controllers. Specifically, all pods managed by a ReplicaSet must have a label that matches the matchLabels selector defined in the ReplicaSet.

                  Rolling updates: ReplicaSets have more advanced rolling update capabilities than Replication Controllers. Specifically, ReplicaSets can perform rolling updates that modify the pod template (i.e., the specification for how the pod should be created), while Replication Controllers can only perform rolling updates that modify the replicas count.

                  API version: Replication Controllers are an older API object in Kubernetes, while ReplicaSets were introduced in a later version of the API. As a result, ReplicaSets provide more features and functionality than Replication Controllers, and are generally recommended over Replication Controllers for most use cases.


    -- Deployments
    Deployment is a higher-level abstraction that provides declarative updates and scaling for replica sets. (i.e a By declarative updates, we mean it is a way of defining the desired state of a resource, rather than the specific actions required to achieve that state. With declarative updates, you define the desired state of a resource, and Kubernetes automatically applies the changes necessary to achieve that state.). 
    
    It provides a way to declaratively define and manage a set of ReplicaSets and their associated pods

      Why should I use deployments and not replicasets directly?

      -- Declarative updates: Desired state as opposed to actual state.
      -- Rollback capabilities: 

         kubectl get deployments
         kubectl rollout history deployment/<deployment-name>
         kubectl rollout undo deployment/nginx-deployment --to-revision=1
         kubectl rollout status deployment/<deployment-name>
         kubectl describe deployment/<deployment-name>

      -- Scaling

         kubectl scale deployment my-deployment --replicas=5


      -- Automated and controlled rollouts

         Update Strategies
            - RollingUpdate
            - Recreate
         ```
         kubectl apply -f my-deployment.yaml --record
         ```

    -- nammespaces
      In Kubernetes, a namespace is a logical partition within a cluster that is used to isolate and organize resources. Namespaces provide a way to group resources together based on their function or ownership, and to apply resource quotas and access controls to those resources
    -- StatefulSets

       StatefulSet is a higher-level abstraction that provides stateful deployment and scaling capabilities for stateful applications
        It is similar to a Deployment, but provides additional features to ensure the ordered and unique deployment of pods in a stateful application

      When you introduce volumes in deployments, the deployment also becomes stateful, but it lacks other benefits that statefulset provides.

    -- Services (ClusterIP, NodeIP, Loadbalancer)

      Service is an abstraction that defines a logical set of Pods and a policy to access them. A Service provides a stable IP address and DNS name that can be used to access a set of Pods.

    -- Configmaps

      ConfigMap is a configuration resource that provides a way to store and manage configuration data separately from the application code. can be used to store key-value pairs e.g environment variables, default settings for apps etc...

    -- secrets
      Secret is an object that is used to store sensitive data such as passwords, API keys, and other confidential information. Think of it as another configmap but for secret data


    -- Volumes

      Volume is a directory that is mounted into a container, providing a way to store and manage data that persists across container restarts or moves
         -- EmptyDir: A temporary directory that is created when a Pod is created, and deleted when the Pod is deleted. Useful for storing temporary data or sharing data between containers in the same Pod.
         -- HostPath: A directory on the host node's file system that is mounted into the container. Useful for sharing files between containers or for storing persistent data that needs to be accessed by multiple Pods
         -- PersistentVolumes (PV):  A network-attached storage volume that can be shared by multiple Pods or nodes.
         -- ConfigMap and Secret

      ## Other concepts around Storage in Kubernetes 

         -- PVC (PersistentVolumeClaim) is a request for a storage resource in a cluster. PVCs are used to dynamically provision storage volumes and provide a way for applications to access and manage persistent storage without needing to know the underlying details of the storage infrastructure.

4. Deployment options into Kubernetes - Kubectl | Helm 
   1. kubectl cheatsheet - https://kubernetes.io/docs/reference/kubectl/cheatsheet/
   2. Kubernetes API Spec - https://kubernetes.io/docs/reference/kubernetes-api/


Extra Notes 

# Port forward to access the cluster IP service
-- kubectl port-forward svc/nginx-service 8080:80 -n masterclass

# Use this to update your kubeconfig file
-- aws eks update-kubeconfig --name liveclasses --region eu-west-2 --kubeconfig ~/.kube/config

# Example accessing an application from the internet
![](../week8/images/service-LB-to-Pod.png)


