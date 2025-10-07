# Theia Package.json Configuration Properties

This document describes all available configuration properties under the `theia` field in package.json for Theia applications. These properties allow you to customize the behavior and appearance of both browser and electron targets.

## Structure Overview

The `theia` configuration in package.json follows this structure:

```json
{
  "theia": {
    "target": "browser|electron",
    "frontend": {
      "config": { /* Frontend configuration */ }
    },
    "backend": {
      "config": { /* Backend configuration */ }
    },
    "generator": {
      "config": { /* Generator configuration */ }
    }
  }
}
```

## Target Property

### `target`
- **Type**: `"browser"` | `"electron"` | `"browser-only"`
- **Default**: `"browser"`
- **Description**: Specifies whether the extension targets the browser or electron environment.

```json
{
  "theia": {
    "target": "electron"
  }
}
```

## Frontend Configuration

All frontend configurations are placed under `theia.frontend.config`:

### Application Properties

#### `applicationName`
- **Type**: `string`
- **Default**: `"Eclipse Theia"`
- **Description**: The display name of the application shown in the title bar and about dialog.

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

#### `defaultTheme`
- **Type**: `string` | `{ light: string, dark: string }`
- **Default**: `{ light: "light", dark: "dark" }`
- **Description**: The default color theme for the application.

```json
{
  "theia": {
    "frontend": {
      "config": {
        "defaultTheme": "dark"
      }
    }
  }
}
```

Or for OS-aware theming:

```json
{
  "theia": {
    "frontend": {
      "config": {
        "defaultTheme": {
          "light": "light-plus",
          "dark": "dark-plus"
        }
      }
    }
  }
}
```

#### `defaultIconTheme`
- **Type**: `string`
- **Default**: `"theia-file-icons"`
- **Description**: The default icon theme for file explorer and editor tabs.

```json
{
  "theia": {
    "frontend": {
      "config": {
        "defaultIconTheme": "vs-seti"
      }
    }
  }
}
```

#### `defaultLocale`
- **Type**: `string`
- **Default**: `""`
- **Description**: The default locale/language for the application.

```json
{
  "theia": {
    "frontend": {
      "config": {
        "defaultLocale": "es"
      }
    }
  }
}
```

#### `validatePreferencesSchema`
- **Type**: `boolean`
- **Default**: `true`
- **Description**: When true, validates the JSON schema of preferences on start and logs warnings if invalid.

#### `reloadOnReconnect`
- **Type**: `boolean`
- **Default**: `false`
- **Description**: When true, the window reloads if the frontend reconnects to a backend that has lost the connection context.

#### `uriScheme`
- **Type**: `string`
- **Default**: `"theia"`
- **Description**: The custom URI scheme the application registers in the operating system.

### Default Preferences

#### `preferences`
- **Type**: `object`
- **Description**: Default values for application preferences that override user settings.

```json
{
  "theia": {
    "frontend": {
      "config": {
        "preferences": {
          "files.enableTrash": false,
          "toolbar.showToolbar": true,
          "security.workspace.trust.enabled": false
        }
      }
    }
  }
}
```

### Security Settings

#### `warnOnPotentiallyInsecureHostPattern`
- **Type**: `boolean`
- **Default**: `true`
- **Description**: Whether to warn about potentially insecure host patterns.

```json
{
  "theia": {
    "frontend": {
      "config": {
        "warnOnPotentiallyInsecureHostPattern": false
      }
    }
  }
}
```

### Electron-Specific Frontend Configuration

#### `electron`
- **Type**: `object`
- **Description**: Configuration specific to Electron applications.

##### `electron.windowOptions`
- **Type**: `BrowserWindowConstructorOptions`
- **Default**: `{}`
- **Description**: Override or add properties to Electron's window options.

```json
{
  "theia": {
    "frontend": {
      "config": {
        "electron": {
          "windowOptions": {
            "titleBarStyle": "hidden",
            "webPreferences": {
              "contextIsolation": true
            }
          }
        }
      }
    }
  }
}
```

##### `electron.showWindowEarly`
- **Type**: `boolean`
- **Default**: `true`
- **Description**: Whether to show an empty Electron window as early as possible.

##### `electron.splashScreenOptions`
- **Type**: `object`
- **Description**: Configuration for the splash screen.

```json
{
  "theia": {
    "frontend": {
      "config": {
        "electron": {
          "splashScreenOptions": {
            "width": 640,
            "height": 480,
            "minDuration": 1000,
            "maxDuration": 30000,
            "content": "./resources/splash.html"
          }
        }
      }
    }
  }
}
```

###### Splash Screen Properties:
- **`width`**: Initial width of splash screen (default: 640)
- **`height`**: Initial height of splash screen (default: 480)
- **`minDuration`**: Minimum time in ms to show splash (default: 0)
- **`maxDuration`**: Maximum time in ms before removing splash (default: 30000)
- **`content`**: Path to content file (relative to application root)

##### `electron.uriScheme`
- **Type**: `string`
- **Default**: `"theia"`
- **Description**: Custom URI scheme for the Electron application.

## Backend Configuration

All backend configurations are placed under `theia.backend.config`:

### `singleInstance`
- **Type**: `boolean`
- **Default**: `true`
- **Description**: If true and in Electron mode, only one instance of the application is allowed to run.

### `frontendConnectionTimeout`
- **Type**: `number`
- **Default**: `0`
- **Description**: Time in milliseconds the connection context will be preserved for reconnection after frontend disconnects. Use `-1` for no timeout.

### `configurationFolder`
- **Type**: `string`
- **Default**: `".theia"`
- **Description**: Configuration folder name within the user's home directory.

```json
{
  "theia": {
    "backend": {
      "config": {
        "configurationFolder": ".my-ide",
        "frontendConnectionTimeout": 3000,
        "singleInstance": false
      }
    }
  }
}
```

### `startupTimeout`
- **Type**: `number`
- **Default**: `undefined`
- **Description**: Maximum time to wait for application startup. Use `-1` for no timeout.

### `warnOnPotentiallyInsecureHostPattern`
- **Type**: `boolean`
- **Default**: `true`
- **Description**: Whether to warn about potentially insecure host patterns in backend.

## Generator Configuration

### `generator`
- **Type**: `object`
- **Description**: Configuration for the Theia application generator.

#### `generator.config.preloadTemplate`
- **Type**: `string`
- **Default**: `""`
- **Description**: Template to use for extra preload content markup (file path or HTML).

```json
{
  "theia": {
    "generator": {
      "config": {
        "preloadTemplate": "./resources/preload.html"
      }
    }
  }
}
```

## NPM Registry Properties

### `next`
- **Type**: `boolean`
- **Default**: `false`
- **Description**: If set to true, Theia will prefer `next` over `latest` as the latest tag.

### `registry`
- **Type**: `string`
- **Default**: `"https://registry.npmjs.org/"`
- **Description**: NPM registry URL to use for package resolution.

```json
{
  "theia": {
    "next": true,
    "registry": "https://my-custom-registry.com/"
  }
}
```

## Complete Example

Here's a comprehensive example showing various configuration options:

```json
{
  "theia": {
    "target": "electron",
    "next": false,
    "frontend": {
      "config": {
        "applicationName": "My Custom IDE",
        "defaultTheme": {
          "light": "light-plus",
          "dark": "dark-plus"
        },
        "defaultIconTheme": "vs-seti",
        "defaultLocale": "en",
        "reloadOnReconnect": true,
        "preferences": {
          "files.enableTrash": false,
          "toolbar.showToolbar": true,
          "security.workspace.trust.enabled": false
        },
        "electron": {
          "showWindowEarly": false,
          "windowOptions": {
            "titleBarStyle": "hidden"
          },
          "splashScreenOptions": {
            "content": "./resources/splash.html",
            "width": 800,
            "height": 600
          }
        }
      }
    },
    "backend": {
      "config": {
        "configurationFolder": ".my-ide",
        "frontendConnectionTimeout": 3000,
        "startupTimeout": -1,
        "singleInstance": true,
        "resolveSystemPlugins": false
      }
    },
    "generator": {
      "config": {
        "preloadTemplate": "./resources/preload.html"
      }
    }
  }
}
```

## References

- [Theia CLI Documentation](https://github.com/eclipse-theia/theia/tree/master/dev-packages/cli)
- [Application Properties TypeScript Definitions](https://github.com/eclipse-theia/theia/blob/master/dev-packages/application-package/src/application-props.ts)
- [Electron BrowserWindow Options](https://www.electronjs.org/docs/api/browser-window#new-browserwindowoptions)