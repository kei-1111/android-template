#!/bin/bash

# Android Template - Git Configuration Removal Script
# Removes .git directory to clean Git history
# Usage: ./scripts/remove-git.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GIT_DIR="$PROJECT_ROOT/.git"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Git Configuration Removal Script                        ║${NC}"
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo ""

# Check if .git directory exists
if [ ! -d "$GIT_DIR" ]; then
    echo -e "${YELLOW}⚠ No .git directory found in the project root.${NC}"
    echo -e "${YELLOW}The project does not appear to be a Git repository.${NC}"
    echo ""
    exit 0
fi

# Show current Git status
echo -e "${YELLOW}Current Git repository information:${NC}"
echo ""

cd "$PROJECT_ROOT"

# Show remote URLs if they exist
if git remote -v 2>/dev/null | grep -q .; then
    echo -e "${BLUE}Remote repositories:${NC}"
    git remote -v 2>/dev/null | sed 's/^/  /'
    echo ""
fi

# Show current branch
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
echo -e "${BLUE}Current branch:${NC} ${CURRENT_BRANCH}"
echo ""

# Show commit count
COMMIT_COUNT=$(git rev-list --all --count 2>/dev/null || echo "0")
echo -e "${BLUE}Total commits:${NC} ${COMMIT_COUNT}"
echo ""

# Show last commit if exists
if [ "$COMMIT_COUNT" != "0" ]; then
    echo -e "${BLUE}Last commit:${NC}"
    git log -1 --oneline 2>/dev/null | sed 's/^/  /' || true
    echo ""
fi

echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}Warning: This action will:${NC}"
echo -e "  ${RED}• Delete the entire .git directory${NC}"
echo -e "  ${RED}• Remove all Git history and commits${NC}"
echo -e "  ${RED}• Remove all branch information${NC}"
echo -e "  ${RED}• Remove all remote repository connections${NC}"
echo ""
echo -e "${GREEN}This action will NOT:${NC}"
echo -e "  ${GREEN}• Delete .gitignore or other Git-related files${NC}"
echo -e "  ${GREEN}• Delete any of your project source files${NC}"
echo ""
echo -e "${RED}⚠ This action cannot be undone!${NC}"
echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
echo ""

read -p "$(echo -e ${YELLOW}Are you sure you want to remove Git configuration? [y/N]: ${NC})" confirm

if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Operation cancelled.${NC}"
    exit 0
fi

echo ""
echo -e "${GREEN}Removing Git configuration...${NC}"
echo ""

# Remove .git directory
echo -e "${BLUE}Deleting .git directory...${NC}"
rm -rf "$GIT_DIR"

if [ ! -d "$GIT_DIR" ]; then
    echo -e "${GREEN}✓ .git directory removed successfully${NC}"
else
    echo -e "${RED}✗ Failed to remove .git directory${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ Git configuration removed successfully!${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Initialize a new Git repository (if needed):"
echo "     ${BLUE}git init${NC}"
echo "  2. Add your remote repository:"
echo "     ${BLUE}git remote add origin <your-repository-url>${NC}"
echo "  3. Make your initial commit:"
echo "     ${BLUE}git add .${NC}"
echo "     ${BLUE}git commit -m \"Initial commit\"${NC}"
echo "  4. Push to remote repository:"
echo "     ${BLUE}git branch -M main${NC}"
echo "     ${BLUE}git push -u origin main${NC}"
echo ""

# Self-destruct: Remove this script
SCRIPT_PATH="${BASH_SOURCE[0]}"
if [ -f "$SCRIPT_PATH" ]; then
    echo -e "${BLUE}Removing this script...${NC}"
    rm -- "$SCRIPT_PATH"
    echo -e "${GREEN}✓ Script removed${NC}"
    echo ""
fi