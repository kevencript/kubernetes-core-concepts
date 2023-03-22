# Kuberentes (K8s) Fundamentals 📜

<img src="https://github.com/kubernetes/kubernetes/raw/master/logo/logo.png" width="100">

----

[Kubernetes](https://kubernetes.io), also known as K8s, is an open source system for managing [containerized applications]
across multiple hosts. It provides basic mechanisms for deployment, maintenance,
and scaling of applications.

In simple terms, Kubernetes helps in managing the lifecycle of containerized applications by providing a wide range of features and tools. These include load balancing, rolling updates, self-healing, horizontal scaling, and desired state management. Kubernetes groups containers together to form logical units, called pods, which can be easily managed and scaled. It also provides a declarative approach to manage the infrastructure, allowing users to define the desired state of the system through configuration files.

Kubernetes has become the industry standard for container orchestration due to its powerful features, extensive ecosystem, and strong community support. It works with various container runtime engines, such as Docker and containerd, and is compatible with many cloud platforms, making it a highly versatile and sought-after solution for managing containerized applications.

----

## Project Overview 📌

#### Introduction
This project aims to exemplify the Kubernetes fundamentals with pratical manifests. We deployed a simple Go app, in which is the base to test most part of Kuberentes features. We also deploy MySQL for Stateful examples. For the whole doc, we are using [Kind](https://kind.sigs.k8s.io) (local Kubernetes clusters using Docker container “nodes”) to quickly create a cluster, validade all concepts and explore the K8s features without need too much boilerplate.

#### How it is organized
We will separate it per modules, and each topic from modules will have visual examples following the construction timeline (via commits). This means that every new feature will have a commit related to it, this way its better to visualize all the changes and follow the project construction flow

#### Automated Commands (Makefile)
We have a main Makefile with all the step commands to exemplify and automate the process of cluster creation, shortcuts for deploy, stress test and validation concepts executing scripts. You can take a better look [here](https://github.com/kevencript/kubernetes-core-concepts/blob/main/Makefile)

----

## 1 - Creating Kind K8s Cluster

[Kind](https://kind.sigs.k8s.io), which stands for **Kubernetes IN Docker**, is an open-source tool that enables users to create and manage lightweight Kubernetes clusters using Docker containers. It serves as a valuable resource for testing and development purposes, as it allows for rapid and efficient deployment of Kubernetes clusters on local machines, streamlining the testing and debugging process for developers and DevOps professionals.

#### 1.1 - Create the Kind config file
A KIND configuration file is a YAML-formatted file that provides a declarative way to define the desired state and structure of a Kubernetes cluster created using the KIND (Kubernetes IN Docker) tool.

Command to create the cluster:
```sh
kind create cluster --config kind-config.yaml --name $(NAMESPACE)
```

> Related Commit: [feat: ✨ Added kind config yaml](https://github.com/kevencript/kubernetes-core-concepts/blob/main/Makefile)

---

## 2 - Pods

In Kubernetes (K8s), a pod is the smallest and most basic unit in the K8s object model. A pod represents a single instance of a running process in a cluster and typically contains one or more containers that work closely together to deliver a specific function or part of an application.

---

## 3 - Replicasets

A ReplicaSet in Kubernetes is a higher-level abstraction over pods that ensures a specified number of replicas of a pod are running at any given time. In simple terms, a ReplicaSet ensures that a certain number of identical pod instances are running, and if any of those instances fail or are terminated, the ReplicaSet will create new ones to maintain the desired count.
> Related commit: [feat: ✨ Replicasets: higher-level abstraction over pods](https://github.com/kevencript/kubernetes-core-concepts/commit/1a75e1b4b18d8333fcbcd027ca28d306d896ae10)

---

## 4 - Deployments

A Deployment in Kubernetes is a resource that manages the desired state, scaling, and updates of ReplicaSets and their associated pods, ensuring the continuous availability and stability of applications.

> Related commit [feat: ✨ Deployments: Manages the desired state, scaling, and updates of ReplicaSets
](https://github.com/kevencript/kubernetes-core-concepts/commit/cc1da121c015b3ea4ea9fa8cd3c93936d0750d69)

## 5 - Services 
"Service" in the context of Kubernetes (often abbreviated as "k8s" for convenience) refers to an abstraction that represents a set of pods that perform a similar function and provide a consistent endpoint for client applications to access them.

#### 5.1 - Port and TargetPort
```yaml
 ports:
   - name: go-http-app-backend
     port: 80
     targetPort: 8000
```
Port and targetPort are key concepts when configuring services in Kubernetes. The "port" defines the external port on which the service is exposed and accessible within the cluster. The "targetPort" specifies the port on which the backend pods or containers are listening for incoming traffic. When a connection is made to the service at the specified "port", traffic is forwarded to the corresponding "targetPort" on the matched backend pods.
> Related commit: [feat: ✨ Services: Port and TargetPort](https://github.com/kevencript/kubernetes-core-concepts/commit/7301c28ff69db03bbdfb339d2a74762f6e3bbf28)

#### 5.2 NodePort
NodePort is a type of Kubernetes Service that exposes an application to external clients by assigning a static port on each node in the cluster. This allows users to access the service through any node's IP address and the assigned NodePort, making it a convenient way to expose applications running within the cluster to external traffic.
```yaml
    port: 80
     targetPort: 8000
     protocol: TCP
   type: ClusterIP
   type: NodePort
```
> Related commit: [feat: ✨ Service: NodePort](https://github.com/kevencript/kubernetes-core-concepts/commit/468045585c75b78b7f10f3b21c3c2b84be64f463)

#### 5.3 LoadBalancer
A load balancer is a networking component that distributes incoming traffic across multiple backend servers, ensuring optimal resource utilization and high availability. In the context of Kubernetes, a LoadBalancer service type is used to expose applications to external clients by automatically provisioning a cloud provider's load balancer, which directs traffic to the appropriate Pods based on their readiness and load balancing algorithms.

```yaml
  port: 80
     targetPort: 8000
     protocol: TCP
   type: NodePort
   type: LoadBalancer
```
> Example Commit: [feat: ✨ Services: LoadBalancer](https://github.com/kevencript/kubernetes-core-concepts/commit/3b5e85f8e50d414c0d6716acd9420af97c5858f6)

---

## 6 - Config Objects

#### 6.1 Environment Variables
In Kubernetes deployments, environment variables enable flexible application configuration within containers. They help decouple applications from infrastructure, making them more portable and easily managed through the deployment manifest, without modifying the container image.
> Related commit: [feat: ✨ Config: Environment Vars](https://github.com/kevencript/kubernetes-core-concepts/commit/b4c980acdd24b0e96c4b7b0be839c3e6f8a9674d)

#### 6.2 Configmaps
ConfigMaps in Kubernetes are a flexible way to store and manage non-sensitive configuration data for your applications, enabling you to decouple configuration settings from container images and simplifying updates and maintenance.
* > Related commit: [feat: ✨ Config: Configmaps](https://github.com/kevencript/kubernetes-core-concepts/commit/b4c980acdd24b0e96c4b7b0be839c3e6f8a9674d)
* > Related commit: [feat: ✨ Configs: Confimap - envFrom (import all values->keys)](https://github.com/kevencript/kubernetes-core-concepts/commit/7448f1f57ef4b1709b7ac797a5620415a83f47c9)
* > Related commit: [feat: ✨ Config: Configmaps - File injection with Volumes](https://github.com/kevencript/kubernetes-core-concepts/commit/7eb28ea2eef8db75884658fbd6e8b91fca6ff701)

#### 6.3 Secrets
Kubernetes Secrets are secure objects used to store sensitive data, such as passwords, API keys, or tokens, within a cluster. They help protect confidential information and reduce the risk of exposing it accidentally. Secrets store data in base64 encoding, ensuring an additional layer of obfuscation. They can be mounted as files, used as environment variables, or accessed by the Kubernetes API, providing a secure and controlled way to share sensitive information with containers.
> Related commit: [feat: ✨ Configs: Secrets](https://github.com/kevencript/kubernetes-core-concepts/commit/817fec61f51a41d75fb92703337fe26b67dd4487)

---

## 7 - Probes
"Probes" in Kubernetes (often abbreviated as "k8s" for convenience) refer to a mechanism that allows you to determine the health of a container running inside a pod. Kubernetes provides three types of probes:

#### 7.1 - Liveness
A liveness probe in Kubernetes is a mechanism to determine the health of a running container by periodically checking its responsiveness. If a container fails the liveness check, Kubernetes will restart it, ensuring that the application remains available and recovers from potential issues automatically.  In this example, an HTTP GET request is made to the /healthz endpoint on port 8000 every 5 seconds. If the container fails the liveness check, Kubernetes restarts it after reaching the failure threshold of 1. The probe waits up to 1 second for a response before timing out, and the container is considered healthy after a single successful check. This ensures that the application remains available and automatically recovers from potential issues.
> Related commit: [feat: ✨ Probes: Liveness](https://github.com/kevencript/kubernetes-core-concepts/commit/51164893bc9c7b8779dc3876225f1d24c841b5fb)

#### 7.2 - Readiness
A readiness probe in Kubernetes is used to determine if a container is ready to accept incoming traffic. By periodically checking the container's responsiveness, Kubernetes can prevent traffic from being sent to a container that is not yet fully operational, ensuring a more stable and reliable application experience for users.
* > Related commit: [feat: ✨ Probes: Readiness](https://github.com/kevencript/kubernetes-core-concepts/commit/444f086f75d46767e3102d8af9e74a7efd9fe462)
* > Related commit: [feat: ✨ Probes: Readiness + Liveness combined](https://github.com/kevencript/kubernetes-core-concepts/commit/9a8a79600b10c0aa11d532a61b67c5e1e36d0a75)

#### 7.3 Startup Probe
A startup probe in Kubernetes is a mechanism to determine if a container has successfully started and initialized. It is particularly useful for slow-starting containers that require additional time to become fully operational. Kubernetes uses the startup probe to monitor the container's initialization process, and once the container passes the startup check, it transitions to liveness and readiness checks, ensuring the application has enough time to initialize before serving traffic.
* > Related commit: [feat: ✨ Probes: Readiness & Liveness solution: StartupProbe](https://github.com/kevencript/kubernetes-core-concepts/commit/02a0d066f3491f3e64c4aec3b50c498e5eb78e19)
* > Related commit: [refactor: ♻️](https://github.com/kevencript/kubernetes-core-concepts/commit/a62bbd15660ba6fe479b2619da2afa5b2322dcaa)

---

## 8 - Horizontal Pod Autoscaling (HPA) 

#### 8.1 - Install Metrics Server
The Metrics Server is a crucial Kubernetes component that collects and stores resource usage metrics such as CPU and memory for nodes and pods within a cluster. It enables efficient resource management, autoscaling, and basic monitoring, helping to ensure that applications scale according to performance demands and making it easier to identify issues.
> Related commit: [feat: ➕ HPA: Installing metrics-server](https://github.com/kevencript/kubernetes-core-concepts/commit/3c2830e89bcb8c0704aa6689e61027c3eb9f8887)

#### 8.2 Resources: Requests and Limits
Resource requests and limits in Kubernetes are essential tools for managing and optimizing the allocation of CPU and memory resources for your containers. Requests define the minimum amount of resources needed for the container to run, while limits set an upper boundary to prevent excessive resource consumption. By carefully configuring requests and limits, you can ensure that your applications run efficiently, maintain high performance, and coexist harmoniously within your cluster.
> Related commit: [feat: ✨ HPA: Resources: Requests and Limits](https://github.com/kevencript/kubernetes-core-concepts/commit/2dccdf575991d4a44ebf62aaba612dde8ab681db)


#### 8.3 HPA: Horizontal Pod Autoscaler
Horizontal Pod Autoscaling (HPA) is a Kubernetes feature that automatically adjusts the number of running pods in a deployment or replica set based on real-time metrics such as CPU utilization or custom metrics. This ensures that your application can scale out to handle increased load and scale in when demand decreases, optimizing resource usage and performance. (Command to perform CPU tests: kubectl run -it fortio --rm --image=fortio/fortio -- load -qps 800 -t 120s -c 70 "http://go-http-app-service/healthz")
* > Related commit: [feat: ✨ HPA: Horizontal Pod Autoscaler](https://github.com/kevencript/kubernetes-core-concepts/commit/86887aac085d6fcd7eda7e9ce9718f3aee7db539)
* > Related commit: [feat: ✨ HPA: Stress test w/ Fortio (Makefile automation)](https://github.com/kevencript/kubernetes-core-concepts/commit/130a44dc0e984121b9cdb386033799c12d14aba6)

---

## 9 - Statefulsets and Persistence

#### 9.1 - Persistent Volume: Claim
A Persistent Volume Claim (PVC) is a Kubernetes resource that allows users to request and consume storage from available Persistent Volumes in the cluster, providing an abstraction layer and efficient storage management for containerized applications.
* > Related commit: [feat: ✨ Persistent Volume: Claim](https://github.com/kevencript/kubernetes-core-concepts/commit/615e356ae5a69cb279aaa7c4b1d9144ee325cabd)
* > Related commit: [refactor: ♻️ Code Refactor: Names and metrics](https://github.com/kevencript/kubernetes-core-concepts/commit/23a46d4782db340eb6e1b63dd3717ab00a356eec)

#### 9.2 Statefulset (Headless MySQL example)
A StatefulSet is a Kubernetes resource used to manage stateful applications, ensuring a stable network identity and stable storage for each of its replicas. When used with a headless service, the StatefulSet allows direct access to each Pod via a unique DNS name, facilitating communication between replicas and enabling service discovery without load balancing or a cluster IP. This combination is commonly employed for applications like databases, which require consistent network identities and persistent storage for data.
> Related commit: [feat: ✨ Statefulset: MySQL example (Headless)](https://github.com/kevencript/kubernetes-core-concepts/commit/c63b8e8d3070094abceb522ca71a0e193740df2b)

---

#### 10 - Ingress
The NGINX Ingress Controller is a popular implementation of the Kubernetes Ingress concept, which provides external access to cluster services by routing incoming HTTP/HTTPS traffic to the appropriate backend services. By leveraging the power of the NGINX reverse proxy and load balancer, the Ingress Controller efficiently manages traffic and allows for custom routing rules and annotations. This enables developers to effectively expose and secure their applications within a Kubernetes cluster, while adhering to best practices for scalability and high availability
* > Related commit: [feat: ➕ Ingress: Install Nginx](https://github.com/kevencript/kubernetes-core-concepts/commit/96097d461273cb8e9416540040813d497b5192ce)
* > Related commit: [feat: ✨ Ingress: Nginx ingress](https://github.com/kevencript/kubernetes-core-concepts/commit/5b3888d2935320025ace1202146952e10b430f63)

--- 

## 11 - CertManager & TLS

#### 11.1 - CertManager
Cert Manager is a Kubernetes-native certificate management solution that automates the issuance, renewal, and management of SSL/TLS certificates for your applications. By integrating with various certificate authorities (CAs) such as Let's Encrypt or self-signed certificates, Cert Manager ensures secure communication between clients and services within a Kubernetes cluster. This simplifies certificate lifecycle management and helps maintain security best practices, allowing developers to focus on building and deploying their applications with confidence.
* > Related commit: [feat: ✨ Cert-Manager: Install](https://github.com/kevencript/kubernetes-core-concepts/commit/6a5757b28d17ac393f4715bab21f21404413357c)

#### 11.2 Adding a ClusterIssuer
A ClusterIssuer is a Kubernetes resource used by Cert-Manager to define a Certificate Authority (CA) for issuing SSL/TLS certificates across the entire cluster. It is a cluster-wide variant of the namespaced Issuer resource. ClusterIssuers streamline certificate management by allowing a single resource to provide certificates to applications in different namespaces, enabling consistent and centralized certificate lifecycle management. By integrating with various CAs, such as Let's Encrypt or by utilizing self-signed certificates, ClusterIssuers ensure that applications within the Kubernetes cluster can secure their communications with clients, promoting best practices for security and reliability.
* > Related commit: [feat: ✨ Cert-Manager: Adding a ClusterIssuer](https://github.com/kevencript/kubernetes-core-concepts/commit/14971742f6400bfef99dff5c1dcba94a3978b7de)
* > Related commit: [refactor: ♻️ Refactoring ingress name](https://github.com/kevencript/kubernetes-core-concepts/commit/108a3e7fdaa255728d0bc96a46f6f9063a5770af)

#### 11.3 TLS
The TLS settings in this file ensure secure communication (HTTPS) between clients and the cluster by leveraging Let's Encrypt as the certificate issuer. We define the "secretName" as the generated secret from ClusterIssuer (cert-manager). We are using an example DNS, this means that the certificate will be issued, but not generated (since the example DNS is not configured to point to our k8s external ip)
> Related commit: [feat: ✨ TLS: Adapt Ingress to TLS configs](https://github.com/kevencript/kubernetes-core-concepts/commit/15d1afe9c0e514e5aee8e9f758bcb788f09c8922)

# to use
> Related commit: []()
> Related commit: []()
> Related commit: []()


