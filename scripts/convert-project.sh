#!/bin/bash

# Android Template - Project Conversion Script
# Converts this template project to a new project with custom package name and identifiers
# Usage: ./scripts/convert-project.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Current values (from template)
OLD_PACKAGE="io.github.kei_1111.androidtemplate"
OLD_PROJECT_NAME="android-template"
OLD_PLUGIN_ID="androidtemplate"
OLD_THEME_NAME="AndroidTemplate"
OLD_APP_CLASS="AndroidTemplateApplication"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Android Template → New Project Conversion Script        ║${NC}"
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo ""

# Function: Validate package name
validate_package() {
    local package=$1
    if [[ ! $package =~ ^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)+$ ]]; then
        return 1
    fi
    return 0
}

# Function: Validate project name
validate_project_name() {
    local name=$1
    if [[ ! $name =~ ^[a-z][a-z0-9-]*$ ]]; then
        return 1
    fi
    return 0
}

# Function: Validate plugin ID
validate_plugin_id() {
    local id=$1
    if [[ ! $id =~ ^[a-z][a-z0-9]*$ ]]; then
        return 1
    fi
    return 0
}

# Function: Validate PascalCase name
validate_pascal_case() {
    local name=$1
    if [[ ! $name =~ ^[A-Z][a-zA-Z0-9]*$ ]]; then
        return 1
    fi
    return 0
}

# Collect input: New package name
echo -e "${GREEN}1. New Package Name${NC}"
echo "   Format: com.example.myapp (lowercase, dot-separated)"
echo "   Current: ${OLD_PACKAGE}"
while true; do
    read -p "   Enter new package name: " NEW_PACKAGE
    if validate_package "$NEW_PACKAGE"; then
        break
    else
        echo -e "${RED}   ✗ Invalid format. Use lowercase letters, numbers, underscores, and dots.${NC}"
    fi
done
echo ""

# Collect input: New project name
echo -e "${GREEN}2. New Project Name${NC}"
echo "   Format: my-app (lowercase, hyphen-separated)"
echo "   Current: ${OLD_PROJECT_NAME}"
while true; do
    read -p "   Enter new project name: " NEW_PROJECT_NAME
    if validate_project_name "$NEW_PROJECT_NAME"; then
        break
    else
        echo -e "${RED}   ✗ Invalid format. Use lowercase letters, numbers, and hyphens.${NC}"
    fi
done
echo ""

# Collect input: New plugin ID
echo -e "${GREEN}3. New Convention Plugin ID${NC}"
echo "   Format: myapp (lowercase, no special characters)"
echo "   Current: ${OLD_PLUGIN_ID}"
while true; do
    read -p "   Enter new plugin ID: " NEW_PLUGIN_ID
    if validate_plugin_id "$NEW_PLUGIN_ID"; then
        break
    else
        echo -e "${RED}   ✗ Invalid format. Use lowercase letters and numbers only.${NC}"
    fi
done
echo ""

# Collect input: New theme name
echo -e "${GREEN}4. New Theme Name${NC}"
echo "   Format: MyApp (PascalCase)"
echo "   Current: ${OLD_THEME_NAME}"
while true; do
    read -p "   Enter new theme name: " NEW_THEME_NAME
    if validate_pascal_case "$NEW_THEME_NAME"; then
        break
    else
        echo -e "${RED}   ✗ Invalid format. Use PascalCase (e.g., MyApp, AwesomeApp).${NC}"
    fi
done
echo ""

# Collect input: New application class name
echo -e "${GREEN}5. New Application Class Name${NC}"
echo "   Format: MyAppApplication (PascalCase, typically ends with 'Application')"
echo "   Current: ${OLD_APP_CLASS}"
while true; do
    read -p "   Enter new application class name: " NEW_APP_CLASS
    if validate_pascal_case "$NEW_APP_CLASS"; then
        break
    else
        echo -e "${RED}   ✗ Invalid format. Use PascalCase.${NC}"
    fi
done
echo ""

# Show summary
echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}Summary of Changes${NC}"
echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
echo -e "Package Name:       ${RED}${OLD_PACKAGE}${NC} → ${GREEN}${NEW_PACKAGE}${NC}"
echo -e "Project Name:       ${RED}${OLD_PROJECT_NAME}${NC} → ${GREEN}${NEW_PROJECT_NAME}${NC}"
echo -e "Plugin ID:          ${RED}${OLD_PLUGIN_ID}${NC} → ${GREEN}${NEW_PLUGIN_ID}${NC}"
echo -e "Theme Name:         ${RED}${OLD_THEME_NAME}${NC} → ${GREEN}${NEW_THEME_NAME}${NC}"
echo -e "Application Class:  ${RED}${OLD_APP_CLASS}${NC} → ${GREEN}${NEW_APP_CLASS}${NC}"
echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}This will modify:${NC}"
echo "  • 22+ Kotlin source files (package declarations)"
echo "  • 6+ build.gradle.kts files (namespace, group)"
echo "  • 5 plugin ID definitions in libs.versions.toml"
echo "  • 14+ convention plugin files"
echo "  • 3 XML resource files"
echo "  • 2 script/documentation files"
echo "  • CLAUDE.md (project documentation)"
echo "  • Directory structure (package folders)"
echo ""

read -p "$(echo -e ${YELLOW}Continue with conversion? [y/N]: ${NC})" confirm

if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Conversion cancelled.${NC}"
    exit 0
fi

echo ""
echo -e "${GREEN}Starting conversion...${NC}"
echo ""

# Function: Replace in file
replace_in_file() {
    local file=$1
    local old=$2
    local new=$3

    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s|${old}|${new}|g" "$file"
    else
        # Linux
        sed -i "s|${old}|${new}|g" "$file"
    fi
}

# Phase 1: Replace package names in files
echo -e "${BLUE}[1/4] Replacing package names in files...${NC}"

# Replace in Kotlin files
find "$PROJECT_ROOT" -type f -name "*.kt" | while read file; do
    echo "  Updating: $file"
    replace_in_file "$file" "$OLD_PACKAGE" "$NEW_PACKAGE"    # Also replace plugin IDs in string literals (e.g., apply("androidtemplate.detekt"))
    replace_in_file "$file" "\"${OLD_PLUGIN_ID}." "\"${NEW_PLUGIN_ID}."
done

# Replace in build files
find "$PROJECT_ROOT" -type f -name "build.gradle.kts" | while read file; do
    echo "  Updating: $file"
    replace_in_file "$file" "$OLD_PACKAGE" "$NEW_PACKAGE"
    # Replace plugin IDs only in plugin references (libs.plugins.xxx)
    replace_in_file "$file" "libs\\.plugins\\.${OLD_PLUGIN_ID}" "libs.plugins.${NEW_PLUGIN_ID}"
done

# Replace in libs.versions.toml
if [ -f "$PROJECT_ROOT/gradle/libs.versions.toml" ]; then
    echo "  Updating: gradle/libs.versions.toml"
    replace_in_file "$PROJECT_ROOT/gradle/libs.versions.toml" "$OLD_PLUGIN_ID" "$NEW_PLUGIN_ID"
fi

# Replace in settings.gradle.kts
if [ -f "$PROJECT_ROOT/settings.gradle.kts" ]; then
    echo "  Updating: settings.gradle.kts"
    replace_in_file "$PROJECT_ROOT/settings.gradle.kts" "$OLD_PROJECT_NAME" "$NEW_PROJECT_NAME"
fi

# Replace in XML files
find "$PROJECT_ROOT" -type f \( -name "*.xml" -o -name "AndroidManifest.xml" \) | while read file; do
    echo "  Updating: $file"
    replace_in_file "$file" "$OLD_PROJECT_NAME" "$NEW_PROJECT_NAME"
    # Replace application class first (longer string) to avoid partial matches with theme name
    replace_in_file "$file" "$OLD_APP_CLASS" "$NEW_APP_CLASS"
    # Replace theme name only in style references (Theme.xxx pattern) to avoid double replacement
    replace_in_file "$file" "Theme\\.${OLD_THEME_NAME}" "Theme.${NEW_THEME_NAME}"
done

# Replace in scripts
if [ -f "$PROJECT_ROOT/scripts/create-module.sh" ]; then
    echo "  Updating: scripts/create-module.sh"
    replace_in_file "$PROJECT_ROOT/scripts/create-module.sh" "$OLD_PACKAGE" "$NEW_PACKAGE"
    # Update plugin IDs in plugin selections
    replace_in_file "$PROJECT_ROOT/scripts/create-module.sh" "${OLD_PLUGIN_ID}\\." "${NEW_PLUGIN_ID}."
fi

# scripts/README.md is documentation for the conversion script itself
# It will be removed along with the conversion script at the end

# Replace in CLAUDE.md
if [ -f "$PROJECT_ROOT/CLAUDE.md" ]; then
    echo "  Updating: CLAUDE.md"
    # Replace plugin IDs only in plugin ID format (xxx.android. or xxx.detekt) to avoid double replacement
    replace_in_file "$PROJECT_ROOT/CLAUDE.md" "${OLD_PLUGIN_ID}\\.android\\." "${NEW_PLUGIN_ID}.android."
    replace_in_file "$PROJECT_ROOT/CLAUDE.md" "${OLD_PLUGIN_ID}\\.detekt" "${NEW_PLUGIN_ID}.detekt"
    # Replace theme name only with Theme suffix to avoid double replacement
    replace_in_file "$PROJECT_ROOT/CLAUDE.md" "${OLD_THEME_NAME}Theme" "${NEW_THEME_NAME}Theme"
fi

echo -e "${GREEN}✓ Package name replacement complete${NC}"
echo ""

# Phase 2: Rename directories
echo -e "${BLUE}[2/4] Renaming package directories...${NC}"

# Convert package names to directory paths
OLD_PACKAGE_PATH="${OLD_PACKAGE//.//}"
NEW_PACKAGE_PATH="${NEW_PACKAGE//.//}"

# Find and rename package directories
find "$PROJECT_ROOT" -type d -path "*/kotlin/${OLD_PACKAGE_PATH}" | while read old_dir; do
    new_dir="${old_dir/${OLD_PACKAGE_PATH}/${NEW_PACKAGE_PATH}}"
    new_parent="$(dirname "$new_dir")"

    echo "  Renaming: $old_dir"
    echo "        →: $new_dir"

    # Create parent directory if it doesn't exist
    mkdir -p "$new_parent"

    # Move directory
    mv "$old_dir" "$new_dir"

    # Clean up empty old parent directories
    old_parent="$(dirname "$old_dir")"
    while [ "$old_parent" != "$(dirname "$new_parent")" ] && [ -d "$old_parent" ]; do
        if [ -z "$(ls -A "$old_parent")" ]; then
            rmdir "$old_parent" 2>/dev/null || true
            old_parent="$(dirname "$old_parent")"
        else
            break
        fi
    done
done

echo -e "${GREEN}✓ Directory renaming complete${NC}"
echo ""

# Phase 3: Rename theme and application class
echo -e "${BLUE}[3/4] Updating theme and class names...${NC}"

# Find and replace theme name and application class in Kotlin files
find "$PROJECT_ROOT" -type f -name "*.kt" | while read file; do
    # Update theme name if present
    if grep -q "$OLD_THEME_NAME" "$file" 2>/dev/null; then
        echo "  Updating theme in: $file"
        replace_in_file "$file" "${OLD_THEME_NAME}Theme" "${NEW_THEME_NAME}Theme"
    fi
    # Update application class name if present
    if grep -q "$OLD_APP_CLASS" "$file" 2>/dev/null; then
        echo "  Updating application class in: $file"
        replace_in_file "$file" "$OLD_APP_CLASS" "$NEW_APP_CLASS"
    fi
done

echo -e "${GREEN}✓ Theme and class name update complete${NC}"
echo ""

# Phase 4: Rename Application class file
echo -e "${BLUE}[4/4] Renaming Application class file...${NC}"

# Find Application class file by the old class name
APP_FILE=$(find "$PROJECT_ROOT/app/src" -type f -name "${OLD_APP_CLASS}.kt" | head -n 1)

if [ -n "$APP_FILE" ]; then
    APP_DIR="$(dirname "$APP_FILE")"
    NEW_APP_FILE="$APP_DIR/${NEW_APP_CLASS}.kt"

    echo "  Renaming: $APP_FILE"
    echo "        →: $NEW_APP_FILE"

    mv "$APP_FILE" "$NEW_APP_FILE"
    echo -e "${GREEN}✓ Application class file renamed${NC}"
else
    echo -e "${YELLOW}⚠ No Application class file found to rename${NC}"
fi

echo ""

# Completion
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ Conversion completed successfully!${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""

# Get current directory name
CURRENT_DIR_NAME="$(basename "$PROJECT_ROOT")"

# Check if root directory name needs to be changed
if [ "$CURRENT_DIR_NAME" != "$NEW_PROJECT_NAME" ]; then
    echo -e "${YELLOW}⚠ Root directory name should be updated${NC}"
    echo ""
    echo -e "${YELLOW}Current directory: ${RED}${CURRENT_DIR_NAME}${NC}"
    echo -e "${YELLOW}New project name:  ${GREEN}${NEW_PROJECT_NAME}${NC}"
    echo ""
    echo -e "${YELLOW}To rename the root project directory, run these commands:${NC}"
    echo -e "  ${BLUE}cd ..${NC}"
    echo -e "  ${BLUE}mv ${CURRENT_DIR_NAME} ${NEW_PROJECT_NAME}${NC}"
    echo -e "  ${BLUE}cd ${NEW_PROJECT_NAME}${NC}"
    echo ""
fi

echo -e "${YELLOW}Next steps:${NC}"
if [ "$CURRENT_DIR_NAME" != "$NEW_PROJECT_NAME" ]; then
    echo "  1. Rename the root project directory (see commands above)"
    echo "  2. Sync your Gradle project in Android Studio"
    echo -e "  3. Run a clean build: ${BLUE}./gradlew clean build${NC}"
    echo "  4. Verify all modules compile successfully"
    echo "  5. Update README.md with your project information"
    echo "  6. Commit the converted changes:"
    echo -e "     ${BLUE}git add . && git commit -m \"chore: convert from template to ${NEW_PROJECT_NAME}\"${NC}"
else
    echo "  1. Sync your Gradle project in Android Studio"
    echo -e "  2. Run a clean build: ${BLUE}./gradlew clean build${NC}"
    echo "  3. Verify all modules compile successfully"
    echo "  4. Update README.md with your project information"
    echo "  5. Commit the converted changes:"
    echo -e "     ${BLUE}git add . && git commit -m \"chore: convert from template to ${NEW_PROJECT_NAME}\"${NC}"
fi
echo ""
echo -e "${YELLOW}Project converted:${NC}"
echo -e "  Package: ${GREEN}${NEW_PACKAGE}${NC}"
echo -e "  Name:    ${GREEN}${NEW_PROJECT_NAME}${NC}"
echo ""

# Self-destruct: Remove this conversion script and its documentation
SCRIPT_PATH="${BASH_SOURCE[0]}"
if [ -f "$SCRIPT_PATH" ]; then
    echo -e "${BLUE}Removing conversion script and documentation...${NC}"
    rm -- "$SCRIPT_PATH"

    # Also remove the README.md that documents this conversion script
    if [ -f "$PROJECT_ROOT/scripts/README.md" ]; then
        rm -- "$PROJECT_ROOT/scripts/README.md"
    fi

    echo -e "${GREEN}✓ Conversion script and documentation removed${NC}"
    echo ""
fi