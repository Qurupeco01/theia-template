This guide is about the theia development environment: i.e. the folder in which you will deploy a theia application, where are settings saved, how are scripts organized, and tools that are available during the development experience. This is focused on the configuration provided in the [Theia Template](https://github.com/Nodeably/theia-template) available in Nodeably repository.

## Development setup

Before starting development, it is recommended to customize the TODO fields in the three package.json: the main one, the electron and the browser. Also is highly recommended to modify the name of both electron and browser apps, as well as the configuration folder that will be used for the program. In this way, you will ready to go!

## Package.json Theia configuration

The `theia/cli`dev dependency adds some specific configurations under the `theia`field in both package.json for browser and electron. For better understanding of availabe options, refer to [[theia_json_properties]].

## Preferences

Theia saves some user and layout preferences in a `.theia` folder (or `.your-app`, as can be customized).  These preferences are the exact same as the ones in the "settings" menu inside the app. There are two type of preferences:

- **User preferences**: those affect the whole system, and are saved for the user. by default, are saved under `$HOME/.theia/settings.json` on linux, and `%USERPROFILE%/.theia/settings.json` on windows.

- **Workspace preferences**: when using a theia app and opening a folder, workspace preferences can be applied in a `.theia` directory inside the same folder (the same as when you havea a .vscode directory in your projects). This can be useful, for example, if we want to override some user preference only for a type of project, or for a specific folder. 

> **Important note**: If both browser and electron apps use the same config folder, they will share the configuration. Theia IDE does this by default and we will do it as well

Apart from settings, the `.theia`or `.your-app`directory also stores information about last opened folder, plugins, etc.

To reset these preferences, you can run the `clean:browser/electron:settings`script.

### Default preferences

There are some default preferences that can be provided by each extension with special contributions. For that, refer to [[theia_extension_dev]].

Also, if you want to provide default settings for some preferences of the basic theia application, this can be done in the package.json in `preferences` field of frontend. For more options, see [[theia_json_properties]]

## Persistent state

Apart from preferences, theia has what is called a persistent state. This means that, between executions, it will save the status of the window, the last opened workspace, the layout selected by the user, etc.

Apparently there should no need to change this neither to delete these directories, but could be useful to simulate a fully fresh start of the app from scratch. If deleted, the window returns to the default state, **but settings and opened folder remain the same** as they are store in `.theia`directory discussed above.

Persistent state is saved in:

1.   Electron: `~/.config/your-app/`.here the window size, the electron preferences, cache, cookies, etc. are stored. To reset the electron persistent state, either delete this folder or run `clean:electron:persistent` script.

2. Browser: `~/.config/your-browser-name (e.g. google-crhome)/Default`. This is much more complex as is it stores states in some files managed by the browser that are binded to the IP. Is hard to tell how to delete it, and at the moment there is no reliable way of doing it. However it should not affect development.

If you want to simulate a fresh start and delete both preferences and persistent state in desktop, use  `clean:electron:fresh`

## Sub-Extensions dependencies

It is important to note that **extensions can be setted as dependencies of other extensions**, so if for example i import an extension `extension_1` that depends on other 3 extensions, all 4 of them will be in the final app.

This can be seen accessing the `package-lock.json`or `yarn.lock`file, and looking for all dependencies of the required extension. Also, in the dev app, in the *About* page all extensions can be seen.

## Development tools



## Commands and scripts

The project uses a three-level script hierarchy: root coordination, application-specific tasks, and granular operations. All scripts are organized to provide both comprehensive workflows and fine-grained control for efficient development.

### Root-level commands

These commands coordinate multiple packages and provide the main development workflows:

**Build workflows:**
- `yarn build`: Complete production build (extensions → plugins → applications, sequential)
- `yarn build:dev`: Complete development build (extensions → plugins → applications, parallel)
- `yarn build:fresh`: Clean build artifacts + plugins and perform complete build
- `yarn build:fresh:dev`: Clean build artifacts + plugins and perform complete development build
- `yarn build:prepare`: Build extensions and download plugins (preparation step)
- `yarn build:applications`: Build both browser and electron apps in production mode
- `yarn build:applications:dev`: Build both apps in development mode (parallel)
- `yarn build:extensions`: Build all custom extensions in the `extensions/*` folder

**Development tools:**
- `yarn browser <command>`: Direct access to browser-app scripts (e.g., `yarn browser build`, `yarn browser start`)
- `yarn electron <command>`: Direct access to electron-app scripts (e.g., `yarn electron build:dev`, `yarn electron watch`)
- `yarn rebuild`: Recompile native modules for both applications (use after Node.js/Electron updates)
- `yarn watch`: Run both application watch modes in parallel
- `yarn watch:extensions`: Watch all extensions for changes

**Quality assurance:**
- `yarn test`: Run test suites for both applications
- `yarn test:extensions`: Run tests for all extensions
- `yarn lint`: Code quality checks across applications
- `yarn lint:fix`: Automatic code fixing when possible
- `yarn lint:extensions`: Lint all extensions
- `yarn lint:extensions:fix`: Auto-fix linting issues in extensions

**Maintenance:**
- `yarn prepare`: Check Theia compatibility, run package preparation.
- `yarn download:plugins`: Refresh VSX plugin cache from `theiaPlugins` configuration
- `yarn clean`: Clean build artifacts (preserves node_modules and plugins)
- `yarn clean:plugins`: Remove downloaded plugins folder
- `yarn clean:deps`: Remove node_modules (use when having dependency issues)

### Browser app (`browser-app/package.json`)

Executed with `yarn workspace browser-app run <script>` or `yarn browser <script>`:

- `build`: Production build with native module rebuild
- `build:dev`: Development build with source maps and debugging info
- `rebuild`: Recompile native modules for browser target
- `watch`: Continuous development rebuilds with file watching
- `start`: Launch the browser backend serving at `http://localhost:3000`
- `clean`: Remove generated build artifacts
- `test`, `lint`, `lint:fix`: Placeholder commands for future testing and linting setup

### Electron app (`electron-app/package.json`)

Executed with `yarn workspace electron-app run <script>` or `yarn electron <script>`:

**Development commands:**
- `build`: Production build optimized for Electron runtime
- `build:dev`: Development build with debugging capabilities
- `rebuild`: Recompile native modules for Electron target
- `watch`: Parallel TypeScript and Theia watchers for rapid development
- `start`: Launch the Electron application with local plugin support
- `clean`: Clean Electron-specific build outputs
- `test`, `lint`, `lint:fix`: Placeholder commands for future testing and linting setup

**Packaging commands:**
- `package`: Create production package
- `package:preview`: Build and package a preview version

### User state management

Special commands for managing application settings and persistent data:

- `yarn clean:browser:settings`: Reset browser application settings (`.browser-app` folder)
- `yarn clean:electron:settings`: Reset electron application settings (`.electron-app` folder)
- `yarn clean:electron:persistent`: Clear electron persistent state (`~/.config/electron-app`)
- `yarn clean:electron:fresh`: Complete electron reset (settings + persistent state)
- `yarn clean:analyze`: Analyze current storage usage across all components

## Development workflow

### Initial setup

```bash
yarn install                 # Install dependencies + check Theia + download plugins
yarn build:dev              # Complete development build of both applications
```

### Working with extensions only

When developing custom extensions in the `extensions/` folder:

```bash
# Development cycle
yarn build:extensions       # Build all extensions
yarn watch:extensions       # Watch extensions for changes

# Before testing in applications
yarn download:plugins       # Refresh plugins if needed
yarn browser build:dev      # Build browser app
yarn browser start          # Test in browser

# or for electron
yarn electron build:dev     # Build electron app
yarn electron start         # Test in electron
```

### Working with browser application only

```bash
# One-time preparation (if extensions/plugins changed)
yarn build:prepare          # Build extensions + download plugins. If changed, run again

# Development cycle
yarn browser build:dev      # Development build
yarn browser watch          # Continuous development (watches for changes)
yarn browser start          # Launch application

# Production build
yarn browser build          # Production build
```

### Working with electron application only

```bash
# One-time preparation (if extensions/plugins changed)  
yarn build:prepare          # Build extensions + download plugins. If changed, run again

# Development cycle
yarn electron build:dev     # Development build
yarn electron watch         # Continuous development (watches for changes) 
yarn electron start         # Launch application

# Production build
yarn electron build         # Production build
```

### Full development workflow

When working on multiple components simultaneously:

```bash
# Complete development setup
yarn build:dev              # Build everything in development mode
yarn watch                  # Watch both applications

# Or watch selectively
yarn watch:extensions       # Terminal 1: Watch extensions
yarn browser watch          # Terminal 2: Watch browser app
yarn electron watch         # Terminal 3: Watch electron app
```

### Production builds

```bash
# Complete production build
yarn build                  # Extensions + plugins + applications (optimized)

# Individual production builds
yarn browser build          # Browser production build
yarn electron build         # Electron production build
```

### Production packaging (Electron only)

Create distributable packages for end users:

```bash
# Production packages for distribution
yarn electron package       # Create production package

# Development/testing packages
yarn electron package:preview  # Package without publishing (for testing)
```

### Cleaning strategies

Choose the appropriate cleaning level based on your needs:

```bash
# Light cleaning (daily development)
yarn clean                  # Remove build artifacts only

# Plugin management
yarn clean:plugins          # Remove plugins before fresh download
yarn build:fresh:dev        # Clean + rebuild in development

# Deep cleaning (dependency issues)
yarn clean
yarn clean:deps             # Remove node_modules only

# Application-specific cleaning

### Native module rebuilds

When you update Node.js, Electron, or switch architectures:

```bash
yarn rebuild                # Rebuild native modules for both apps
yarn rebuild:browser        # Browser-specific rebuild  
yarn rebuild:electron       # Electron-specific rebuild
```


### Dependency updates

If you change a lot of dependencies and Yarn starts giving incompatibility issues with new packages or some versions, try doing the following:

```bash
# For dependency updates (only when needed):
rm -rf node_modules yarn.lock */node_modules */yarn.lock

yarn install # Regenerates locks with latest compatible versions
```

## Building for production

### Browser Application Deployment

The browser application is designed for server deployment and doesn't require special packaging, as far as we know at the moment.

> #todo: The browser app will serve at `http://localhost:3000` by default. Check how to deploy browser app in a server with a custom IP and domain.

### Electron Application Deployment

The electron application requires packaging into distributable formats for end-user installation.

#### Basic Packaging

```bash
# Complete packaging workflow
yarn electron build         # Ensure production build
yarn electron package       # Create all distributables
```

This creates platform-specific packages in `electron-app/dist/`:
- **Windows**: `.exe` installer (NSIS-based)
- **macOS**: `.dmg` disk image  
- **Linux**: `.AppImage` portable executable

> #todo: Check for builder settings to customize installation and final product. 

## Adding dev dependencies 

#todo ver como integrar aqui tailwind css

## Debugging

linting, y todas las dev dependencies tmb hay que mirarlo

