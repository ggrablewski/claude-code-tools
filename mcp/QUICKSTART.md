# GitHub MCP - Quick Start Guide

Quick GitHub MCP configuration for Claude Code in 3 steps.

## Step 1: Generate GitHub Token

1. Go to: https://github.com/settings/tokens?type=beta
2. Click **"Generate new token"**
3. Configure:
   - **Token name**: Claude Code MCP
   - **Repository access**: All repositories
   - **Permissions**:
     - Contents: Read-only ✓
     - Issues: Read and write ✓
     - Metadata: Read-only ✓
4. Click **"Generate token"** and copy the token

## Step 2: Set Environment Variable

Open PowerShell and run:

```powershell
[System.Environment]::SetEnvironmentVariable('GITHUB_PERSONAL_ACCESS_TOKEN', 'PASTE_TOKEN_HERE', 'User')
```

Replace `PASTE_TOKEN_HERE` with your token from step 1.

**Alternative**: Use the provided script:

Bash:
```bash
./set-env-var.sh YOUR_GITHUB_TOKEN_HERE
```

PowerShell:
```powershell
.\set-env-var.ps1 YOUR_GITHUB_TOKEN_HERE
```

## Step 3: Add MCP Configuration

Edit `C:\Users\USERNAME\.claude\settings.json` and add the `mcpServers` section:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_PERSONAL_ACCESS_TOKEN}"
      }
    }
  }
}
```

**Note**: If you already have other configurations in `settings.json`, simply add the `mcpServers` section inside the main JSON object.

## Step 4: Restart Claude Code

Close and restart Claude Code.

## Test

Ask Claude Code:

```
Show me the latest commits in the repository ggrablewski/claude-code-tools
```

## Done! 🎉

GitHub MCP is now configured. You can:
- Read files from repositories
- Create and manage issues
- Search in code
- Work with pull requests

## Need More Information?

See [README.md](./README.md) for:
- Detailed documentation
- Alternative configuration methods
- Troubleshooting
- Security best practices

---

**Setup time**: ~2 minutes
**Difficulty**: Easy ⭐
