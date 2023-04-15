DEPLOYING APPLICATIONS INTO KUBERNETES CLUSTER

1. Kubernetes architecture and videos to watch around building the cluster from scratch
2. Working with AWS EKS
   1. Terraform module
3. Understanding YAML
4. Kubernetes objects
    -- Pods
    -- ReplicationControllers
    -  ReplicaSets
       -  The only difference between replica set and replication controller is the selector types. The replication controller supports equality based selectors whereas the replica set supports equality based as well as set based selectors
    -- Deployments
    -- nammespaces

    -- StatefulSets
        Difference between stateless and stateful application
    -- Services (ClusterIP, NodeIP, Loadbalancer)
    -- Configmaps
    -- secrets
    -- Volumes
    -- PersistentVolumes
    -- PersistentVolumeClaims
5. Understanding YAML configuration syntax 
6. Deployment options into Kubernetes - Kubectl | Helm 
   1. kubectl cheatsheet - https://kubernetes.io/docs/reference/kubectl/cheatsheet/
   2. Kubernetes API Spec - https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/


Extra Notes 

# Port forward to access the cluster IP service
-- kubectl port-forward svc/nginx-service 8080:80 -n masterclass

# Use this to update your kubeconfig file
-- aws eks update-kubeconfig --name sandbox-terraform --region eu-west-2 --kubeconfig ~/.kube/config

# Example accessing an application from the internet
![](../week8/images/service-LB-to-Pod.png)


