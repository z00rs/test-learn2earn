#!/bin/bash

# Learn2Earn VeChain dApp - Quick Start Script
echo "🚀 Starting Learn2Earn VeChain dApp..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed!"
    echo "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Check if Docker Compose is available
if ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not available!"
    echo "Please update to a newer version of Docker Desktop"
    exit 1
fi

echo "✅ Docker is installed and ready"

# Check if .env file exists and is configured
if [ ! -f .env ]; then
    echo "❌ .env file not found!"
    echo "Please run ./setup.sh first for step-by-step configuration"
    exit 1
fi

# Check if critical environment variables are set
if ! grep -q "VECHAIN_PRIVATE_KEY=.*[^[:space:]]" .env || ! grep -q "VITE_CONTRACT_ADDRESS=.*[^[:space:]]" .env; then
    echo "❌ Environment file is not properly configured!"
    echo "Missing VECHAIN_PRIVATE_KEY or VITE_CONTRACT_ADDRESS"
    echo "Please run ./setup.sh for step-by-step configuration"
    exit 1
fi

# Build and start containers
echo "🔨 Building and starting containers..."
docker compose up --build -d

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Learn2Earn dApp is now running!"
    echo "📱 Frontend: http://localhost:3000"
    echo "🖥️  Backend API: http://localhost:3001"
    echo ""
    echo "📊 To view logs: docker compose logs -f"
    echo "🛑 To stop: docker compose down"
else
    echo "❌ Failed to start containers"
    echo "Check the logs with: docker compose logs"
    exit 1
fi