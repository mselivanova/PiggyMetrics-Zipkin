# PiggyMetrics with Zipkin on Kubernetes cluster

**Background stuff**
 
[PiggyMetrics](https://github.com/sqshq/PiggyMetrics)  |  [Zipkin](https://zipkin.io/) | [Kubernetes](https://kubernetes.io/)

**Tutorial for learning the basics of deploying an app to Kubernetes in the cloud**

https://developer.okta.com/blog/2019/04/01/spring-boot-microservices-with-kubernetes

**If you want to build Zipkin docker image yourself:**

`cd zipkin`

`./zipkin_install.sh`

This will download zipkin.jar and build Eureka-module

`docker build` your new zipkin-image

**For deployment on Kubernetes instances that do not support LoadBalancer service type:**

(An example of such Kubernetes instance is the one that is provided with Docker Desktop)

In `kubernetes/4-gateway-service.yaml`:
- uncomment line 12
- comment out line 15
- uncomment line 21

**Create one yaml file for all services and deployments**

`cd kubernetes`

`kubectl kustomize > piggy_kube.yaml`

**Configure AWS CLI**

This is not a comprehensive guide, but rather a reminder and some useful command:

`aws configure`

`aws eks --region <region> update-kubeconfig --name <cluster_name>`

To change between kubectl contexts:

`kubectl config get-contexts`

`kubectl config use-context <context-name>`

**Deploy to Kubernetes**

Make sure you have created a cluster and a node to deploy to. Your node should have at least 6Gb RAM.

`kubectl apply -f piggy_kube.yaml`

## Verifying status on local instance of Kubernetes

Gateway: http://localhost:30080

Hystrix: http://localhost:31090/hystrix

Eureka: http://localhost:30082

Zipkin: http://localhost:30081

## Verifying status on AWS

(Remember to add an inbound rule to your security group allowing traffic to your NodePort-ports from the outside)

`kubectl get services` - find external IP of your gateway service

`kubectl describe node` - find external IP of your node

Gateway: http://<Service_External_IP>

Hystrix: http://<Node_External_IP>:31090/hystrix

Eureka: http://<Node_External_IP>:30082

Zipkin: http://<Node_External_IP>:30081

## Credit

[sqshq/PiggyMetrics](https://github.com/sqshq/PiggyMetrics)

[afermon/PiggyMetrics-Kubernetes](https://github.com/afermon/PiggyMetrics-Kubernetes)