# Setup Instructions for gg-marketplace

## Overview
The setup of my personal Claude Code marketplace with custom plugins and skills.

## Repository Structure

The `claude-code-tools` repository should have this structure:

```
claude-code-tools/
├── .claude-plugin/
│   └── marketplace.json               # Marketplace manifest (required)
├── plugins/
│   └── react-write-test/              # Plugin name
│       ├── .claude-plugin/
│       │   └── plugin.json            # Plugin manifest
│       └── skills/
│           └── write-test/
│               └── SKILL.md           # Skill definition
└── README.md
```

## Adding Marketplace to Claude Code

Adding the marketplace to Claude Code:

```bash
claude plugin marketplace add https://github.com/ggrablewski/claude-code-tools
```

## Verifying Marketplace

List your configured marketplaces:

```bash
claude plugin marketplace list
```

## Installing Plugins

For example, istall the `write-test` plugin:

```bash
claude plugin install write-test
```

or use the fully qualified name:

```bash
claude plugin install write-test@gg-marketplace
```

## Enabling Plugins

Enable the plugin in your settings:

```bash
claude plugin enable write-test
```

or manually edit `~/.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "write-test@gg-marketplace": true
  }
}
```

## Using the Skill

The `write-test` skill is now available. You can invoke it:

1. **By asking Claude to write tests:**
   ```
   "Write tests for the component: ..."
   "Create test coverage for all components"
   "Add tests using my preferred approach"
   ```

2. **By invoking the skill directly:**
   ```
   /write-test
   ```

## Adding More Plugins

To add more plugins to your marketplace:

1. **Create plugins in the plugins directory:**
   ```
   plugins/
     react-write-test/
     react-another-skill/
     nodejs-api-test/
   ```

2. **Create plugin structure with .claude-plugin/plugin.json:**
   ```
   plugins/plugin-name/
   ├── .claude-plugin/
   │   └── plugin.json
   └── skills/
       └── skill-name/
           └── SKILL.md
   ```

   **plugin.json** (in `.claude-plugin/` directory):
   ```json
   {
     "name": "plugin-name",
     "version": "1.0.0",
     "description": "Plugin description",
     "author": {
       "name": "Your Name",
       "email": "your.email@example.com"
     }
   }
   ```

   **Note:** Skills are automatically discovered from the `skills/` directory structure. You don't need to declare them in plugin.json.

3. **Update marketplace.json:**
   ```json
   {
     "plugins": [
       {
         "name": "plugin-name",
         "description": "Plugin description",
         "version": "1.0.0",
         "source": "./plugins/plugin-name",
         "category": "testing",
         "tags": ["relevant", "tags"]
       }
     ]
   }
   ```

4. **Commit and push changes**

5. **Update marketplace in Claude Code:**
   ```bash
   claude plugin marketplace update gg-marketplace
   ```

## Troubleshooting

### Marketplace Not Found Error
```
✘ Failed to add marketplace: Marketplace file not found
```

**Solution:** Ensure `.claude-plugin/marketplace.json` exists in the root of your repository.

### Plugin Not Found Error
```
✘ Plugin 'write-test' not found in any marketplace
```

**Solution:**
1. Verify the plugin `source` path in `marketplace.json` is correct
2. Update marketplace: `claude plugin marketplace update gg-marketplace`

### Skill Not Triggering

**Solution:**
1. Ensure plugin is enabled in settings
2. Check skill description in SKILL.md frontmatter - it should describe when to trigger
3. Use `/write-test` to invoke directly

## Plugin Categories

Available categories for `marketplace.json`:
- `development` - Development tools
- `productivity` - Productivity plugins
- `security` - Security tools
- `learning` - Learning resources
- `design` - Design tools
- `testing` - Testing frameworks and tools
- `database` - Database tools
- `deployment` - Deployment automation
- `monitoring` - Monitoring and observability

## Best Practices

1. **Skill Descriptions:** Write clear, specific trigger conditions in the YAML frontmatter
2. **Progressive Disclosure:** Structure SKILL.md with headers for easy navigation
3. **Examples:** Include code examples that Claude can reference
4. **Versioning:** Update version numbers when making changes
5. **Testing:** Test skills locally before pushing to ensure they trigger correctly

## Files in This Setup

- **`.claude-plugin/marketplace.json`** - Marketplace manifest defining available plugins
- **`plugins/react-write-test/.claude-plugin/plugin.json`** - Plugin manifest (basic metadata)
- **`plugins/react-write-test/skills/write-test/SKILL.md`** - Skill documentation with YAML frontmatter

**Important:** Skills are automatically discovered from the directory structure. You don't need to manually declare them in plugin.json.
