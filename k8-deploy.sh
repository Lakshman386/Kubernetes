#!/bin/bash

# Exit on any error
set -e

# Repository details
REPO_URL="https://github.com/Lakshman386/pet_shop.git"
BRANCH="main"
DEPLOYMENT_FILE="/home/ec2-user/test/pet_shop/deploymentservice.yaml"
TARGET_DIR="/home/ec2-user/test"

echo "Starting Kubernetes deployment process..."

# Check if the target directory exists
if [ ! -d "${TARGET_DIR}" ]; then
    echo "Directory ${TARGET_DIR} not found. Exiting."
    exit 1
fi

# Navigate to the target directory
cd ${TARGET_DIR}

# Clone the repository if it doesn't exist
if [ ! -d "pet_shop" ]; then
    echo "Cloning repository..."
    git clone -b ${BRANCH} ${REPO_URL} || { echo "Git clone failed"; exit 1; }
else
    echo "Repository already exists. Pulling latest changes..."
    cd pet_shop
    git pull || { echo "Git pull failed"; exit 1; }
    cd ..
fi

# Apply the Kubernetes deployment
echo "Applying Kubernetes deployment..."
sudo kubectl apply -f ${DEPLOYMENT_FILE} --validate=false || { echo "Kubernetes deployment failed"; exit 1; }

echo "Kubernetes deployment completed successfully."