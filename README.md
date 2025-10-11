# Theia Application Template

A modern, streamlined template for building Theia-based IDEs with Yarn workspaces and Lerna coordination. This template provides both browser and desktop (Electron) applications with support for custom extensions and VSCode plugin integration.

## Features

- 🌐 **Browser & Desktop apps**: Pre-configured browser and Electron applications
- 🧩 **Extension support**: Workspace setup for custom Theia extensions in `extensions/`
- 🔌 **VSCode plugins**: Integrated VSX marketplace support for VSCode extensions
- 📦 **Yarn workspaces**: Modern dependency management with Yarn classic
- 🛠️ **Lerna coordination**: Streamlined monorepo scripts and build orchestration
- 🧹 **Comprehensive tooling**: Build, watch, test, lint, and clean workflows

## Quick Start

### Prerequisites

Install the required tools:
- **Node.js**: `>= 22` 
- **Yarn**: Classic v1.22+ (`npm install -g yarn`)
- **Python3**: Required for native module compilation

See [Theia prerequisites](https://github.com/eclipse-theia/theia/blob/master/doc/Developing.md#prerequisites) for platform-specific dependencies.

### Installation

```bash
git clone <your-repo>
cd theia-template
yarn install          # Install dependencies + setup plugins
```

### Development

```bash
# Complete development build
yarn build:dev

# Run applications
yarn browser start      # Browser app at http://localhost:3000
yarn electron start     # Desktop app

# Watch mode for active development
yarn watch              # Both apps
yarn browser watch      # Browser only
yarn electron watch     # Electron only
```

### Production

```bash
yarn build              # Production build for both apps
yarn browser build      # Browser production build only
yarn electron build     # Electron production build only
```

## Project Structure

```
theia-template/
├── browser-app/         # Browser application configuration
├── electron-app/        # Electron application configuration  
├── extensions/          # Custom Theia extensions (your code)
├── plugins/             # Downloaded VSCode extensions
├── scripts/             # Utility scripts
└── docs/                # Documentation
```

## Development Workflows

### Working with Extensions

```bash
yarn build:extensions   # Build custom extensions
yarn watch:extensions   # Watch extensions for changes
```

### Plugin Management

```bash
yarn download:plugins   # Download VSCode plugins
yarn clean:plugins      # Clear plugin cache
```

### Individual App Development

```bash
# Prepare dependencies once
yarn build:prepare      # Build extensions + download plugins

# Then work with specific app
yarn browser build:dev  # Browser development build
yarn electron watch     # Electron watch mode
```

## Configuration

### Customize Applications

Edit the following files to customize your IDE:

- **Root**: `package.json` - Workspace configuration, plugin definitions
- **Browser**: `browser-app/package.json` - Browser app settings, dependencies
- **Electron**: `electron-app/package.json` - Desktop app settings, dependencies

### Add VSCode Extensions

Add extensions to the root `package.json`:

```json
{
  "theiaPlugins": {
    "vscode.git": "https://open-vsx.org/api/vscode/git/1.52.1/file/vscode.git-1.52.1.vsix"
  }
}
```

Then run `yarn download:plugins` to fetch them.

## Available Scripts

| Command | Description |
|---------|-------------|
| `yarn build` | Complete production build |
| `yarn build:dev` | Complete development build |
| `yarn build:prepare` | Build extensions + download plugins |
| `yarn watch` | Watch both applications |
| `yarn test` | Run all tests |
| `yarn lint` | Code quality checks |
| `yarn clean` | Complete workspace reset |
| `yarn clean:build` | Clean build artifacts only |

See the [development environment guide](docs/theia_dev_environment.md) for comprehensive workflow documentation.

## Documentation

- [Development Environment](docs/theia_dev_environment.md) - Comprehensive development workflows
- [Application Development](docs/theia_app_develop.md) - Building Theia applications
- [Extension Development](docs/theia_extension_dev.md) - Creating custom extensions
- [Configuration Options](docs/theia_json_properties.md) - Package.json Theia settings

## Contributing

This template is based on the [Theia framework](https://theia-ide.org/). For framework-specific questions, refer to the [Theia documentation](https://theia-ide.org/docs/).

## License

TODO - Update license information in package.json files.
