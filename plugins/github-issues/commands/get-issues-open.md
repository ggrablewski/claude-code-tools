---
name: get-issues-open
description: Read only open issues from the GitHub repository matching the current directory name
args: []
---

Please read only the open issues from my GitHub repository. The repository name should be determined from the current directory name (the basename of the current working directory).

Steps:
1. Get the current directory name using `basename $(pwd)`
2. Fetch my GitHub username using the mcp__github__get_me tool
3. List only open issues from the repository using the mcp__github__list_issues tool with:
   - Repository name from current directory
   - My username as owner
   - state parameter set to "OPEN"
4. Display a summary of all open issues with their numbers, titles, labels, and creation dates
