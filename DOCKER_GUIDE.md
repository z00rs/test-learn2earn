# Learn2Earn Docker Development Guide

## Setup Process Overview

### For New Users (First Time Setup):
1. Clone repository
2. Run `./setup.sh`
3. Fill environment variables step by step
4. Deploy smart contracts
5. Launch application

### For Returning Users:
1. Run `./start.sh` (validates configuration automatically)

## Environment Variables Required

### Step 1: Before Contract Deployment
```bash
VECHAIN_PRIVATE_KEY=0x...                  # Your VeChain testnet private key
VITE_WALLETCONNECT_PROJECT_ID=...          # From Reown.com
MODERATOR_KEY=your-secure-key              # For moderator operations
VEBETTERDAO_APP_ID=...                     # From VeBetterDAO registration
```

### Step 2: After Contract Deployment
```bash
VITE_CONTRACT_ADDRESS=0x...                # Filled automatically by setup script
```

## Docker Architecture

### Containers:
- **Backend**: Node.js 20 + Express + SQLite + Hardhat (full dependencies)
- **Frontend**: React build → nginx production server
- **Network**: Isolated Docker network for container communication
- **Volumes**: Persistent SQLite database storage

### Ports:
- Frontend: `localhost:3000` (nginx serves React build)
- Backend API: `localhost:3001` (Express server)
- Internal communication: backend:3001 (within Docker network)

## Development Commands

### Initial Setup:
```bash
./setup.sh                                 # Interactive setup process
```

### Quick Start:
```bash
./start.sh                                 # Start with existing configuration
```

### Manual Docker Operations:
```bash
# Build specific service
docker compose build backend
docker compose build frontend

# Run one-off commands
docker compose run --rm backend npm run compile
docker compose run --rm backend npm run deploy:testnet

# Container management
docker compose up -d                       # Start in background
docker compose down                        # Stop and remove containers
docker compose logs -f                     # Follow all logs
docker compose logs backend                # Backend logs only
```

### Development Workflow:
1. Make code changes
2. Run `docker compose up --build -d` to rebuild and restart
3. Test application at `localhost:3000`
4. Use `docker compose logs` to debug issues

## Troubleshooting

### Common Issues:

1. **"Contract compilation failed"**
   - Ensure VECHAIN_PRIVATE_KEY is set in .env
   - Check if hardhat.config.cjs has correct network settings

2. **"Environment not configured"**
   - Run `./setup.sh` for guided configuration
   - Verify all required environment variables are set

3. **"Frontend not loading"**
   - Check if containers are running: `docker compose ps`
   - View frontend logs: `docker compose logs frontend`
   - Ensure port 3000 is not occupied by other services

4. **"API calls failing"**
   - Check backend logs: `docker compose logs backend`
   - Verify backend is running on port 3001
   - Check nginx proxy configuration

### Reset Everything:
```bash
docker compose down
docker system prune -f                     # Remove unused containers/images
rm .env                                     # Remove configuration
./setup.sh                                 # Start fresh setup
```

## Production Deployment

For production deployment:
1. Use environment-specific `.env` files
2. Configure proper SSL certificates for nginx
3. Set up proper database backups for SQLite volume
4. Use Docker secrets for sensitive data
5. Implement proper logging and monitoring