#!/bin/bash
# Script to install Docker and run SonarQube + Nexus on same Azure VM (Ubuntu 22.04)

set -e

echo "=============================================="
echo "🚀 Starting installation of Docker, SonarQube, and Nexus3"
echo "=============================================="

################################################################################################
# 1️⃣ Update & Install Docker
################################################################################################
sudo apt update -y
sudo apt install -y docker.io

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Allow current user to run Docker without sudo
sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock

################################################################################################
# 2️⃣ Create Docker Volumes for Persistent Data
################################################################################################
echo "📦 Creating persistent volumes for Nexus and SonarQube..."
sudo docker volume create nexus-data
sudo docker volume create sonar-data
sudo docker volume create sonar-extensions
sudo docker volume create sonar-logs

################################################################################################
# 3️⃣ Run Nexus Container
################################################################################################
echo "🧩 Starting Nexus Repository Server on port 8081..."
sudo docker run -d \
  --name nexus-server \
  -p 8081:8081 \
  -v nexus-data:/nexus-data \
  --restart always \
  sonatype/nexus3

################################################################################################
# 4️⃣ Run SonarQube Container
################################################################################################
echo "🧠 Starting SonarQube Server on port 9000..."
sudo docker run -d \
  --name sonar-server \
  -p 9000:9000 \
  -v sonar-data:/opt/sonarqube/data \
  -v sonar-extensions:/opt/sonarqube/extensions \
  -v sonar-logs:/opt/sonarqube/logs \
  --restart always \
  sonarqube:latest

################################################################################################
# 5️⃣ Display Status
################################################################################################
echo "=============================================="
echo "✅ Installation complete!"
echo "🌐 Nexus available at:  http://<VM-IP>:8081"
echo "🌐 SonarQube available at: http://<VM-IP>:9000"
echo "🧱 Nexus volume: nexus-data"
echo "🧱 Sonar volumes: sonar-data, sonar-extensions, sonar-logs"
echo "=============================================="

# Wait a few seconds before checking container status
sleep 10
sudo docker ps
