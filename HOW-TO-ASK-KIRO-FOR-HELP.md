# How to Ask Kiro for Help with This Project

## Overview

If you encounter issues or want to continue development on this project, you can ask Kiro (the AI assistant) for help. This guide shows you how to provide context about the project history so Kiro can help you effectively.

---

## Quick Start: Providing Project Context

When you first ask Kiro for help, provide this context:

```
I received a LibreChat project (sakha-client) from a friend. The project has follow-up suggestions feature that was recently fixed. Here's what was done:

1. Fixed React errors (#310 and #300) in the FollowUpSuggestions component
2. Replaced unstable Recoil state with React Hook Form's setValue
3. Moved conditional returns after hooks
4. Removed direct DOM manipulation

The follow-up suggestions now work, but they show 3 hardcoded suggestions instead of AI-generated ones. There's a spec for AI-generated suggestions at .kiro/specs/ai-generated-follow-up-suggestions/ but it's not implemented yet.

Current state:
- LibreChat runs on port 3080
- Uses Groq API (llama-3.3-70b-versatile)
- Follow-up suggestions are clickable and functional
- Suggestions are hardcoded: "Can you explain this in more detail?", "What are some examples?", "How does this work in practice?"

[Your specific question here]
```

---

## Common Scenarios and How to Ask

### Scenario 1: Suggestions Not Appearing

**What to say:**
```
I'm running the LibreChat project (sakha-client) that has follow-up suggestions. The suggestions aren't appearing below AI responses. 

Context:
- The project was recently fixed for React errors #310 and #300
- The fix involved using React Hook Form's setValue instead of Recoil
- File: client/src/components/Chat/Messages/FollowUpSuggestions.tsx

What I've tried:
- Hard refresh (Ctrl+Shift+R)
- Checked browser console - [describe any errors you see]
- Verified containers are running: docker compose ps

Can you help me troubleshoot why suggestions aren't showing?
```

### Scenario 2: Suggestions Not Clickable

**What to say:**
```
The follow-up suggestions appear below AI responses, but clicking them doesn't fill the input box.

Context:
- This was a previous issue that was fixed by using React Hook Form's setValue
- The fix is in: client/src/components/Chat/Messages/FollowUpSuggestions.tsx
- Browser console shows: [paste any errors]

Can you check if the fix was applied correctly or if there's a new issue?
```

### Scenario 3: React Errors in Console

**What to say:**
```
I'm seeing React errors in the browser console:
[Paste the exact error message]

Context:
- This project had React errors #310 (too many re-renders) and #300 (hook ordering) that were fixed
- The fix involved:
  - Using useChatFormContext().setValue instead of useSetRecoilState
  - Moving conditional returns after hooks
  - Removing direct DOM manipulation
- File: client/src/components/Chat/Messages/FollowUpSuggestions.tsx

The error I'm seeing might be related. Can you help me understand what's wrong?
```

### Scenario 4: Want to Implement AI-Generated Suggestions

**What to say:**
```
I want to implement AI-generated contextual follow-up suggestions instead of the current hardcoded ones.

Context:
- Current implementation shows 3 hardcoded suggestions for every response
- There's a requirements document at: .kiro/specs/ai-generated-follow-up-suggestions/requirements.md
- The spec describes having the AI generate 3 contextual questions based on its response
- Design and implementation tasks haven't been created yet

Can you help me:
1. Create the design document
2. Create implementation tasks
3. Implement the feature

Or should we start with just the design?
```

### Scenario 5: Docker Build Fails

**What to say:**
```
Docker build is failing when I try to rebuild the project.

Error message:
[Paste the error]

Context:
- The project uses Docker Compose with multiple services
- Previous fixes included:
  - Adding librechat.yaml mount to docker-compose.yml
  - Removing Infisical dependency from Dockerfile
  - Fixing invalid speech config in librechat.yaml
- I'm trying to rebuild because: [explain why]

Can you help me fix this build error?
```

### Scenario 6: Want to Modify the Suggestions

**What to say:**
```
I want to change the hardcoded follow-up suggestions to different questions.

Context:
- Current suggestions are in: client/src/components/Chat/Messages/FollowUpSuggestions.tsx
- They're defined in a const array: ['Can you explain this in more detail?', ...]
- The component was recently fixed for React errors, so I want to make sure I don't break it

Can you show me how to:
1. Change the suggestion text
2. Add/remove suggestions (currently 3)
3. Rebuild and test the changes
```

### Scenario 7: Understanding the Codebase

**What to say:**
```
I'm new to this LibreChat project and want to understand how the follow-up suggestions feature works.

Context:
- The feature was recently implemented and fixed
- Main component: client/src/components/Chat/Messages/FollowUpSuggestions.tsx
- Integration point: client/src/components/Messages/ContentRender.tsx
- Uses React Hook Form for form state management

Can you explain:
1. How the component renders suggestions
2. How clicking a suggestion fills the input box
3. Why React Hook Form's setValue is used instead of direct DOM manipulation
4. What the previous bugs were and how they were fixed
```

---

## Providing Useful Context

### Always Include:

1. **What you're trying to do**
   - Example: "I'm trying to run the project for the first time"

2. **What's happening (or not happening)**
   - Example: "Suggestions appear but clicking them does nothing"

3. **Error messages (if any)**
   - Copy the exact error from browser console or terminal
   - Include the full stack trace if available

4. **What you've tried**
   - Example: "I tried hard refresh and restarting Docker"

5. **Relevant file paths**
   - Example: "The component is in client/src/components/Chat/Messages/FollowUpSuggestions.tsx"

### Optional but Helpful:

1. **Project history context**
   - Mention that React errors were fixed
   - Mention that suggestions are currently hardcoded

2. **Your environment**
   - Windows version
   - Docker version
   - Browser (Chrome, Firefox, etc.)

3. **Recent changes**
   - If you modified any files, mention what you changed

---

## Example: Complete Help Request

Here's a well-structured help request:

```
Hi Kiro,

I'm working on the LibreChat project (sakha-client) that has follow-up suggestions. I'm trying to implement AI-generated contextual suggestions instead of the hardcoded ones.

**Current State:**
- Follow-up suggestions work correctly (React errors were fixed)
- Shows 3 hardcoded suggestions: "Can you explain this in more detail?", "What are some examples?", "How does this work in practice?"
- Component: client/src/components/Chat/Messages/FollowUpSuggestions.tsx
- Uses React Hook Form's setValue for form state management

**What I Want:**
- AI should generate 3 contextual questions based on its response
- Example: If AI explains code → suggest "Show me an example", "Explain line 5", etc.
- Example: If AI gives a list → suggest "Tell me more about option 1", "Compare these", etc.

**What Exists:**
- Requirements document: .kiro/specs/ai-generated-follow-up-suggestions/requirements.md
- Design and tasks not yet created

**My Question:**
Can you help me create the design document and implementation tasks for this feature? I want to understand:
1. How to modify the AI prompt to generate suggestions
2. How to store suggestions in the message object
3. How to update the frontend component to display AI-generated suggestions
4. How to handle fallback when AI doesn't generate suggestions

I'm comfortable with React and TypeScript, but I'm new to LibreChat's architecture.
```

---

## Tips for Getting Better Help

### ✅ DO:
- Be specific about what you're trying to achieve
- Include error messages and logs
- Mention what you've already tried
- Reference specific files and line numbers
- Ask follow-up questions if something is unclear

### ❌ DON'T:
- Say "it doesn't work" without details
- Skip error messages or logs
- Assume Kiro knows what you changed
- Ask multiple unrelated questions at once
- Expect Kiro to guess your environment or setup

---

## Understanding Kiro's Responses

### When Kiro Asks for More Information
Kiro might ask:
- "Can you share the error message?"
- "What does the browser console show?"
- "Have you tried rebuilding the Docker image?"

**What to do**: Provide the requested information as specifically as possible.

### When Kiro Suggests Reading Files
Kiro might say:
- "Let me read the FollowUpSuggestions component"
- "I'll check the docker-compose.yml file"

**What this means**: Kiro is gathering context to help you better. This is normal.

### When Kiro Provides Code Changes
Kiro will show:
- The file to modify
- The old code (what to replace)
- The new code (what to replace it with)
- Explanation of why the change is needed

**What to do**: 
1. Review the changes carefully
2. Apply them to your files
3. Rebuild if necessary
4. Test the changes
5. Report back if it worked or if you see new issues

---

## Project-Specific Keywords

When asking for help, use these keywords to help Kiro understand the context:

- **"follow-up suggestions"** - The feature we're working on
- **"React error #310"** or **"React error #300"** - The bugs that were fixed
- **"FollowUpSuggestions component"** - The main component
- **"React Hook Form setValue"** - The solution we used
- **"hardcoded suggestions"** - The current limitation
- **"AI-generated suggestions"** - The feature we want to implement
- **"sakha-client"** - The project name
- **"LibreChat"** - The base application

---

## Asking About Specific Files

### To understand a file:
```
Can you explain what this file does?
File: client/src/components/Chat/Messages/FollowUpSuggestions.tsx

I want to understand:
- How it renders suggestions
- How it handles clicks
- Why it uses useChatFormContext
```

### To modify a file:
```
I want to modify this file:
File: client/src/components/Chat/Messages/FollowUpSuggestions.tsx

Current behavior: Shows 3 hardcoded suggestions
Desired behavior: Show 4 suggestions instead of 3

Can you show me what to change?
```

### To debug a file:
```
This file is causing an error:
File: client/src/components/Chat/Messages/FollowUpSuggestions.tsx

Error: [paste error message]

Can you help me debug this?
```

---

## Summary

To get the best help from Kiro:

1. **Start with context**: Mention this is the LibreChat project with follow-up suggestions
2. **Be specific**: Describe exactly what you're trying to do
3. **Include errors**: Copy and paste error messages
4. **Mention what you tried**: Show you've attempted to solve it
5. **Reference files**: Use specific file paths
6. **Ask clear questions**: One main question per request
7. **Follow up**: If Kiro's solution doesn't work, explain what happened

Good luck! Kiro is here to help you succeed with this project. 🚀
