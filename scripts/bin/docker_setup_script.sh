#!/bin/bash

echo "🐳 Setting up Docker permissions"
echo "============================================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Add user to docker group
echo "1. Adding user to docker group..."
sudo usermod -aG docker $USER
echo "✅ User $USER added to docker group"

# Start Docker service
echo "2. Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker
echo "✅ Docker service started and enabled"

# Check Docker service status
echo "3. Checking Docker service status..."
if sudo systemctl is-active --quiet docker; then
    echo "✅ Docker service is running"
else
    echo "❌ Docker service failed to start"
    sudo systemctl status docker
    exit 1
fi

echo ""
echo "🔄 IMPORTANT: You need to log out and log back in for group changes to take effect!"
echo ""
echo "After logging back in, run these commands:"
echo "  docker ps                     # Test Docker access"
echo "  docker-compose up --build     # Start your app"
echo ""
echo "Alternatively, you can run 'newgrp docker' to apply changes in current terminal."
