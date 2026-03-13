# claude-code-tools

Various tools supporting the use of Claude Code

## Contents

### 1. gg-marketplace - Custom Plugins and Skills

My marketplace to store self-defined plugins with specific skills for programming.

**Marketplace Configuration:**
- **`.claude-plugin/marketplace.json`** - Defines the marketplace and lists available plugins

**Available Plugins:**
- **write-test** - Custom skill for writing Jest tests for React/React Native components
  - Location: `plugins/react-write-test/`
  - Includes testing best practices and preferred approach

**Documentation:**
- **`SETUP_INSTRUCTIONS.md`** - Complete guide for setting up and using the marketplace

### 2. MCP Configuration - GitHub Integration

**Location:** `mcp/`

Model Context Protocol configuration for GitHub integration:
- **`QUICKSTART.md`** - 3-step quick setup guide (⚡ Start here!)
- **`README.md`** - Complete setup guide with security best practices
- **`github-mcp.json`** - Ready-to-use MCP configuration
- **`set-env-var.sh`** - Bash script for setting environment variable
- **`set-env-var.ps1`** - PowerShell script for setting environment variable
- **`.credentials.example`** - Alternative: template for file-based tokens
- **`update-mcp-credentials.ps1`** - Alternative: PowerShell automation script

**Features:**
- Simple setup using system environment variable
- Secure token management (User-level env var)
- Automated setup scripts (Bash & PowerShell)
- Fine-grained token permissions guide
- Alternative method with `.credentials` file + PowerShell script
- Full documentation for setup and troubleshooting

### 3. Coding Rules

**Location:** `rules/`

Collection of coding rules and best practices for various technologies:
- **`typescript-testing.md`** - Comprehensive testing rules for TypeScript with Jest
  - Given-When-Then pattern
  - Test organization and naming
  - Mock management
  - Type safety in tests
  - And more...

### 4. Project Configuration Templates

**`CLAUDE.md.example`** - Example project configuration file

This template shows how to reference rules from gg-marketplace in your projects:
- Copy to your project root and rename to `CLAUDE.md`
- References TypeScript testing rules
- Includes quick checklist for testing
- Documents active skills and their usage

## Quick Start

### For Plugins:
1. Copy all files (except this README) to your `claude-code-tools` repository
2. Commit and push to GitHub
3. Add marketplace: `claude plugin marketplace add https://github.com/ggrablewski/claude-code-tools`
4. Install plugin: `claude plugin install write-test`
5. Enable plugin: `claude plugin enable write-test`

See [SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md) for detailed steps.

### For MCP (GitHub Integration):
1. Generate GitHub Personal Access Token (fine-grained recommended)
2. Set environment variable in PowerShell:
   ```powershell
   [System.Environment]::SetEnvironmentVariable('GITHUB_PERSONAL_ACCESS_TOKEN', 'YOUR_TOKEN', 'User')
   ```
3. Add `mcpServers` section to your `settings.json` (see [mcp/github-mcp.json](mcp/github-mcp.json))
4. Restart Claude Code

See [mcp/README.md](mcp/README.md) for detailed instructions and alternative methods.

## Repository Structure

```
claude-code-tools/
├── .claude-plugin/
│   └── marketplace.json           # Marketplace manifest
├── plugins/
│   └── react-write-test/          # React testing plugin
│       ├── .claude-plugin/
│       │   └── plugin.json
│       └── skills/
│           └── write-test/
│               └── SKILL.md       # Includes TypeScript testing rules
├── mcp/                           # 🆕 MCP Configuration
│   ├── README.md                  # Complete setup guide
│   ├── QUICKSTART.md              # Quick 3-step setup guide
│   ├── github-mcp.json            # MCP server configuration (env var)
│   ├── set-env-var.sh             # Bash script for setting env variable
│   ├── set-env-var.ps1            # PowerShell script for setting env variable
│   ├── .credentials.example       # Alternative: template for file-based token
│   └── update-mcp-credentials.ps1 # Alternative: credentials management script
├── rules/
│   ├── README.md
│   └── typescript-testing.md      # Comprehensive TypeScript testing rules
├── CLAUDE.md.example              # Template for project configuration
├── settings.json                  # Example settings.json with MCP config
├── README.md
└── SETUP_INSTRUCTIONS.md
```

## Marketplace Details

- **Name:** gg-marketplace
- **Description:** My collection of Claude Code plugins with custom skills for programming
- **Initial Plugin:** write-test (React/React Native testing with Jest)

## MCP Servers

- **GitHub MCP** - Integration with GitHub for repository management, issues, and pull requests
  - Simple setup using system environment variable
  - Secure token management (User-level)
  - Read repositories, create/manage issues, work with PRs
  - Alternative: `.credentials` file + PowerShell script for automation

## Next Steps

### For Plugins:
1. Review `SKILL.md` and customize the testing approach if needed
2. Copy files to your GitHub repository and push to GitHub
3. Follow the setup instructions to add marketplace to Claude Code
4. Copy `CLAUDE.md.example` to your projects (rename to `CLAUDE.md`)
5. Create additional plugins and rules as needed

### For MCP:
1. Generate GitHub Personal Access Token with appropriate permissions
2. Set up environment variable `GITHUB_PERSONAL_ACCESS_TOKEN`
3. Add MCP configuration to `settings.json`
4. Restart Claude Code and test GitHub integration
5. Set up token rotation reminders (recommended: 90 days)

## Usage in Projects

### Using Plugins:

1. **Install the marketplace:**
   ```bash
   claude plugin marketplace add https://github.com/ggrablewski/claude-code-tools
   claude plugin install write-test
   claude plugin enable write-test
   ```

2. **Add project configuration:**
   - Copy `CLAUDE.md.example` to your project root
   - Rename to `CLAUDE.md`
   - Customize for your project needs

3. **Reference rules:**
   - Skills automatically include testing rules
   - For manual reference: https://github.com/ggrablewski/claude-code-tools/blob/main/rules/typescript-testing.md

### Using MCP (GitHub):

Once configured, you can:
- Ask Claude Code to read files from any GitHub repository
- Create and manage issues
- Search across repositories
- Work with pull requests
- And more!

Example queries:
```
Show me the latest commits in ggrablewski/my-project
Create an issue in my-repo with title "Bug: Fix login"
Search for TODO comments in all my repositories
```

For questions or issues, refer to the [Claude Code documentation](https://docs.anthropic.com/claude-code).
