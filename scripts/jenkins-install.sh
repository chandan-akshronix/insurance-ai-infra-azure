#!/bin/bash
# Jenkins Dev Environment Setup Script for Azure (Ubuntu 22.04)
# Installs Jenkins, Docker, Maven, Azure CLI, and Trivy (without kubectl)

set -e

################################################################################################
# 1️⃣ System Update & Install Java (Required for Jenkins)
################################################################################################
echo "🔄 Updating system and installing Java..."
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y openjdk-17-jre unzip curl wget gnupg ca-certificates apt-transport-https software-properties-common lsb-release

################################################################################################
# 2️⃣ Jenkins Installation
################################################################################################
echo "⚙️ Installing Jenkins..."
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/" | \
sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update -y
sudo apt install -y jenkins

# Allow Jenkins user to run sudo without password
echo "jenkins ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

################################################################################################
# 3️⃣ Docker Installation
################################################################################################
echo "🐳 Installing Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add Jenkins user to Docker group
sudo usermod -aG docker jenkins
sudo chmod 666 /var/run/docker.sock

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

################################################################################################
# 4️⃣ Maven Installation
################################################################################################
echo "📦 Installing Maven..."
sudo apt install -y maven

################################################################################################
# 5️⃣ Azure CLI Installation
################################################################################################
echo "☁️ Installing Azure CLI..."
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Optional: Login message
echo "🔑 To authenticate ACR or Azure services later, run: az login"

################################################################################################
# 6️⃣ Trivy Installation (Vulnerability Scanner)
################################################################################################
echo "🔍 Installing Trivy (Container Security Scanner)..."
sudo apt-get install -y wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | \
  sudo tee /etc/apt/sources.list.d/trivy.list
sudo apt-get update -y
sudo apt-get install -y trivy

################################################################################################
# 7️⃣ Enable & Start Jenkins
################################################################################################
echo "🚀 Starting Jenkins..."
sudo systemctl enable jenkins
sudo systemctl restart jenkins

################################################################################################
# 8️⃣ Show Jenkins Admin Password
################################################################################################
echo "=================================================================================="
echo "✅ Jenkins Dev Server setup complete on Azure!"
echo "🌐 Access Jenkins at: http://<Your-VM-Public-IP>:8080"
echo "🔑 Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo "=================================================================================="
