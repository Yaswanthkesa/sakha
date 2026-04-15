# ⚡ Faster Development Workflow

## The Problem
Running the full rebuild (`docker compose down; npm run frontend; docker compose build api; docker compose up -d`) takes **5-10 minutes** every time.

## The Solution
Use different scripts based on what you changed!

---

## 📁 Available Scripts

### 1. **QUICK-RESTART.bat** ⚡ (~30 seconds)
```bash
docker compose restart api
```
- Just restarts containers
- No code changes
- Fastest option

### 2. **FRONTEND-ONLY-UPDATE.bat** 🎯 (~3-5 minutes)
```bash
npm run frontend
docker compose restart api
```
- **USE THIS for the follow-up suggestions bug!**
- Changed React/UI code only
- 50% faster than full rebuild

### 3. **REBUILD-DOCKER-WITH-SUGGESTIONS.bat** 🔨 (~5-10 minutes)
```bash
npm run frontend
docker compose down
docker compose build api
docker compose up -d
```
- Changed backend code
- Changed dependencies
- Full rebuild with cache

### 4. **FULL-REBUILD.bat** 🔥 (~5-10 minutes)
```bash
npm run frontend
docker compose down
docker compose build api --no-cache
docker compose up -d
```
- Everything is broken
- Need clean slate
- Last resort

---

## 🎯 For Your Current Bug Fix

Since the follow-up suggestions clicking issue is a **frontend bug**, use:

### Windows (CMD):
```bash
cd sakha-client
FRONTEND-ONLY-UPDATE.bat
```

### Windows (PowerShell):
```powershell
cd sakha-client
.\FRONTEND-ONLY-UPDATE.ps1
```

### Manual (if you prefer):
```bash
cd sakha-client
npm run frontend
docker compose restart api
```

Then open http://localhost:3080 and press **Ctrl+Shift+R** to hard refresh.

---

## 💡 Time Savings

| Scenario | Old Way | New Way | Time Saved |
|----------|---------|---------|------------|
| Frontend change | 10 min | 3-5 min | **5-7 min** |
| Just restart | 10 min | 30 sec | **9.5 min** |
| Backend change | 10 min | 10 min | Same |

---

## 🔍 How to Know What Changed?

### Frontend Changes (Use FRONTEND-ONLY-UPDATE):
- Files in `client/src/`
- React components (`.tsx`, `.jsx`)
- Styles (`.css`, `.scss`)
- Frontend utilities

### Backend Changes (Use REBUILD-DOCKER):
- Files in `api/`
- Server code (`.js` in api/)
- Database models
- API routes

### Dependency Changes (Use REBUILD-DOCKER):
- `package.json`
- `package-lock.json`

### Docker Changes (Use FULL-REBUILD):
- `Dockerfile`
- `docker-compose.yml`

---

## 🚨 Troubleshooting

### "Changes not showing up?"
1. Make sure you ran the right script
2. Hard refresh browser: **Ctrl+Shift+R**
3. Clear browser cache
4. Check Docker logs: `docker compose logs api -f`

### "Still not working?"
Try the full rebuild:
```bash
FULL-REBUILD.bat
```

### "Want to see what's happening?"
```bash
docker compose logs api -f
```

---

## 📝 Summary

**Answer to your question:** 
> "Do we need to run the full rebuild every time?"

**NO!** For frontend changes (like the suggestions bug), use:
```bash
FRONTEND-ONLY-UPDATE.bat
```

This is **50% faster** (3-5 min instead of 10 min) and works for all React/UI changes! 🚀
