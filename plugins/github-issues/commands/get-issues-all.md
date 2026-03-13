---
name: get-issues-all
description: Read all issues from the GitHub repository matching the current directory name
args: []
---

Please read all issues from my GitHub repository. The repository name should be determined from directories with git changes.

Steps:
1. Use git status in each direct subdirectory of the current directory to find all changed files using: `for dir in */; do [ -d "$dir/.git" ] && echo "=== $dir ===" && git -C "$dir" status -s; done`
2. Extract the names of subdirectories where modified files are located
3. Fetch my GitHub username using the mcp__github__get_me tool
4. For each subdirectory with changes, list all issues (both open and closed) from the corresponding GitHub repository using the mcp__github__list_issues tool with:
   - Repository name matching the subdirectory name (without trailing slash)
   - My username as owner
5. Display a summary of all issues for each repository with their numbers, titles, states, labels, and creation dates
