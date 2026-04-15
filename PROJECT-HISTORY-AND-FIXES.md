# Project History and Fixes

## Overview
This document explains all the issues we encountered while setting up LibreChat (sakha-client) and how we fixed them. This will help you understand the project state and troubleshoot if you encounter similar issues.

---

## Issue 1: Follow-Up Suggestions Not Displaying (React Errors)

### Problem Description
When we first implemented the follow-up suggestions feature, the suggestions were visible on screen but clicking them did nothing. The browser console showed two critical React errors:

**Error #310**: "Too many re-renders" - React was stuck in an infinite re-render loop
**Error #300**: "Rendered more hooks than during the previous render" - Hook ordering was unstable

### Root Causes

#### 1. Unstable Hook Dependencies
```typescript
// BUGGY CODE:
const setText = useSetRecoilState(store.text);  // Unstable reference
const handleClick = useCallback((suggestion) => {
  setText(suggestion);
}, [setText]);  // setText changes on every render → infinite loop
```

**Why this caused the error:**
- `useSetRecoilState` returns a setter function that isn't guaranteed to be stable across renders
- Using it in `useCallback` dependencies caused the callback to be recreated on every render
- This triggered React's infinite re-render protection (Error #310)

#### 2. Conditional Return Before Hooks
```typescript
// BUGGY CODE:
const FollowUpSuggestions = ({ isCreatedByUser, isLatestMessage }) => {
  const setText = useSetRecoilState(store.text);
  
  // Early return BEFORE hooks - violates Rules of Hooks
  if (isCreatedByUser || !isLatestMessage) {
    return null;
  }
  
  const handleClick = useCallback(...);  // Hook called conditionally
};
```

**Why this caused the error:**
- React's Rules of Hooks require hooks to be called in the same order on every render
- When the condition changed, the number of hooks changed between renders
- This caused Error #300 (rendered more hooks than previous render)

#### 3. Direct DOM Manipulation
```typescript
// BUGGY CODE:
const textarea = document.getElementById('prompt-textarea');
textarea.value = suggestion;  // Bypasses React Hook Form
textarea.dispatchEvent(new Event('input'));  // Manual event
```

**Why this caused problems:**
- LibreChat uses React Hook Form to manage the textarea
- Direct DOM manipulation bypassed the form's controlled state
- Form state and DOM state became out of sync
- Send button got disabled because form didn't recognize the value

### The Fix

**File**: `sakha-client/client/src/components/Chat/Messages/FollowUpSuggestions.tsx`

```typescript
// FIXED CODE:
const FollowUpSuggestions = ({ messageId, isLatestMessage, isCreatedByUser }) => {
  // ✅ Use React Hook Form's stable setValue method
  const { setValue } = useChatFormContext();
  
  const handleSuggestionClick = useCallback((suggestion) => {
    // ✅ Use form's setValue - stable and proper
    setValue('text', suggestion, { shouldValidate: true });
    
    // ✅ Keep focus and cursor positioning (valid DOM operations)
    const textarea = document.getElementById('prompt-textarea');
    if (textarea) {
      textarea.focus();
      textarea.setSelectionRange(suggestion.length, suggestion.length);
    }
  }, [setValue]);  // ✅ Stable dependency
  
  // ✅ Conditional return AFTER hooks - maintains stable hook ordering
  if (isCreatedByUser || !isLatestMessage) {
    return null;
  }
  
  return (/* JSX */);
};
```

**What changed:**
1. ✅ Replaced `useSetRecoilState(store.text)` with `useChatFormContext().setValue`
2. ✅ Moved conditional return AFTER all hook calls
3. ✅ Removed direct DOM manipulation of `textarea.value`
4. ✅ Removed manual event dispatching
5. ✅ Used React Hook Form's `setValue` with `shouldValidate: true`
6. ✅ Updated `useCallback` dependency to use stable `[setValue]`

**Result:**
- ✅ No more React errors
- ✅ Suggestions are clickable and functional
- ✅ Send button remains enabled
- ✅ Form state properly synchronized

---

## Issue 2: Suggestions Are Hardcoded (Not AI-Generated)

### Current State
The follow-up suggestions currently show the same 3 hardcoded questions for every AI response:
- "Can you explain this in more detail?"
- "What are some examples?"
- "How does this work in practice?"

### Why This Happens
The current implementation uses a static array of suggestions:

```typescript
// Current implementation:
const suggestions = [
  'Can you explain this in more detail?',
  'What are some examples?',
  'How does this work in practice?',
];
```

### Future Enhancement (Not Yet Implemented)
We created a spec for AI-generated contextual suggestions at:
`.kiro/specs/ai-generated-follow-up-suggestions/`

This feature would:
- Have the AI generate 3 contextual questions based on its response
- Store suggestions in the message object
- Display AI-generated suggestions instead of hardcoded ones
- Fall back to generic suggestions if AI doesn't generate any

**Status**: Requirements document created, design and implementation pending.

---

## Issue 3: Docker Image Source (Critical for Code Changes)

### Problem
The original `docker-compose.yml` was configured to pull a pre-built Docker image from GitHub Container Registry:

```yaml
# ORIGINAL (WRONG):
services:
  api:
    image: ghcr.io/danny-avila/librechat:latest  # ❌ Pulls from GitHub
```

**Why this was a problem:**
- Docker downloaded LibreChat's official image from GitHub
- This image contained their code, not our modified code
- Our follow-up suggestions fix wasn't included in the GitHub image
- When we ran the application, it used the old code without our fixes
- React errors persisted because our fixes weren't in the running container

### The Fix

Changed `docker-compose.yml` to build the Docker image locally from our code:

```yaml
# FIXED (CORRECT):
services:
  api:
    build:                    # ✅ Build from local code
      context: .              # Use current directory
      dockerfile: Dockerfile  # Use our Dockerfile
```

**What this means:**
- Docker now builds the image from our local source code
- All our changes (including the FollowUpSuggestions fix) are included
- The running container uses our modified code
- React errors are fixed because our corrected code is in the image

**Why this was critical:**
Without this change, none of our code fixes would have worked! The application would still have the React errors because it was using the old code from GitHub.

**For your friend:**
When she runs `docker compose up -d` for the first time, Docker will build the image from the local code (~8-12 minutes). This ensures she gets the version with all our fixes included.

See `DOCKER-IMAGE-EXPLANATION.md` for detailed information about this change.

---

## Issue 4: Docker Configuration Issues

### Problem
Initial Docker setup had several configuration issues that prevented LibreChat from running.

### Fixes Applied

#### 1. Missing librechat.yaml Mount
**Problem**: Docker compose wasn't mounting the config file
**Fix**: Added volume mount in `docker-compose.yml`:
```yaml
volumes:
  - type: bind
    source: ./librechat.yaml
    target: /app/librechat.yaml
```

#### 2. Invalid Speech Configuration
**Problem**: Invalid `speechToText` config caused startup errors
**Fix**: Removed invalid config from `librechat.yaml`

#### 3. Unreachable vLLM Endpoint
**Problem**: Config referenced unreachable vLLM server
**Fix**: Replaced with Groq API configuration in `librechat.yaml`

#### 4. Infisical Dependency in Dockerfile
**Problem**: Dockerfile CMD used `infisical` which wasn't needed
**Fix**: Changed CMD to direct `npm run backend` in `Dockerfile`

---

## Technical Stack

### Frontend
- **Framework**: React 18 with TypeScript
- **Build Tool**: Vite
- **State Management**: Recoil
- **Form Management**: React Hook Form
- **Styling**: Tailwind CSS
- **UI Components**: Radix UI, Headless UI

### Backend
- **Runtime**: Node.js 20
- **Framework**: Express.js
- **Database**: MongoDB 8.0.17
- **Search**: MeiliSearch 1.12.3
- **Vector DB**: PostgreSQL with pgvector
- **RAG API**: LibreChat RAG API

### Infrastructure
- **Containerization**: Docker & Docker Compose
- **AI Provider**: Groq API (llama-3.3-70b-versatile)

---

## File Structure

### Key Files Modified
```
sakha-client/
├── client/src/components/
│   ├── Chat/Messages/
│   │   └── FollowUpSuggestions.tsx          # Main component (FIXED)
│   └── Messages/
│       └── ContentRender.tsx                 # Integration point
├── docker-compose.yml                        # Docker config (FIXED)
├── Dockerfile                                # Build config (FIXED)
├── librechat.yaml                            # LibreChat config (FIXED)
├── .env                                      # Environment variables
└── .kiro/specs/
    ├── follow-up-suggestions-fix/            # Bugfix spec (COMPLETED)
    │   ├── bugfix.md
    │   ├── design.md
    │   └── tasks.md
    └── ai-generated-follow-up-suggestions/   # Feature spec (PENDING)
        └── requirements.md
```

---

## Build and Deployment Process

### What Happens When You Build

1. **Frontend Build** (`npm run frontend`):
   - Builds all packages: data-provider, data-schemas, api, client
   - Compiles TypeScript to JavaScript
   - Bundles with Vite (production mode)
   - Generates optimized assets (~13 MB total)
   - Takes ~2-5 minutes

2. **Docker Build** (`docker compose build api`):
   - Uses Node.js 20 Alpine base image
   - Installs dependencies
   - Copies source code
   - Runs frontend build inside container
   - Creates production image
   - Takes ~5-10 minutes

3. **Container Startup** (`docker compose up -d`):
   - Starts MongoDB, MeiliSearch, PostgreSQL, RAG API
   - Starts LibreChat API server
   - Server listens on port 3080
   - Takes ~30 seconds

---

## Performance Notes

### Build Times
- **Frontend only**: 2-5 minutes
- **Full Docker rebuild**: 5-10 minutes
- **Quick restart**: 30 seconds

### Bundle Sizes
- **Main bundle**: 1.66 MB (gzipped: 436 KB)
- **Vendor bundle**: 3.43 MB (gzipped: 962 KB)
- **Total assets**: ~13 MB

### Runtime Performance
- **Initial page load**: ~2-3 seconds
- **AI response time**: Depends on Groq API (typically 1-5 seconds)
- **Suggestion click**: Instant (no network call)

---

## Known Limitations

1. **Suggestions are hardcoded**: Same 3 suggestions for every response (AI-generated suggestions not yet implemented)
2. **MCP server errors**: Admin and FAQ MCP servers fail to connect (not critical, doesn't affect core functionality)
3. **Security warnings**: Using default JWT secrets (should be changed in production)
4. **npm vulnerabilities**: 63 vulnerabilities in dependencies (mostly dev dependencies, not critical for local use)

---

## Next Steps (Future Enhancements)

1. **Implement AI-generated suggestions**: Complete the spec at `.kiro/specs/ai-generated-follow-up-suggestions/`
2. **Update security secrets**: Generate new JWT secrets for production
3. **Fix MCP server connections**: Configure or disable admin/FAQ MCP servers
4. **Update dependencies**: Run `npm audit fix` to address vulnerabilities
5. **Optimize bundle size**: Implement code splitting for large chunks

---

## Debugging Tips

### If suggestions don't appear:
1. Check browser console (F12) for React errors
2. Hard refresh: `Ctrl + Shift + R`
3. Check if component is rendering: Look for "Follow-up:" label
4. Verify message is from AI and is the latest message

### If suggestions don't work when clicked:
1. Check browser console for errors
2. Verify React Hook Form context is available
3. Check if textarea has id="prompt-textarea"
4. Test with browser dev tools: `document.getElementById('prompt-textarea')`

### If Docker build fails:
1. Check Docker is running: `docker --version`
2. Check disk space: Docker images are large (~2-3 GB)
3. Try clean build: `docker compose build api --no-cache`
4. Check logs: `docker compose logs api`

### If server won't start:
1. Check port 3080 is available: `netstat -ano | findstr :3080`
2. Check all containers are running: `docker compose ps`
3. Check logs: `docker compose logs api -f`
4. Restart containers: `docker compose restart api`

---

## Summary

We successfully fixed the follow-up suggestions feature by:
1. Replacing unstable Recoil state with React Hook Form's stable `setValue`
2. Moving conditional returns after hooks to maintain stable hook ordering
3. Removing direct DOM manipulation in favor of proper form state management
4. Fixing Docker configuration issues

The feature now works correctly with 3 hardcoded suggestions. AI-generated contextual suggestions are planned but not yet implemented.
