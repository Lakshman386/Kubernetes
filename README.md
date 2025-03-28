# Automated DevOps Deployment for Pet Shop Application

![image](https://github.com/user-attachments/assets/c638fba0-1e28-4f0e-aa0f-4d91196ab198)

## 📌 Project Overview
This project automates the deployment of the **Pet Shop Application** using DevOps best practices. The setup includes **version control, CI/CD pipelines, containerization, and Kubernetes orchestration** to ensure seamless deployments.

## 🎯 Objectives
- Automate deployment with **Bash scripts**.
- Implement a **CI/CD pipeline** for continuous integration and delivery.
- Utilize **Docker** for containerization.
- Deploy and manage **Kubernetes clusters** for scalability.
- Implement **Infrastructure as Code (IaC)** for automated provisioning.

## 🏗️ Deployment Process

### 🔹 Prerequisites
- GitHub, Docker Hub, and AWS accounts.
- EC2 instances for:
  - **Jenkins Master**
  - **Jenkins Agent**
  - **EKS Cluster Machine**

### 🔹 Jenkins Master Setup
```bash
sudo wget -O /etc/yum.repos.d/Jenkins.repo \ 
  https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo yum install fontconfig java-17-openjdk
sudo yum install jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
```
- Access Jenkins UI: `http://<jenkins-master-ip>:8080`
- Install required plugins:
  - Git
  - Maven Integration
  - Docker Pipeline
  - Kubernetes CLI

### 🔹 Jenkins Agent Setup
```bash
sudo yum install git maven -y
sudo yum install java-17-openjdk -y
sudo yum install docker -y
```
- **SSH Setup for Agent**
```bash
ssh-keygen -t rsa -b 4096
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
sudo systemctl restart sshd
```

## ⚙️ CI/CD Pipeline

### 📌 Job 1 - Build & Push Docker Image
1. Jenkins pulls the latest code from GitHub.
2. Runs tests and builds the application.
3. Builds a **Docker image** and pushes it to Docker Hub.

```bash
# deployment.sh
#!/bin/bash
git clone <repo_url> || (cd <repo_name> && git pull)
docker build -t my-app:latest .
docker tag my-app:latest my-dockerhub-repo/my-app:latest
docker push my-dockerhub-repo/my-app:latest
```

![image](https://github.com/user-attachments/assets/a3ffc91d-332b-4742-8b5a-c0331ecce643)
![image](https://github.com/user-attachments/assets/8ec283d5-a71d-43a0-922d-8824ecf33852)

### 📌 Job 2 - Kubernetes Deployment
1. Pulls the latest Kubernetes **deployment YAML**.
2. Applies the updated **Kubernetes configuration**.

```bash
# k8-deploy.sh
#!/bin/bash
git clone <repo_url> || (cd <repo_name> && git pull)
kubectl apply -f deployment.yaml
```

![image](https://github.com/user-attachments/assets/da72978d-bb8c-49fc-8a0a-f00e993c4e5f)
![image](https://github.com/user-attachments/assets/0437fb27-6d2b-42a7-a154-af126712dd53)

## 📜 Infrastructure Overview
- **EC2 instances** for Jenkins, Agent, and EKS setup.
- **Security configurations & IAM roles**.
- **Load Balancer for smooth application access**.

## 🛠️ Technologies Used
- **Jenkins** for CI/CD Automation
- **Docker** for Containerization
- **SonarQube** for Code Quality Analysis
- **Kubernetes (EKS)** for Orchestration
- **GitHub** for Version Control
- **AWS** for Cloud Infrastructure

## 📢 Contributing
Feel free to submit **pull requests** for improvements!

## 📧 Contact
For queries, reach out via **[email@gmail.com](mailto:lakshminarayanas386@gmail.com)**.

---
🚀 **End-to-End DevOps CI/CD Automation for Scalable Deployments!**
