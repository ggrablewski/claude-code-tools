# claude-code-tools
Various tools supporting the use of Claude Code

## gg-marketplace Files

My marketplace to store my self-defined plugins with specific skills

### Marketplace Configuration
- **`.claude-plugin/marketplace.json`** - Defines the marketplace and lists available plugins

### Example Plugin: write-test
- **`plugins/react-js/write-test/plugin.json`** - Plugin manifest
- **`plugins/react-js/write-test/skills/write-test/SKILL.md`** - Skill definition - with testing preferences

### Documentation
- **`SETUP_INSTRUCTIONS.md`** - Complete guide for adding these files to GitHub and using the marketplace

## Quick Start

1. Copy all files (except this README) to your `claude-code-tools` repository
2. Commit and push to GitHub
3. Add marketplace: `claude plugin marketplace add https://github.com/ggrablewski/claude-code-tools`
4. Install plugin: `claude plugin install write-test`
5. Enable plugin: `claude plugin enable write-test`

See [SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md) for detailed steps.

## File Structure to Copy

```
.claude-plugin/
  marketplace.json
plugins/
  react-js/
    write-test/
      plugin.json
      skills/
        write-test/
          SKILL.md
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
