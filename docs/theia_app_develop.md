# Theia Application Development Guide

This guide provides comprehensive information on developing Theia applications, including project structure, examples, development guidelines, and best practices.

**Main sources:**
- https://theia-ide.org/docs/composing_applications/
- https://github.com/eclipse-theia/theia/blob/master/doc/Developing.md
- https://github.com/eclipse-theia/theia/blob/master/doc/coding-guidelines.md

## Prerequisites

### System Requirements

- **Node.js**: `>= 20` and `< 24` with both nvm and yarn
```
nvm install --lts
nvm use --lts
npm install -g yarn
```

- **git**: Version 2.11.0 or higher (for Git extension support)
- **Python3**: Required for the build due to [`node-gyp`](https://github.com/nodejs/node-gyp/tree/v11.4.0#installation)

### Linux-specific Dependencies

```bash
# Build tools
sudo apt-get install build-essential
sudo apt-get install make gcc pkg-config

# Native module dependencies
sudo apt-get install libx11-dev libxkbfile-dev    # for native-keymap
sudo apt-get install libsecret-1-dev              # for keytar
```

### Recommended Tools

- [nvm](https://github.com/nvm-sh/nvm): For easy Node.js version switching
- [VS Code](https://code.visualstudio.com/): Recommended IDE for development

## Creating a New Theia Application

> **Disclaimer**: this template now defaults to **Yarn classic** just like the upstream Theia repo. All commands in this guide assume Yarn unless explicitly noted otherwise.

### Create the project 

To build a theia app from scratch, the generator mentioned in [[theia_overall]] is used. The installation of the generator is with the following command:

```bash
npm install -g yo generator-theia-extension
```

And to create a project structure with a hello world extension:

```bash
npm install -g yo generator-theia-extension
mkdir my-theia-app
cd my-theia-app
yo theia-extension # select the 'Hello World' option and complete the prompts
```

In this way we have the base of an application that we can now expand with our own extensions.
(Note that if you only want an empty application without hello world, you can select the option No extension in the menu)

### Project structure

There are three main directories in the empty project (three theia extensions)

- browser-app: The definitions of your custom Theia application running in the browser. It contains the build that can be deployed in a web server.
- electron-app: The definitions of your custom Theia application running on the desktop. It contains the build that can be packaged as a desktop application.
- hello-world: The generated example extension, see [this guide](https://theia-ide.org/docs/authoring_extensions) for more details, but you can move it to a extensions folder or even delet it if you don't need it.

This is the basic structure of the generated project, but you can add more extensions as needed. A typical structure could be:

```my-theia-app/
├── browser-app/
│   ├── package.json 
│   ├── tsconfig.json
│   └── ... (other config files)
├── electron-app/
│   ├── package.json
│   ├── tsconfig.json
│   └── ... (other config files)
├── extensions/
│   ├── my-extension-1/
│   │   ├── package.json
│   │   ├── src/
│   │   └── ... (other files)
│   ├── my-extension-2/
│   │   ├── package.json
│   │   ├── src/
│   │   └── ... (other files)
│   └── ... (more extensions)
├── package.json
├── tsconfig.json
```

In which - `browser-app` and `electron-app` contain the specific configurations for each application type, and `extensions` contains custom extensions developed for the application.

### Execute the project

#### In the Browser:

```bash
yarn install

yarn build:browser
yarn start:browser
```

Then enter http://localhost:3000/ to see the minimalist app

#### In desktop:

```bash
yarn install

yarn build:electron
yarn start:electron
```

> **It is highly possible that if you are using theia provided generator there are a lot of extensions out of date, so I reccommend using Nodeably theia template on github, as it fixes vulnerabilities and has updated dependencies!!!**
#### Note on available scripts

Depending on if you are working with the empty application or with the Theia IDE, the scripts may vary. You can consult the available scripts in the package.json of each application (browser-app/package.json or electron-app/package.json), as well as in the root package.json. The structure of the commands is usually similar, but the names may vary.

> Always check the relevant `package.json` for available scripts, as names and options may differ between browser and electron apps, and between different project templates used.

### Nodeably Empty Theia Template

To simplify the creation of a Theia application, a minimal template has been created that includes only the necessary dependencies to run a Theia application in both browser and electron, as well as the support for VSCode extensions and a already organized extensions folder that will allow to include in the project any extension inside it:


## Adding Theia Extensions

The first thing here is that dependencies are set in the corresponding package.json of the application (browser-app or electron-app) and not in the extensions themselves. 

This means that, even if you only have 1 repository, **the browser app and the electron app are independent**. In that way, you can have different extensions in each of them if you want.

> It does not matter if the extension is in the same repository or in a different one, the important thing is that it is added as a dependency of the application in the corresponding package.json.

### Existing Theia Extensions

To add an already available theia extension, for example the workspace extension, you only need to add it as a dependency in the package.json of the application you want to add it to (browser-app or electron-app):

If you want to add it to both, you need to add it to both package.json files.

```json
{
  "dependencies": {
    "@theia/workspace": "^1.65.0",
    "@theia/other-extension": "^x.x.x"
  }
}
```

Then run `yarn install` to install the new dependency and rebuild the application with `yarn build:browser` or `yarn build:electron` depending on which application you are working on.


### Custom Theia Extensions

To create your own extensions, please see [[theia_extension_dev]] for more details. After an extension is created, you need to add it to the workspace and as a dependency of the application as explained above.

You can maintain your extensions in a folder inside the project, for example in an `extensions` folder at the root of the project, or you can have them in a separate repository and add them as git submodules or using npm/yarn workspaces.

If you have a monorepo with your custom extensions inside, you need to add the extension folder to the `workspaces` property of the root package.json, for example:

```json
{
  "workspaces": [
    "browser-app", "electron-app", "extensions/*"
  ]
}
```
This will tell Yarn to include all the extensions in the `extensions` folder as part of the workspace.

Then, as explained above, you need to add the extension as a dependency of the application(s) you want to include it in (browser-app or electron-app).

## Adding VSCode Extensions

### Prerequisites

> **Important:** If you are using the empty application generated as base, this is not included by default, so you need to add it as explained below.

To add a VSCode extension from the marketplace, you need to add the `@theia/plugin-ext` and `@theia/plugin-ext-vscode` extensions to your application first, as they provide the support for VSCode extensions.

**Browser/Electron application package.json:**
```json
{
  "dependencies": {
    "@theia/plugin-ext": "^1.65.0",
    "@theia/plugin-ext-vscode": "^1.65.0",
  }
}
```
Then you need to define a plugins location. This is done in the theia start script in the package.json of the application, for example in electron-app/package.json, or in browser-app/package.json:

**Browser/Electron application package.json:**
```json

  "scripts": {
    ...
    "start": "theia start --plugins=local-dir:../plugins",
  },

```

This will tell Theia to look for plugins in the `plugins` folder at the root of the project. You can change this path as needed. Note that, after a fresh install this folder does not exist and will be created by Theia during the first `yarn install`, but if you want to remove a plugin **you may need to delete it manually and rebuild after removing the dependency from package.json**.

Now there are two ways of integrating the extensions:

### Pre-installed extensions

These are downloaded and packaged with the application. They are defined in the `theiaPlugins` property of the package.json of the application. For this, you have to do a couple of things in the root package.json:

1. specify the plugins location to the Theia CLI
2. define the VS Code extensions to be downloaded
3. add a download script for convenience

>Note that all the plugins will be downloaded to the folder specified, and if you tell both applications to look in the same folder, they will share the same plugins always.

**Root package.json:**

```json
{
  ...
  "scripts": {
    "download:plugins": "theia download:plugins",
    ...
  },
  "theiaPluginsDir": "plugins",
  "theiaPlugins": {
      "my-hello-world-extension": "https://<url-to-your-published-extension>",
      "vscode.git": "https://open-vsx.org/api/vscode/git/1.52.1/file/vscode.git-1.52.1.vsix",
      ...
  }
}
```
As a result, running `yarn run download:plugins` will download any listed extensions and place them into the folder specified in `theiaPluginsDir` automatically.

> **Note:** For the built-in VS Code extensions to work, you need to run the `download:plugins` script before building the project. Because it is part of the `build:prepare` script in our template, it runs automatically when you execute `yarn build:prepare`. If the download is skipped, the extensions will not be available in the application.

Also, you can exclude some plugins of an extension pack using the `theiaPluginsExcludeIds` property in the package.json:

```json
{
	"theiaPluginsExcludeIds":[
		"plugin-to-exclude-1",
		"plugin-to-exclude-2"
	],
}
```

### Post-install extensions

This allows users to install extensions after the application is built and deployed, for example through the command palette or the extensions view. For this, you only need to have the `@theia/vsx-registry` extension installed in your application, as it provides the marketplace support.

**Browser/Electron application package.json:**

```json

{
  "dependencies": {
    "@theia/vsx-registry": "latest",
  }
}
```

### Removing Extensions

To remove an extension, you need to do the following:

1. Remove the extension from the `theiaPlugins` property in the package.json if it is a pre-installed extension.
2. Delete the extension from the plugins folder if it is a pre-installed extension.
3. Rebuild the application with `yarn build:prepare && yarn browser/electron build` depending on which application you are working on.

> As mentioned before, if you remove a pre-installed extension, you may need to delete it manually from the plugins folder and then recompile the application to ensure it is completely removed. This does not happen with post-installation ones, neither with theia extensions. But in vscode extensions it may be necessary.

## Available Theia Extensions

Theia provides a rich ecosystem of extensions. At the moment there is no list of all extensions, but those are located on [npm](https://www.npmjs.com/search?q=%40theia%2F) and can be searched for there.

Here is a list of some commonly used Theia extensions, you can also refer to the [Theia examples](#understanding-theia-examples) section to see which extensions are included in each example application, or check the [Theia IDE](https://www.github.com/theia/theia-ide) repository, and then the package.json file to see the extensions used in that project.

### Core Extensions
- `@theia/core`: Essential framework components
- `@theia/editor`: Text editor functionality
- `@theia/filesystem`: File system operations
- `@theia/workspace`: Workspace management

### Editor Extensions
- `@theia/monaco`: Monaco editor integration
- `@theia/editor-preview`: File preview capabilities
- `@theia/outline-view`: Code structure navigation

### Development Tools
- `@theia/debug`: Debugging support
- `@theia/task`: Task runner integration
- `@theia/terminal`: Integrated terminal
- `@theia/git`: Git integration
- `@theia/scm`: Source control management

### AI Extensions (Latest)
- `@theia/ai-chat`: AI chat integration
- `@theia/ai-code-completion`: AI-powered code completion
- `@theia/ai-openai`: OpenAI integration
- `@theia/ai-anthropic`: Anthropic Claude integration

### UI Extensions
- `@theia/navigator`: File explorer
- `@theia/preferences`: Settings UI
- `@theia/toolbar`: Customizable toolbar
- `@theia/mini-browser`: Embedded browser

### Plugin System
- `@theia/plugin-ext`: VS Code extension support
- `@theia/plugin-ext-vscode`: VS Code API compatibility
- `@theia/vsx-registry`: Extension marketplace


## Understanding Theia Examples

The Theia repository includes several example applications that demonstrate different configurations, those are located in examples folder in [theia](https://github.com/eclipse-theia/theia) repository, that can be consulted for more info:

### Browser Example (`examples/browser/`)
- **Purpose**: Full-featured browser-based IDE
- **Features**: Includes most Theia extensions for a complete IDE experience
- **Key Extensions**: AI chat, editor, filesystem, debug, terminal, git, etc.
- **Configuration**: Optimized for browser deployment

### Electron Example (`examples/electron/`)
- **Purpose**: Desktop application with native features
- **Additional Features**: External terminal support, WSL remote capabilities
- **Platform Integration**: Native file system access, OS integration

### API Samples (`examples/api-samples/`)
- **Purpose**: Demonstrates Theia API usage
- **Content**: Extension examples for common use cases
- **Learning Resource**: Best practices for extension development

### Browser-Only Example (`examples/browser-only/`)
- **Purpose**: Minimal browser application
- **Use Case**: Lightweight web-based editor
- **Dependencies**: Reduced set of extensions

Additionally, in the repository documentation about [development](https://github.com/eclipse-theia/theia/blob/master/doc/Developing.md) more information about building, debugging, etc and working with examples in general is provided

