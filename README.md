# PiggyMetrics with Zipkin on Kubernetes cluster

**If you want to build Zipkin docker image yourself:**

`cd zipkin`

`./zipkin_install.sh`

This will download zipkin.jar and build Eureka-module

`docker build` your new zipkin-image

**For deployment on Kubernetes instances that do not support LoadBalancer service type:**

In `kubernetes/4-gateway-service.yaml`:
- uncomment line 12
- comment out line 15
- uncomment line 21

**Create one yaml file for all services and deployments**

`cd kubernetes`

`kubectl kustomize > piggy_kube.yaml`

**Deploy to Kubernetes**

Make sure you have created a cluster and a node to deploy to.

`kubectl apply -f piggy_kube.yaml`

## Verifying status on local instance of Kubernetes

Gateway: http://localhost:30080

Hystrix: http://localhost:31090/hystrix

Eureka: http://localhost:30082

Zipkin: http://localhost:30081

## Verifying status on AWS

`kubectl get services` - find external IP of your gateway service

`kubectl describe node` - find external IP of your node

Gateway: http://<Service_External_IP>

Hystrix: http://<Node_External_IP>:31090/hystrix

Eureka: http://<Node_External_IP>:30082

Zipkin: http://<Node_External_IP>:30081