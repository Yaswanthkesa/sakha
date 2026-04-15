# Setup Guide for New User

## Prerequisites

Before you start, make sure you have:

1. **Windows PC** (this project was developed on Windows)
2. **Docker Desktop** installed and running
3. **WSL 2** (Windows Subsystem for Linux) installed
4. **Git** (if you want to pull updates)
5. **At least 10 GB free disk space** (Docker images are large)

---

## Step 1: Install Docker Desktop and WSL 2

### Install WSL 2

1. Open PowerShell as Administrator
2. Run:
   ```powershell
   wsl --install
   ```
3. Restart your computer
4. Verify installation:
   ```powershell
   wsl --version
   ```
   You should see version 2.x.x or higher

### Install Docker Desktop

1. Download Docker Desktop from: https://www.docker.com/products/docker-desktop/
2. Run the installer
3. Follow the installation wizard
4. Restart your computer if prompted
5. Start Docker Desktop
6. Verify installation:
   ```bash
   docker --version
   docker compose version
   ```

---

## Step 2: Extract the Project Folder

1. Extract the `sakha-client` folder you received
2. Place it somewhere accessible (e.g., `C:\Users\YourName\Desktop\sakha-client`)
3. Open the folder in your terminal or file explorer

---

## Step 3: Verify Project Files

Make sure these key files exist:
```
sakha-client/
├── .env                          # Environment variables (Groq API key)
├── librechat.yaml                # LibreChat configuration
├── docker-compose.yml            # Docker services configuration
├── Dockerfile                    # Docker build instructions
├── package.json                  # Node.js dependencies
└── client/                       # Frontend code
    └── src/
        └── components/
            └── Chat/Messages/
                └── FollowUpSuggestions.tsx  # Fixed component
```

---

## Step 4: Start the Application

### Option 1: Using the Provided Script (Easiest)

1. Open the `sakha-client` folder
2. Double-click `START-LIBRECHAT.bat`
3. Wait for the containers to start (~2-3 minutes first time)
4. Open your browser to: http://localhost:3080

### Option 2: Manual Commands

1. Open PowerShell or Command Prompt
2. Navigate to the project folder:
   ```bash
   cd path\to\sakha-client
   ```
3. Start all containers:
   ```bash
   docker compose up -d
   ```
4. Wait for containers to start (~2-3 minutes)
5. Check if containers are running:
   ```bash
   docker compose ps
   ```
   You should see 5 containers running:
   - LibreChat (api)
   - chat-mongodb
   - chat-meilisearch
   - vectordb
   - rag_api

6. Open your browser to: http://localhost:3080

---

## Step 5: Create an Account

1. Go to http://localhost:3080
2. Click "Sign Up" or "Register"
3. Create an account with:
   - Email: any email (doesn't need to be real)
   - Password: your choice
   - Name: your name
4. Click "Sign Up"
5. You'll be logged in automatically

---

## Step 6: Test the Follow-Up Suggestions

1. In the chat interface, ask any question:
   - Example: "What is React?"
2. Wait for the AI to respond
3. Look below the AI response for follow-up suggestions
4. You should see 3 suggestion buttons:
   - "Can you explain this in more detail?"
   - "What are some examples?"
   - "How does this work in practice?"
5. Click any suggestion
6. The suggestion text should fill the input box
7. Press Enter or click Send to ask the follow-up question

**Expected Behavior:**
- ✅ Suggestions appear below AI responses
- ✅ Clicking a suggestion fills the input box
- ✅ Send button remains enabled
- ✅ No errors in browser console (F12)

---

## Troubleshooting

### Problem: Docker Desktop won't start

**Solution:**
1. Make sure WSL 2 is installed: `wsl --version`
2. Restart Docker Desktop
3. Check Windows Services: Docker Desktop Service should be running
4. Try restarting your computer

### Problem: "Port 3080 is already in use"

**Solution:**
1. Check what's using port 3080:
   ```bash
   netstat -ano | findstr :3080
   ```
2. Stop the process or change the port in `.env`:
   ```
   PORT=3081
   ```
3. Restart containers:
   ```bash
   docker compose down
   docker compose up -d
   ```

### Problem: Containers won't start

**Solution:**
1. Check Docker is running: `docker --version`
2. Check logs:
   ```bash
   docker compose logs api
   ```
3. Try stopping and restarting:
   ```bash
   docker compose down
   docker compose up -d
   ```
4. If still failing, try a clean rebuild:
   ```bash
   docker compose down
   docker compose build api --no-cache
   docker compose up -d
   ```

### Problem: Suggestions don't appear

**Solution:**
1. Hard refresh the browser: `Ctrl + Shift + R`
2. Clear browser cache
3. Check browser console (F12) for errors
4. Make sure you're looking at the latest AI message (suggestions only show on the most recent response)

### Problem: Clicking suggestions does nothing

**Solution:**
1. Check browser console (F12) for React errors
2. If you see React error #300 or #310, the fix wasn't applied correctly
3. Try rebuilding:
   ```bash
   cd sakha-client
   npm run frontend
   docker compose restart api
   ```
4. Hard refresh browser: `Ctrl + Shift + R`

### Problem: "npm: command not found" when trying to rebuild

**Solution:**
You don't need Node.js installed locally! Everything runs in Docker.
- Use the provided `.bat` scripts instead
- Or just restart Docker containers: `docker compose restart api`

---

## Useful Commands

### Start the application
```bash
docker compose up -d
```

### Stop the application
```bash
docker compose down
```

### Restart the application
```bash
docker compose restart api
```

### View logs
```bash
docker compose logs api -f
```

### Check container status
```bash
docker compose ps
```

### Rebuild after code changes
```bash
docker compose down
docker compose build api
docker compose up -d
```

### Quick restart (no rebuild)
```bash
docker compose restart api
```

---

## Understanding the Project Structure

### Frontend (React + TypeScript)
- **Location**: `sakha-client/client/src/`
- **Key Component**: `components/Chat/Messages/FollowUpSuggestions.tsx`
- **What it does**: Displays follow-up suggestion buttons below AI responses

### Backend (Node.js + Express)
- **Location**: `sakha-client/api/`
- **What it does**: Handles API requests, manages conversations, communicates with Groq AI

### Configuration Files
- **`.env`**: Environment variables (API keys, ports, etc.)
- **`librechat.yaml`**: LibreChat configuration (AI models, endpoints, etc.)
- **`docker-compose.yml`**: Docker services configuration

### Database
- **MongoDB**: Stores conversations, messages, users
- **MeiliSearch**: Search functionality
- **PostgreSQL + pgvector**: Vector database for RAG (Retrieval Augmented Generation)

---

## What's Working

✅ LibreChat runs successfully on port 3080
✅ Groq API integration (llama-3.3-70b-versatile model)
✅ Follow-up suggestions appear below AI responses
✅ Clicking suggestions fills the input box
✅ Send button remains functional
✅ No React errors in console
✅ Conversations are saved to MongoDB
✅ User authentication works

---

## What's Not Yet Implemented

❌ AI-generated contextual suggestions (currently shows 3 hardcoded suggestions)
❌ MCP server connections (admin-server, faq-server) - not critical
❌ Custom JWT secrets (using defaults - fine for local development)

---

## Performance Expectations

### First Startup
- **Time**: 2-3 minutes
- **Why**: Docker needs to download images (~2-3 GB)

### Subsequent Startups
- **Time**: 30 seconds
- **Why**: Images are cached, just starting containers

### AI Response Time
- **Time**: 1-5 seconds
- **Why**: Depends on Groq API and question complexity

### Frontend Build (if needed)
- **Time**: 2-5 minutes
- **Why**: Compiling TypeScript, bundling assets

---

## Getting Help

### If you encounter issues:

1. **Check the logs**:
   ```bash
   docker compose logs api -f
   ```

2. **Read the troubleshooting guide**: `PROJECT-HISTORY-AND-FIXES.md`

3. **Ask Kiro for help**: See `HOW-TO-ASK-KIRO-FOR-HELP.md`

4. **Check Docker status**:
   ```bash
   docker compose ps
   ```

5. **Try a clean restart**:
   ```bash
   docker compose down
   docker compose up -d
   ```

---

## Next Steps

Once you have the application running:

1. **Explore the interface**: Try different questions and see how the AI responds
2. **Test follow-up suggestions**: Click the suggestion buttons and see how they work
3. **Read the project history**: Check `PROJECT-HISTORY-AND-FIXES.md` to understand what was fixed
4. **Experiment with modifications**: Try changing the hardcoded suggestions in `FollowUpSuggestions.tsx`
5. **Learn about the AI-generated suggestions feature**: Read `.kiro/specs/ai-generated-follow-up-suggestions/requirements.md`

---

## Important Notes

1. **This is a development setup**: Not suitable for production use
2. **API keys are included**: The Groq API key is in `.env` - keep it private
3. **Data is local**: All conversations are stored locally in Docker volumes
4. **No internet required** (except for AI API calls): Once Docker images are downloaded, you can work offline (but AI won't work without internet)

---

## Summary

To run this project:
1. Install Docker Desktop and WSL 2
2. Extract the project folder
3. Run `docker compose up -d` in the project folder
4. Open http://localhost:3080
5. Create an account and start chatting

The follow-up suggestions feature is working with 3 hardcoded suggestions. AI-generated contextual suggestions are planned but not yet implemented.

Enjoy using LibreChat! 🎉
