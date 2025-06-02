#!/bin/bash

# Ensure BUILD_NUMBER is provided
if [ -z "$BUILD_NUMBER" ]; then
  echo "Error: BUILD_NUMBER is not set."
  exit 1
fi

# Repository details
GIT_REPO_URL="https://github.com/Lakshman386/pet_shop.git"
GIT_BRANCH="main"

# Sensitive credentials (use environment variables or a secret manager)
GIT_USERNAME="Lakshman386"
GIT_PERSONAL_ACCESS_TOKEN="token"
DOCKER_USERNAME="lakshman386"
DOCKER_PASSWORD="<Docker passwed>"

# Step 1: Git Checkout
echo "Checking out the repository..."
if [ -d "pet_shop" ]; then
  echo "Directory 'pet_shop' already exists. Pulling latest changes..."
  cd pet_shop || { echo "Error: Failed to change directory to pet_shop."; exit 1; }
  git reset --hard
  git clean -fd
  git pull origin main || { echo "Error: Failed to pull latest changes."; exit 1; }
else
  git clone --branch main ${GIT_REPO_URL} || { echo "Error: Failed to clone repository."; exit 1; }
  cd pet_shop || { echo "Error: Failed to change directory to pet_shop."; exit 1; }
fi

# Step 2: Update Deployment YAML
echo "Updating deployment YAML..."
sed -i "s|image: .*|image: lakshman386/pet_shop:${BUILD_NUMBER}|" deploymentservice.yaml || {
  echo "Error: Failed to update deployment YAML."
  exit 1
}

# Step 3: Push Changes to GitHub
echo "Configuring Git user..."
git config --global user.name "Lakshminarayana"
git config --global user.email "Lakshminarayana@gmail.com"

echo "Pushing updated YAML file to GitHub..."
git add deploymentservice.yaml || { echo "Error: Failed to stage updated YAML file."; exit 1; }
git commit -m "Update deployment.yaml with image: lakshman386/pet_shop:${BUILD_NUMBER}" || {
  echo "Error: Failed to commit changes. Perhaps no changes were made?"
  exit 1
}
git push https://${GIT_USERNAME}:${GIT_PERSONAL_ACCESS_TOKEN}@${GIT_REPO_URL#https://} "$GIT_BRANCH" || {
  echo "Error: Failed to push changes to GitHub."
  exit 1
}

# Step 4: Maven Build
echo "Building the project with Maven..."
mvn clean install || { echo "Error: Maven build failed."; exit 1; }

# Step 5: Remove Existing Docker Container and Image
echo "Removing existing Docker container and image..."
sudo docker rm -f my-cont || true
sudo docker rmi lakshman386/pet_shop:${BUILD_NUMBER} || true

# Step 6: Build and Push Docker Image
echo "Building and pushing Docker image..."
docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD} || {
  echo "Error: Docker login failed."
  exit 1
}
docker build -t lakshman386/pet_shop:${BUILD_NUMBER} . || {
  echo "Error: Docker build failed."
  exit 1
}
docker push lakshman386/pet_shop:${BUILD_NUMBER} || {
  echo "Error: Docker push failed."
  exit 1
}

echo "Script execution completed successfully."
