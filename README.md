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

### 2. Coding Rules

**Location:** `rules/`

Collection of coding rules and best practices for various technologies:
- **`typescript-testing.md`** - Comprehensive testing rules for TypeScript with Jest
  - Given-When-Then pattern
  - Test organization and naming
  - Mock management
  - Type safety in tests
  - And more...

## Quick Start

1. Copy all files (except this README) to your `claude-code-tools` repository
2. Commit and push to GitHub
3. Add marketplace: `claude plugin marketplace add https://github.com/ggrablewski/claude-code-tools`
4. Install plugin: `claude plugin install write-test`
5. Enable plugin: `claude plugin enable write-test`

See [SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md) for detailed steps.

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
│               └── SKILL.md
├── rules/
│   ├── README.md
│   └── typescript-testing.md      # TypeScript testing rules
├── README.md
└── SETUP_INSTRUCTIONS.md
```

## Marketplace Details

- **Name:** gg-marketplace
- **Description:** My collection of Claude Code plugins with custom skills for programming
- **Initial Plugin:** write-test (React/React Native testing with Jest)

## Next Steps

1. Review `SKILL.md` and customize the testing approach if needed
2. Copy files to your GitHub repository
3. Follow the setup instructions
4. Create additional plugins as needed

For questions or issues, refer to the [Claude Code documentation](https://docs.anthropic.com/claude-code).
