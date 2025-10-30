#!/bin/bash

echo "🚀 Learn2Earn VeChain dApp - Step-by-Step Docker Setup"
echo "======================================================"

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
echo ""

# Step 1: Environment setup
echo "📋 Step 1: Environment Configuration"
echo "===================================="

if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        cp .env.example .env
        echo "✅ Created .env file from template"
    else
        echo "❌ .env.example file not found!"
        exit 1
    fi
else
    echo "✅ .env file already exists"
fi

echo ""
echo "🔧 Please edit the .env file with your configuration:"
echo "   - VECHAIN_PRIVATE_KEY: Your VeChain private key"
echo "   - MODERATOR_KEY: Your secret moderator key"
echo "   - VEBETTERDAO_APP_ID: Your VeBetterDAO app ID"
echo "   - Leave VITE_CONTRACT_ADDRESS empty for now"
echo ""
read -p "Press Enter when you have configured the .env file..."

# Step 2: Build backend for contract operations
echo ""
echo "🔨 Step 2: Building Backend Container"
echo "===================================="
docker compose build backend
if [ $? -ne 0 ]; then
    echo "❌ Failed to build backend container"
    exit 1
fi
echo "✅ Backend container built successfully"

# Step 3: Contract operations
echo ""
echo "📜 Step 3: Smart Contract Deployment"
echo "===================================="

echo "Compiling contracts..."
docker compose run --rm backend npm run compile
if [ $? -ne 0 ]; then
    echo "❌ Contract compilation failed"
    exit 1
fi

echo "Deploying contract to testnet..."
docker compose run --rm backend npm run deploy:testnet
if [ $? -ne 0 ]; then
    echo "❌ Contract deployment failed"
    exit 1
fi

echo "Registering app with VeBetterDAO..."
docker compose run --rm backend npm run register:app
if [ $? -ne 0 ]; then
    echo "❌ App registration failed"
    exit 1
fi

echo "Updating app configuration..."
docker compose run --rm backend npm run update:app
if [ $? -ne 0 ]; then
    echo "❌ App update failed"
    exit 1
fi

echo "✅ Smart contract deployment completed"

# Step 4: Contract address update
echo ""
echo "📝 Step 4: Update Contract Address"
echo "=================================="
echo "Please check the deployment output above and update your .env file:"
echo "   - Set VITE_CONTRACT_ADDRESS to the deployed contract address"
echo ""
read -p "Press Enter when you have updated the contract address in .env..."

# Step 5: Launch full application
echo ""
echo "🚀 Step 5: Launching Full Application"
echo "====================================="
docker compose up --build -d

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Learn2Earn dApp is now fully deployed!"
    echo "📱 Frontend: http://localhost:3000"
    echo "🖥️  Backend API: http://localhost:3001"
    echo ""
    echo "📊 To view logs: docker compose logs -f"
    echo "🛑 To stop: docker compose down"
    echo ""
    echo "🎯 Your dApp is ready for testing!"
else
    echo "❌ Failed to start containers"
    echo "Check the logs with: docker compose logs"
    exit 1
fi