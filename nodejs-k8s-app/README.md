
# Node.js Kubernetes Deployment

This repository demonstrates how to create a simple Node.js application, containerize it using Docker, and deploy it to a Kubernetes cluster. It also outlines the steps to troubleshoot OOMKilled errors when the application pod crashes due to excessive memory consumption.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Dockerfile](#dockerfile)
- [Kubernetes Deployment](#kubernetes-deployment)
- [Steps to Deploy](#steps-to-deploy)
- [Troubleshooting OOMKilled Error](#troubleshooting-oomkilled-error)
- [Root Cause Analysis (RCA)](#root-cause-analysis-rca)

## Prerequisites
- Docker
- Kubernetes (Minikube, AKS, GKE, etc.)
- kubectl
- DockerHub account (optional)


## Steps to Deploy

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/nodejs-k8s-app.git
   cd nodejs-k8s-app
   ```

2. **Build the Docker Image**:
   ```bash
   docker build -t jiaulhaque/nodejs-k8s-app:latest .
   ```

3. **Push the Image to DockerHub** (optional):
   ```bash
   docker push jiaulhaque/nodejs-k8s-app:latest
   ```

4. **Apply the Kubernetes Deployment**:
   ```bash
   kubectl apply -f deployment.yaml
   ```

5. **Check the Status of Pods and Services**:
   ```bash
   kubectl get pods
   kubectl get svc
   ```

6. **Access the Application**:
   After applying the manifest, you can access the application via the external IP provided by the LoadBalancer service:
   ```
   http://<External-IP>
   ```

7. **Test the Application**:
   To intentionally cause an OOMKilled error, visit:
   ```
   http://<External-IP>/crash
   ```

## Troubleshooting OOMKilled Error

When the pod crashes with `OOMKilled`, follow these diagnostic steps:

### Step 1: Check Pod Status
```bash
kubectl get pods
```

### Step 2: Describe the Pod
```bash
kubectl describe pod <pod-name>
```
Look for the `OOMKilled` reason in the `Last State` section.

### Step 3: View Logs
```bash
kubectl logs <pod-name>
```
Examine the logs for memory exhaustion errors.

### Step 4: Check Kubernetes Events
```bash
kubectl get events --sort-by='.lastTimestamp'
```
Review the events to identify resource-related issues.

### Step 5: Check Resource Usage (If Pod is Running)
```bash
kubectl top pod <pod-name>
```

Check the node resource usage:
```bash
kubectl top node
```

## Root Cause Analysis (RCA)

### What Happened?
The pod was terminated because it exceeded the memory limit of `256Mi` and was killed with the `OOMKilled` error.

### Why Did It Happen?
The `/crash` endpoint in the Node.js application was intentionally designed to consume excessive memory, triggering the Kubernetes OOMKill behavior.

### Mitigation Strategies
- **Increase memory limits** in the Kubernetes deployment if the application requires more memory.
- **Fix memory leaks** in the application (e.g., remove the `/crash` endpoint or optimize memory usage).
- **Monitor memory usage** using tools like Prometheus and Grafana to get early alerts on memory issues.
- **Set resource requests and limits** in Kubernetes to prevent other applications from being impacted by memory usage spikes.

## Conclusion

This project demonstrates how to build and deploy a simple Node.js application to Kubernetes. It also shows how to troubleshoot and analyze an `OOMKilled` error caused by excessive memory consumption. 

For future improvements, consider setting proper resource requests and limits in the Kubernetes deployment to optimize memory usage and avoid similar issues.
```