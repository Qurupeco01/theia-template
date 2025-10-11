# Extending and Adopting the Theia IDE

This guide covers how to extend and customize the Eclipse Theia IDE to create your own custom IDE or development tool based on the Theia framework.

**Main source:** https://theia-ide.org/docs/blueprint_documentation/

## Overview

The Eclipse Theia IDE (technically called "Theia Blueprint") serves as a reference implementation showing how to build desktop IDE-like products using the Eclipse Theia framework. Rather than starting from scratch, you can adopt the Theia IDE as a foundation and customize it to meet your specific requirements.

## Understanding Theia IDE Structure

### Key Components

The Theia IDE is built as a desktop application using:
- **Electron**: For cross-platform desktop packaging
- **Electron-builder**: For creating installers and managing updates
- **Theia Framework**: Core IDE functionality
- **VS Code Extensions**: Plugin ecosystem compatibility
- **Custom Theia Extensions**: Specialized functionality

### Repository Structure

```
theia-blueprint/
├── applications/
│   └── electron/           # Main desktop application
│   │   ├── package.json    # App configuration and dependencies
│   │   ├── electron-builder.yml  # Build configuration
│   │   ├── resources/      # Icons and assets
│   │   └── scripts/        # Build and signing scripts
│   └── browser/            # Browser-based app   
│       ├── package.json
│       └── ...             # Similar structure to electron
├── theia-extensions/       # Custom Theia extensions
│   └── theia-blueprint-product/  # Product-specific customizations
└── package.json           # Root workspace configuration
```

## Building and Packaging

### Development Workflow

```bash
# Install dependencies and build
yarn && yarn build:dev && yarn download:plugins

# Run development version
yarn electron start

# Create unpackaged preview (faster for testing)
yarn electron package:preview

# Package for current OS
yarn electron package

# Deploy/publish
yarn electron deploy
```

### Build Outputs

- **Linux**: `.AppImage` executable
- **Windows**: `.exe` installer
- **macOS**: `.dmg` disk image

### Multi-platform Builds

Note: You can typically only build for your current operating system. For cross-platform builds, refer to the electron-builder documentation on multi-platform builds.

## Managing Extensions

### VS Code Extensions

#### Adding Built-in Extensions

Extensions are defined in `applications/electron/package.json` under the `theiaPlugins` property:

```json
{
  "theiaPlugins": {
    "vscode.typescript-language-features": "https://open-vsx.org/api/vscode/typescript-language-features/1.82.1/file/vscode.typescript-language-features-1.82.1.vsix",
    "ms-python.python": "https://open-vsx.org/api/ms-python/python/2023.16.0/file/ms-python.python-2023.16.0.vsix"
  }
}
```

#### Managing Extensions

```bash
# Download all defined plugins
yarn electron download:plugins

# Remove plugin (delete entry from package.json and remove folder)
rm -rf applications/electron/plugins/<plugin-name>
```

#### Extension Sources

Extensions are sourced from the **Open VSX Registry** (https://open-vsx.org/), an open-source VS Code extension marketplace maintained by the Eclipse Foundation.

### Theia Extensions

#### Adding Dependencies

Add Theia extensions as regular npm dependencies in `applications/electron/package.json`:

```json
{
  "dependencies": {
    "@theia/core": "^1.65.0",
    "@theia/filesystem": "^1.65.0",
    "@your-org/custom-extension": "^1.0.0"
  }
}
```

#### Creating Local Extensions

1. **Generate extension skeleton:**
   ```bash
   yo theia-extension --standalone
   ```

2. **Add to workspace:**
   Add the extension folder to the root `package.json` `workspaces` property.

3. **Include in application:**
   Add as dependency in `applications/electron/package.json`.

## Customization and Branding

### Application Identity

#### Application Name
Configure in `applications/electron/package.json`:

```json
{
  "theia": {
    "frontend": {
      "config": {
        "applicationName": "My Custom IDE"
      }
    }
  }
}
```

#### Application Icons
Replace icons in `applications/electron/resources/`:
- **macOS**: `icons.icns`
- **Windows**: `icon.ico`
- **Linux**: `icons/` subfolder

### UI Customization

#### Welcome Page
Customize by extending `TheiaBlueprintGettingStartedWidget`:

```typescript
// In theia-extensions/theia-blueprint-product/src/browser/
export class CustomGettingStartedWidget extends ReactWidget {
    // Custom welcome page implementation
}

// Bind in frontend module
bind(CustomGettingStartedWidget).toSelf();
bind(WidgetFactory).toDynamicValue(context => ({
    id: GettingStartedWidget.ID,
    createWidget: () => context.container.get(CustomGettingStartedWidget),
})).inSingletonScope();
```

#### About Dialog
Customize by extending `TheiaBlueprintAboutDialog`:

```typescript
export class CustomAboutDialog extends AboutDialog {
    // Custom about dialog implementation
}

// Bind in frontend module
isBound(AboutDialog) 
    ? rebind(AboutDialog).to(CustomAboutDialog).inSingletonScope() 
    : bind(AboutDialog).to(CustomAboutDialog).inSingletonScope();
```

#### Preferences Directory
Customize the default `.theia-blueprint` preferences directory by modifying `theia-blueprint-variables-server.ts`.

### Electron-Specific Features

#### Splash Screen
Configure in `package.json` under `theia.frontend.config.electron.splashScreenOptions`:

```json
{
  "theia": {
    "frontend": {
      "config": {
        "electron": {
          "splashScreenOptions": {
            "content": "resources/splash.html",
            "width": 640,
            "height": 480,
            "minDuration": 1000,
            "maxDuration": 30000
          },
          "showWindowEarly": true
        }
      }
    }
  }
}
```

### Installer Customization

#### Basic Configuration
Configure in `applications/electron/electron-builder.yml`:

```yaml
productName: "My Custom IDE"
directories:
  output: dist
files:
  - from: .
    filter:
      - package.json
      - node_modules/**/*
```

#### Windows Installer (NSIS)
Customize Windows installer appearance:

```yaml
nsis:
  oneClick: false
  allowToChangeInstallationDirectory: true
  installerIcon: resources/installer-icon.ico
  installerSidebar: resources/installer-sidebar.bmp
  license: LICENSE.txt
```

#### macOS Configuration
```yaml
mac:
  icon: resources/icon.icns
  category: public.app-category.developer-tools
dmg:
  background: resources/dmg-background.png
  iconSize: 128
```

## Deployment and Updates

### Code Signing

#### Setup
Signing configuration is in `applications/electron/scripts/after-pack.js`. Customize based on your certificate setup:

```javascript
// Example signing configuration
exports.default = async function(context) {
    // Custom signing logic based on your certificates
    if (context.electronPlatformName === 'win32') {
        // Windows signing
    } else if (context.electronPlatformName === 'darwin') {
        // macOS signing
    }
}
```

### Publishing and Updates

#### Configuration
Configure publishing targets in `applications/electron/electron-builder.yml`:

```yaml
publish:
  - provider: generic
    url: https://your-update-server.com/releases
  - provider: github
    owner: your-org
    repo: your-ide
```

#### Update Mechanism
The Theia IDE uses `electron-updater` for automatic updates. The first publish configuration is used for update checks.

#### Deployment Commands

```bash
# Build and publish
yarn electron deploy

# Manual publishing steps
yarn electron package
# Upload generated installers to your distribution platform
```

## Best Practices

### Development Guidelines

1. **Extension Management**
   - Keep VS Code extensions updated through Open VSX Registry
   - Use semantic versioning for custom Theia extensions
   - Test extension compatibility before including in builds

2. **Customization Strategy**
   - Extend existing components rather than replacing them entirely
   - Use proper dependency injection patterns
   - Follow Theia's contribution point system

3. **Build Optimization**
   - Use `package:preview` during development for faster iterations
   - Implement proper code signing for production builds
   - Configure appropriate update mechanisms

### Security Considerations

1. **Code Signing**
   - Implement proper code signing for all platforms
   - Use trusted certificate authorities
   - Test signed builds on target platforms

2. **Extension Security**
   - Vet all included VS Code extensions
   - Regularly update bundled extensions
   - Consider implementing extension allow/deny lists

### Maintenance

1. **Updates**
   - Regular Theia framework updates
   - Monitor and update bundled extensions
   - Test update mechanisms thoroughly

2. **Documentation**
   - Document custom extensions and modifications
   - Maintain build and deployment procedures
   - Create user documentation for custom features

### Distribution

1. **Installer Testing**
   - Test installers on clean systems
   - Verify update mechanisms work correctly
   - Test uninstallation processes

2. **Platform-Specific Considerations**
   - Windows: NSIS installer customization, Windows Defender compatibility
   - macOS: Notarization requirements, Gatekeeper compatibility  
   - Linux: AppImage compatibility, desktop integration

This guide provides the foundation for creating a custom IDE based on the Theia framework. The Theia IDE serves as an excellent starting point that can be adapted to specific domain requirements while maintaining professional desktop application standards. 