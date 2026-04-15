# Quick Guide: When to Use Which Script

## 🚀 QUICK-RESTART.bat (~30 seconds)
**Use when:**
- Just restarting the app
- No code changes
- Containers are acting weird

**Command:**
```bash
docker compose restart api
```

---

## ⚡ FRONTEND-ONLY-UPDATE.bat (~3-5 minutes)
**Use when:**
- Changed React/TypeScript files in `client/src/`
- Changed UI components
- Changed styling/CSS
- **This is what you need for the follow-up suggestions bug fix!**

**Command:**
```bash
npm run frontend
docker compose restart api
```

**After running:** Press `Ctrl+Shift+R` in browser to hard refresh

---

## 🔨 REBUILD-DOCKER-WITH-SUGGESTIONS.bat (~5-10 minutes)
**Use when:**
- Changed backend code in `api/`
- Changed dependencies (package.json)
- First time setting up

**Command:**
```bash
npm run frontend
docker compose down
docker compose build api
docker compose up -d
```

---

## 🔥 FULL-REBUILD.bat (~5-10 minutes, no cache)
**Use when:**
- Something is completely broken
- Need a clean slate
- Changed Dockerfile or docker-compose.yml
- Last resort when nothing else works

**Command:**
```bash
npm run frontend
docker compose down
docker compose build api --no-cache
docker compose up -d
```

---

## 📋 Quick Decision Tree

```
Did you change code?
├─ NO → Use QUICK-RESTART.bat
└─ YES → What did you change?
    ├─ Frontend only (React/UI) → Use FRONTEND-ONLY-UPDATE.bat ⚡
    ├─ Backend (API/server) → Use REBUILD-DOCKER-WITH-SUGGESTIONS.bat
    └─ Everything is broken → Use FULL-REBUILD.bat
```

---

## 💡 Pro Tips

1. **For the follow-up suggestions bug**: Use `FRONTEND-ONLY-UPDATE.bat` since it's a React component issue

2. **Browser cache**: Always do a hard refresh after updates:
   - Windows: `Ctrl + Shift + R`
   - Or: `Ctrl + F5`

3. **Check if it's running**:
   ```bash
   docker compose ps
   ```

4. **View logs if something fails**:
   ```bash
   docker compose logs api -f
   ```

5. **Stop everything**:
   ```bash
   docker compose down
   ```

---

## 🎯 For Your Current Issue (Suggestions Not Clicking)

Since this is a **frontend bug** (React component), use:

```bash
FRONTEND-ONLY-UPDATE.bat
```

This will:
1. Rebuild the frontend with the fix (~3 min)
2. Restart the container (~30 sec)
3. Total: ~3-5 minutes instead of 10 minutes!
