# Automated DevOps Deployment for Pet Shop Application

## Overview
This project automates the deployment of the **Pet Shop Application** using DevOps best practices, including CI/CD pipelines, containerization with Docker, and Kubernetes orchestration.

## Objectives
- Automate the deployment process using **Bash scripts**.
- Implement a **CI/CD pipeline** with Jenkins.
- Utilize **Docker** for containerization.
- Deploy and manage Kubernetes clusters on **AWS EKS**.
- Implement **Infrastructure as Code (IaC)** for provisioning.

## Requirements
### Prerequisites
- GitHub, Docker Hub, and AWS accounts.
- AWS EC2 instances:
  - **Jenkins Master**
  - **Agent Machine**
  - **EKS Machine**
- Recommended: **t3.medium instances with 15GB RAM** (for practice only; adjust for production).

## Setup & Configuration
### 1. Jenkins Master Server
- Install Jenkins:
  ```sh
  sudo wget -O /etc/yum.repos.d/Jenkins.repo \ 
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
  sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
  sudo yum upgrade
  sudo yum install fontconfig java-17-openjdk
  sudo yum install jenkins
  sudo systemctl daemon-reload
  sudo systemctl enable jenkins
  sudo systemctl start jenkins
  ```
- Open Jenkins UI: `http://<your-server-ip>:8080`
- Install required plugins:
  - Git, Maven Integration, Docker Pipeline, Kubernetes CLI, etc.

### 2. Agent Machine Setup
- Install dependencies:
  ```sh
  sudo yum install git maven -y
  sudo yum install java-17-openjdk -y
  sudo yum install docker -y
  ```
- Configure SSH authentication:
  ```sh
  sudo vim /etc/ssh/sshd_config  # Enable PubkeyAuthentication
  sudo systemctl restart sshd
  ssh-keygen -t rsa
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
  ```

### 3. Master-Slave Configuration
- In Jenkins:
  - **Manage Jenkins** → **Manage Nodes and Clouds**
  - Add a new node (**Jenkins-Agent**), set executors to **2**.
  - Use SSH for connection (provide private key credentials).
  - Verify agent is connected.

## CI/CD Pipeline Implementation
### 1. Create `deployment.sh`
```sh
#!/bin/bash
BUILD_NUMBER=$1
REPO_URL="git@github.com:yourrepo/petshop.git"
DEPLOYMENT_YAML="k8s/deployment.yaml"

# Clone repository
if [ ! -d "petshop" ]; then
  git clone $REPO_URL
else
  cd petshop && git pull origin main
fi

# Update Docker image version in deployment YAML
sed -i "s|image: petshop:.*|image: petshop:$BUILD_NUMBER|g" $DEPLOYMENT_YAML

docker build -t petshop:$BUILD_NUMBER .
docker tag petshop:$BUILD_NUMBER your-dockerhub-repo/petshop:$BUILD_NUMBER
docker push your-dockerhub-repo/petshop:$BUILD_NUMBER
```

### 2. Jenkins Job-1: Build & Push Docker Image
- **Trigger**: On GitHub push.
- **Steps**:
  - Clone the repository.
  - Build and push Docker image.

### 3. Jenkins Job-2: Kubernetes Deployment
- Create `k8-deploy.sh`:
```sh
#!/bin/bash
kubectl apply -f k8s/deployment.yaml
```
- **Trigger**: After Job-1 succeeds.

## Kubernetes Deployment on AWS EKS
- Install and configure **kubectl** and **AWS CLI**.
- Deploy application:
  ```sh
  kubectl apply -f k8s/deployment.yaml
  kubectl get pods -n petshop
  ```

## Conclusion
This project automates the full DevOps deployment lifecycle for the **Pet Shop Application**, ensuring efficiency, reliability, and scalability using **Jenkins, Docker, and Kubernetes**.

## Technologies Used
- **Jenkins** (CI/CD)
- **Docker** (Containerization)
- **Kubernetes** (Orchestration on AWS EKS)
- **GitHub** (Version Control)
- **AWS EC2** (Infrastructure)

---
