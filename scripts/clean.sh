#!/bin/bash

# Theia Cleanup Script - Simplified
# Usage: ./clean.sh [command]

show_help() {
    echo "Theia Cleanup Commands:"
    echo ""
    echo "Browser-app:"
    echo "  browser:settings       - Clean browser IDE settings only (~/.theia-ide)"
    echo ""
    echo "Electron-app:"
    echo "  electron:settings      - Clean electron IDE settings only (~/.theia-ide)"
    echo "  electron:persistent    - Clean electron persistent state (~/.config/electron-app)"
    echo ""
    echo "Build:"
    echo "  build:clean            - Clean all build artifacts and rebuild"
    echo ""
    echo "Other:"
    echo "  analyze                - Show current storage usage"
    echo ""
}

# Get configuration folder from package.json
get_config_folder() {
    local app_type=$1
    local config_folder=$(grep -A 10 '"backend"' ${app_type}-app/package.json | grep 'configurationFolder' | cut -d'"' -f4 2>/dev/null)
    echo "${config_folder:-.theia}"
}

# Get app name for .config directory
get_app_name() {
    local app_type=$1
    local app_name=$(grep '"productName"' ${app_type}-app/package.json | head -1 | cut -d'"' -f4 2>/dev/null)
    echo "${app_name:-${app_type}-app}"
}

# Browser cleanup functions
clean_browser_settings() {
    echo "🧹 Cleaning browser settings..."
    
    local config_folder=$(get_config_folder "browser")
    local settings_dir=~/${config_folder}
    
    if [ -d "$settings_dir" ]; then
        rm -rf "$settings_dir" 2>/dev/null
        echo "✓ Browser settings cleaned ($settings_dir)"
    else
        echo "! No browser settings found ($settings_dir)"
    fi
}

# Electron cleanup functions  
clean_electron_settings() {
    echo "🧹 Cleaning electron settings..."
    
    local config_folder=$(get_config_folder "electron")
    local settings_dir=~/${config_folder}
    
    if [ -d "$settings_dir" ]; then
        rm -rf "$settings_dir" 2>/dev/null
        echo "✓ Electron settings cleaned ($settings_dir)"
    else
        echo "! No electron settings found ($settings_dir)"
    fi
}

clean_electron_persistent() {
    echo "🧹 Cleaning electron persistent state..."
    
    local app_name=$(get_app_name "electron")
    local persistent_dir=~/.config/${app_name}
    
    if [ -d "$persistent_dir" ]; then
        rm -rf "$persistent_dir" 2>/dev/null
        echo "✓ Electron persistent state cleaned ($persistent_dir)"
    else
        echo "! No electron persistent data found ($persistent_dir)"
    fi
}

# Build cleanup
clean_build() {
    echo "🔨 Cleaning build artifacts..."
    
    # Check if we're in a git repository
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Use git clean to remove all ignored files (build artifacts)
        git clean -fdX
        echo "✓ Build artifacts cleaned with git clean -fdX"
    else
        echo "! Not a git repository, using manual cleanup..."
        
        # Fallback manual cleanup
        if [ -d node_modules ]; then
            rm -rf node_modules
            echo "✓ node_modules removed"
        fi
        
        # Compiled code
        find . -name "lib" -type d -exec rm -rf {} + 2>/dev/null
        find . -name "src-gen" -type d -exec rm -rf {} + 2>/dev/null
        echo "✓ Compiled code removed"
        
    fi
    
}

# Analysis
analyze() {
    echo "📊 Storage Analysis"
    echo "==================="
    
    local browser_config=$(get_config_folder "browser")
    local electron_config=$(get_config_folder "electron")
    local electron_app=$(get_app_name "electron")
    
    echo "Settings:"
    [ -d ~/${browser_config} ] && echo "  Browser (~/${browser_config}): $(du -sh ~/${browser_config} | cut -f1)" || echo "  Browser (~/${browser_config}): Not found"
    [ -d ~/${electron_config} ] && echo "  Electron (~/${electron_config}): $(du -sh ~/${electron_config} | cut -f1)" || echo "  Electron (~/${electron_config}): Not found"
    
    echo "Persistent State:"
    
    # Electron persistent state
    [ -d ~/.config/${electron_app} ] && echo "  Electron (~/.config/${electron_app}): $(du -sh ~/.config/${electron_app} | cut -f1)" || echo "  Electron (~/.config/${electron_app}): Not found"
    
    echo "Build Artifacts:"
    [ -d node_modules ] && echo "  node_modules: $(du -sh node_modules | cut -f1)" || echo "  node_modules: Not found"
    TOTAL_LIB=$(find . -name "lib" -type d -exec du -sb {} + 2>/dev/null | awk '{sum+=$1} END {print sum}')
    [ "$TOTAL_LIB" ] && echo "  compiled code: $(numfmt --to=iec $TOTAL_LIB)" || echo "  compiled code: None"
}

# Main script
case "$1" in
    "browser:settings")     clean_browser_settings ;;
    "electron:settings")    clean_electron_settings ;;
    "electron:persistent")  clean_electron_persistent ;;
    "build:clean")          clean_build ;;
    "analyze")              analyze ;;
    *)                      show_help ;;
esac