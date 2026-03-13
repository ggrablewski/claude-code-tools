#!/bin/bash
# GitHub MCP - Set Environment Variable Script
# This script sets the GITHUB_PERSONAL_ACCESS_TOKEN environment variable for Claude Code
#
# Usage: ./set-env-var.sh <YOUR_GITHUB_TOKEN>

# ============================================
# SET ENVIRONMENT VARIABLE
# ============================================

setx GITHUB_PERSONAL_ACCESS_TOKEN "$1" > /dev/null 2>&1
