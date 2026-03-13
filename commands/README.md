# GitHub Issues Commands

This directory contains custom Claude Code commands for working with GitHub issues.

## Available Commands

### `/get-issues-all`
Reads all issues (open and closed) from the GitHub repository matching the current directory name.

**Usage:**
```bash
cd memory-game-mobile
/get-issues-all
```

### `/get-issues-open`
Reads only open issues from the GitHub repository matching the current directory name.

**Usage:**
```bash
cd memory-game-mobile
/get-issues-open
```

## How It Works

Both commands:
1. Automatically detect the repository name from your current directory
2. Fetch your GitHub username
3. List issues from that repository
4. Display a formatted summary

## Setup

These commands are referenced from `.claude/plugins/github-issues/commands/` via symbolic link, so you can edit them here in `claude-code-tools/commands/` and the changes will be immediately available in Claude Code.
