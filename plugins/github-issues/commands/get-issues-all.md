---
name: get-issues-all
description: Read all issues from the GitHub repository matching the current directory name
args: []
---

Please read all issues from my GitHub repository. The repository name should be determined from the current directory name (the basename of the current working directory).

Steps:
1. Get the current directory name using `basename $(pwd)`
2. Fetch my GitHub username using the mcp__github__get_me tool
3. List all issues (both open and closed) from the repository using the mcp__github__list_issues tool with the determined repository name and my username as owner
4. Display a summary of all issues with their numbers, titles, states, labels, and creation dates
