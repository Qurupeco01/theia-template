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

## Package.json Theia app configuration

## Development tools

## Commands and scripts

## Building for production


## Adding dev dependencies 

#todo ver como integrar aqui tailwind css

## Debugging

linting, y todas las dev dependencies tmb hay que mirarlo