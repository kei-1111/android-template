#!/bin/bash

# Android Template - Module Creation Script
# Usage: ./scripts/create-module.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE_PACKAGE="io.github.kei_1111.androidtemplate"

echo -e "${GREEN}=== Android Template Module Creator ===${NC}\n"

# Module type selection
echo "Select module type:"
echo "1) Core Library (core:*)"
echo "2) Feature Module (feature:*)"
echo "3) Custom path"
read -p "Enter choice [1-3]: " module_type

case $module_type in
    1)
        MODULE_PREFIX="core"
        echo ""
        echo "Does this module use Jetpack Compose?"
        echo "1) Yes - Use android.library.compose"
        echo "2) No  - Use android.library"
        read -p "Enter choice [1-2]: " compose_choice
        case $compose_choice in
            1) PLUGIN="androidtemplate.android.library.compose" ;;
            2) PLUGIN="androidtemplate.android.library" ;;
            *) echo -e "${RED}Invalid choice${NC}"; exit 1 ;;
        esac
        ;;
    2)
        MODULE_PREFIX="feature"
        PLUGIN="androidtemplate.android.feature"
        ;;
    3)
        read -p "Enter custom path (e.g., data/local): " MODULE_PREFIX
        echo "Select plugin type:"
        echo "1) android.library"
        echo "2) android.library.compose"
        echo "3) android.feature"
        read -p "Enter choice [1-3]: " plugin_choice
        case $plugin_choice in
            1) PLUGIN="androidtemplate.android.library" ;;
            2) PLUGIN="androidtemplate.android.library.compose" ;;
            3) PLUGIN="androidtemplate.android.feature" ;;
            *) echo -e "${RED}Invalid choice${NC}"; exit 1 ;;
        esac
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

# Module name input
read -p "Enter module name (e.g., network, auth): " MODULE_NAME

if [ -z "$MODULE_NAME" ]; then
    echo -e "${RED}Module name cannot be empty${NC}"
    exit 1
fi

# Construct paths
MODULE_PATH="$MODULE_PREFIX/$MODULE_NAME"
MODULE_DIR="$PROJECT_ROOT/$MODULE_PATH"
# Convert / to . for package path
PACKAGE_PREFIX="${MODULE_PREFIX//\//.}"
PACKAGE_NAME="${MODULE_NAME//\//.}"
PACKAGE_PATH="${BASE_PACKAGE}.${PACKAGE_PREFIX}.${PACKAGE_NAME}"
# Convert . to / for directory path
PACKAGE_DIR="$MODULE_DIR/src/main/kotlin/${PACKAGE_PATH//.//}"

# Check if module already exists
if [ -d "$MODULE_DIR" ]; then
    echo -e "${RED}Error: Module $MODULE_PATH already exists${NC}"
    exit 1
fi

echo -e "\n${YELLOW}Creating module:${NC}"
echo "  Path: $MODULE_PATH"
echo "  Package: $PACKAGE_PATH"
echo "  Plugin: $PLUGIN"
read -p "Continue? [y/N]: " confirm

if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo "Cancelled"
    exit 0
fi

# Create directory structure
echo -e "\n${GREEN}Creating directories...${NC}"
mkdir -p "$PACKAGE_DIR"

# Ask about unit test directory
read -p "Create unit test directory (src/test)? [y/N]: " create_unit_test

if [[ $create_unit_test =~ ^[Yy]$ ]]; then
    TEST_DIR="$MODULE_DIR/src/test/kotlin/${PACKAGE_PATH//.//}"
    mkdir -p "$TEST_DIR"
    echo -e "${GREEN}Created unit test directory${NC}"
fi

# Ask about Android test directory
read -p "Create Android test directory (src/androidTest)? [y/N]: " create_android_test

if [[ $create_android_test =~ ^[Yy]$ ]]; then
    ANDROID_TEST_DIR="$MODULE_DIR/src/androidTest/kotlin/${PACKAGE_PATH//.//}"
    mkdir -p "$ANDROID_TEST_DIR"
    echo -e "${GREEN}Created Android test directory${NC}"
fi

# Create build.gradle.kts
echo -e "${GREEN}Creating build.gradle.kts...${NC}"
cat > "$MODULE_DIR/build.gradle.kts" << EOF
plugins {
    alias(libs.plugins.$PLUGIN)
}

android {
    namespace = "$PACKAGE_PATH"
}

dependencies {
    // Add your dependencies here
}
EOF

# Add to settings.gradle.kts
echo -e "${GREEN}Adding to settings.gradle.kts...${NC}"
SETTINGS_FILE="$PROJECT_ROOT/settings.gradle.kts"

# Convert / to : for Gradle module path
GRADLE_MODULE_PATH="${MODULE_PATH//\//:}"

# Check if module already included
if grep -q "include(\":$GRADLE_MODULE_PATH\")" "$SETTINGS_FILE"; then
    echo -e "${YELLOW}Module already in settings.gradle.kts${NC}"
else
    # Ensure file ends with newline, then add include statement
    [ -n "$(tail -c 1 "$SETTINGS_FILE" 2>/dev/null)" ] && echo "" >> "$SETTINGS_FILE"
    echo "include(\":$GRADLE_MODULE_PATH\")" >> "$SETTINGS_FILE"
    echo -e "${GREEN}Added to settings.gradle.kts${NC}"
fi


echo -e "\n${GREEN}✓ Module created successfully!${NC}"
echo -e "\nModule location: ${YELLOW}$MODULE_PATH${NC}"
echo -e "Package: ${YELLOW}$PACKAGE_PATH${NC}"
echo -e "\nNext steps:"
echo "  1. Sync your Gradle project"
echo "  2. Add dependencies to $MODULE_PATH/build.gradle.kts"
echo "  3. Start coding!"