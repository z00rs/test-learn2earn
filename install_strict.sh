#!/bin/bash
set -e

# 🚀 Strict dependency installation script for Learn2Earn VeChain dApp
# Author: Herman Kuzminov
# Created: Oct 28, 2025
# Node.js: v24.7.0 | npm: 11.5.1

echo "🔧 Starting dependency setup for Learn2Earn VeChain dApp..."
echo "📅 $(date)"
echo ""

# 🧠 Check Node.js and npm versions
NODE_VERSION=$(node -v)
NPM_VERSION=$(npm -v)
echo "🧩 Node.js version: $NODE_VERSION"
echo "🧩 npm version: $NPM_VERSION"

if [[ "$NODE_VERSION" != "v24.7.0" ]]; then
  echo "⚠️  WARNING: Recommended Node.js version is v24.7.0 (you have $NODE_VERSION)"
  echo "   Differences in dependency behavior may occur."
  echo ""
fi

# 🧹 Clean previous dependencies and caches
echo "🧹 Cleaning previous dependencies and caches..."
rm -rf node_modules package-lock.json .vite dist
npm cache clean --force
echo ""

# 📦 Install production dependencies
echo "📦 Installing main dependencies..."
npm install --save-exact \
  @vechain/sdk-core@2.0.5 \
  @vechain/sdk-network@2.0.5 \
  @vechain/vechain-kit@1.10.2 \
  ethers@6.15.0 \
  react@18.3.1 \
  react-dom@18.3.1 \
  express@4.21.2 \
  cors@2.8.5 \
  sqlite3@5.1.7 \
  axios@1.12.2 \
  dotenv@16.6.1 \
  buffer@6.0.3 \
  process@0.11.10

# 🧰 Install development dependencies
echo ""
echo "🛠️  Installing development dependencies..."
npm install --save-dev --save-exact \
  vite@5.4.21 \
  @vitejs/plugin-react@4.7.0 \
  hardhat@2.26.3 \
  @nomicfoundation/hardhat-toolbox@4.0.0 \
  @vechain/sdk-hardhat-plugin@1.2.0 \
  @types/react@18.3.26 \
  @types/react-dom@18.3.7 \
  crypto-browserify@3.12.1 \
  http-browserify@1.7.0 \
  https-browserify@1.0.0 \
  os-browserify@0.3.0 \
  stream-browserify@3.0.0 \
  url@0.11.4 \
  util@0.12.5

echo ""
echo "✅ All dependencies installed successfully!"
echo ""

# 🔍 Verify installed versions
echo "📋 Verifying installed packages..."
npm list --depth=0 || echo "⚠️  Packages installed, but some peer dependencies may be missing."

echo ""
echo "🎯 Next steps:"
echo "1️⃣ Create a clean .env file (without comments)."
echo "2️⃣ Deploy your contract and paste its address into VITE_CONTRACT_ADDRESS."
echo "3️⃣ Start the backend: npm run server"
echo "4️⃣ Start the frontend: npm run dev"
echo ""
echo "🎉 Done! Your environment is now identical to the original working setup."