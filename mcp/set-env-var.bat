@REM # Windows batch file
@REM # GitHub MCP - Set Environment Variable Script
@REM # This script sets the GITHUB_PERSONAL_ACCESS_TOKEN environment variable for Claude Code
@REM #
@REM # Usage: ./set-env-var.sh <YOUR_GITHUB_TOKEN>

@REM # ============================================
@REM # SET ENVIRONMENT VARIABLE
@REM # ============================================

set GITHUB_PERSONAL_ACCESS_TOKEN=%1
echo %GITHUB_PERSONAL_ACCESS_TOKEN%
