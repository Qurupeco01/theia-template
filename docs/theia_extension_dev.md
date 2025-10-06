source: https://theia-ide.org/docs/authoring_extensions/

#todo añadir contribuciones de ajustes default 
# Authoring Theia Extensions

This guide covers the process of creating custom Theia extensions and deploying them in Theia-based applications.

## Prerequisites

Before starting, make sure you understand:
- How to create a Theia-based application (see [[theia_app_develop]])
- Different extension mechanisms (Plugins vs Extensions) - see [[theia_overall]]
- Prerequisites from the [Theia repository](https://github.com/eclipse-theia/theia/blob/master/doc/Developing.md)

## Project Layout

Use the Yeoman Generator to create a Theia project with example extensions:

```bash
npm install -g yo generator-theia-extension
yo theia-extension # select 'Hello World' option
```

This generates a project with the standard structure including a `hello-world` extension example.

## Extension Structure

### Package.json Configuration

A Theia extension is an npm package with specific characteristics:

```json
{
  "name": "hello-world",
  "keywords": [
    "theia-extension"  // 🔑 Key identifier for Theia apps
  ],
  "version": "0.0.0",
  "files": ["lib", "src"],
  "dependencies": {
    "@theia/core": "latest"
  },
  "devDependencies": {
    "rimraf": "latest",
    "typescript": "~5.4.5"
  },
  "scripts": {
    "prepare": "yarn run clean && yarn run build",
    "clean": "rimraf lib",
    "build": "tsc",
    "watch": "tsc -w"
  },
  "theiaExtensions": [
    {
      "frontend": "lib/browser/hello-world-frontend-module"
    }
  ]
}
```

### Key Elements:
- **`theia-extension` keyword**: Allows Theia apps to identify and install the extension
- **`theiaExtensions` property**: Lists JavaScript modules that export DI modules
- **Frontend/Backend separation**: Extensions can contribute to frontend, backend, or both 

## Dependency Injection Architecture

Theia uses **dependency injection** for modular architecture:

1. **Extension defines DI modules** - binds implementations to interfaces
2. **Global DI container** - created from union of all modules (frontend + backend)
3. **Multi-inject collection** - runtime collects contributions by type

### Frontend Module Example

```javascript
export default new ContainerModule(bind => {
    bind(CommandContribution).to(HelloWorldCommandContribution);
    bind(MenuContribution).to(HelloWorldMenuContribution);
});
```

## Creating Contributions

### Command Contribution

Commands are data structures with ID and label, with behavior implemented via handlers:

```javascript
export const HelloWorldCommand = {
    id: 'HelloWorld.command',
    label: "Shows a message"
};

@injectable()
export class HelloWorldCommandContribution implements CommandContribution {
    constructor(
        @inject(MessageService) private readonly messageService: MessageService,
    ) { }

    registerCommands(registry: CommandRegistry): void {
        registry.registerCommand(HelloWorldCommand, {
            execute: () => this.messageService.info('Hello World!')
        });
    }
}
```

### Menu Contribution

Add UI access to commands through menu contributions:

```javascript
@injectable()
export class HelloWorldMenuContribution implements MenuContribution {
    registerMenus(menus: MenuModelRegistry): void {
        menus.registerMenuAction(CommonMenus.EDIT_FIND, {
            commandId: HelloWorldCommand.id,
            label: 'Say Hello'
        });
    }
}
```

## Integration Patterns

### Dependency Injection Benefits
- **No lifecycle management** - framework handles it
- **Service location abstraction** - just declare what you need with `@inject`
- **Loose coupling** - depends on interfaces, not implementations

### Available Contribution Interfaces
Browse the documentation for `*Contribution` interfaces to see extensibility points:
- `CommandContribution` - Register commands
- `MenuContribution` - Add menu items  
- `KeybindingContribution` - Define shortcuts
- `WidgetFactory` - Create custom widgets
- And many more...

## Adding Extensions to Applications

### In Application Package.json
```json
{
  "name": "browser-app",
  "dependencies": {
    "@theia/core": "latest",
    "hello-world": "0.0.0"  // Your extension
  },
  "scripts": {
    "build": "theia build --mode development",
    "start": "theia start"
  }
}
```

## Deployment Options

### Option 1: Monorepo Structure (Recommended for Development)
- Extension lives alongside Theia application
- Created automatically by Yeoman Generator
- Easy development and testing

### Option 2: Published Package
```bash
yarn publish          # Publish extension to npm
yarn add my-extension # Install in Theia app
```

## Example: "Hello World" Extension

**Goal**: Add menu item "Say Hello" that shows notification "Hello world!"

**Components needed**:
1. **Command** - defines the action
2. **Command Handler** - implements the behavior  
3. **Menu Contribution** - adds UI access
4. **DI Module** - wires everything together

**Result**: Working extension that demonstrates the full Theia extension pattern

## Best Practices

- **Start with Yeoman Generator** - provides correct structure
- **Use dependency injection** - leverage `@inject` for services
- **Follow contribution interfaces** - implement standard patterns
- **Separate concerns** - commands, menus, and handlers in logical groups
- **Test in monorepo first** - before publishing as separate package

## Related Topics

- [[theia_app_develop]] - Creating Theia applications from scratch
- [[theia_overall]] - Overview of Theia architecture and extension types

