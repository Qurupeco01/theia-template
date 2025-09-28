Theia is a platform for developing tools and IDES gives two main options for developing an IDE or tool:

- [Theia Yeoman generator](https://github.com/eclipse-theia/generator-theia-extension): Generates Theia-based applications along with example extensions. (see [[theia_app_develop]])

- [Theia IDE](https://theia-ide.org/#theiaide): A tool based on the Theia Platform that can be used as a template for creating installable desktop applications based on Theia with additional features such as automatic updates, branding, etc..  (see [[theia_expand_ide]])

From those bases, you can build your app by making extensions, and there is some docs related to it:

Useful links:
- [How to build theia and example applications](https://github.com/eclipse-theia/theia/blob/master/doc/Developing.md#quick-start)
- [Build your own IDE/Tool](https://theia-ide.org/docs/composing_applications/)
- [Extending the Theia IDE](https://theia-ide.org/docs/blueprint_documentation/)
- [how to create custom Theia extensions](https://theia-ide.org/docs/authoring_extensions)
- [how to add VS Code extensions to your custom Theia application](https://theia-ide.org/docs/authoring_vscode_extensions).
- [Theia TypeDoc (documentation on types and extensions)](https://eclipse-theia.github.io/theia/docs/next/modules/toolbar.html)

Theia repositories:

- General repo (with examples): https://github.com/eclipse-theia/theia
- IDE: https://github.com/eclipse-theia/theia-ide
- Generator: https://github.com/eclipse-theia/generator-theia-extension
- VSCode extensions: https://github.com/eclipse-theia/vscode-builtin-extensions

## App structure

A theia app is composed of extensions: One theia app = multiple extensions together. Each extension is an npm package, and looks for a functionality:

> One extension is the part of the program that covers one main functionality and provides everything for that: widgets, commands, handlers, etc.

Theia IDE already contains a set of extensions, and those can be customly added to any app by simply integrating them in the project, as well as integrating VSCode extensions in the pre-build app:

> An app can be composed of several theia (core) extensions, but also of VSCode extensions added in pre-compilation by default

Structure is completely different from VSCode for ease of development. See [Theia IDE vs VS Code](https://eclipsesource.com/blogs/2024/07/12/vs-code-vs-theia-ide/) and [Eclipse Theia vs VS Code OSS](https://eclipsesource.com/blogs/2023/09/08/eclipse-theia-vs-code-oss/).

## Guidelines and development guide

Theia already provides some guidelines in the following [link](https://github.com/eclipse-theia/theia/wiki/Coding-Guidelines) for code styling, as well as instructions on [development workflow](https://github.com/eclipse-theia/theia/blob/master/doc/Developing.md) that we can adapt and simplify for us.


## Extensions and plugins

The modularity of Theia apps is achieved through extensions and plugins. There are four types designed for different use cases and they can be mixed together:

### VS Code Extensions

- **Purpose**: Popular mechanism to extend VS Code with new language support and features
- **Compatibility**: Fully compatible with VS Code - same extension API
- **Installation**: Can be pre-installed (built-in) or installed at runtime by users
- **Development**: Simple to develop with access to a defined but restricted API
- **Limitations**: Some use cases not possible due to API restrictions
- **Resources**: 
  - Use existing VS Code extensions from [Open VSX registry](https://open-vsx.org/)
  - Refer to VS Code extension documentation for development
  - Check [Theia's API coverage report](https://eclipse-theia.github.io/vscode-theia-comparator/status.html) for compatibility

### Theia Extensions

- **Purpose**: Core building blocks of Theia applications - even Theia itself is built with these
- **Architecture**: npm packages that expose DI modules (ContainerModule) for dependency injection
- **Installation**: Installed at compile time as dependencies in package.json
- **Access**: Full access to Theia internals via dependency injection - almost no API limitations
- **Use cases**: 
  - Building custom products
  - Features not covered by VS Code extension API
  - Complex views that are easier to develop than with VS Code extensions
- **Modularity**: Allows extending, adapting, or removing almost anything in Theia

(see also [VS Code vs Theia Extensions Comparison](https://eclipsesource.com/blogs/2021/03/24/vs-code-extensions-vs-theia-extensions/) )
### Theia Plugins

- **Purpose**: Special type of VS Code extensions that only run in Eclipse Theia
- **Capabilities**: 
  - Share VS Code extension architecture
  - Access to additional Theia-specific APIs
  - Can directly contribute to frontend, VSCode ones are restricted to backend
  - Direct UI manipulation without webview abstraction
- **Limitation**: Not compatible with VS Code due to Theia-specific parts

**Support for these is under discussion, theia extensions or VSCode Extensions reccommended**

### Headless Plugins

- **Purpose**: Backend-only extensions for CLI interactions and server-side functionality
- **Scope**: Run in Node backend outside of any frontend connection
- **API Access**: 
  - No default access to backend Theia services
  - Only custom APIs explicitly published by the application
- **Use cases**: 
  - CLI interactions without browser frontend
  - Extension of application-specific backend services
- **Architecture**: Similar to VS Code extensions but backend-focused
### To summarize

- **VS Code extensions** → Simple, runtime installable, VS Code compatible, but limited API
- **Theia extensions** → Most powerful, compile-time, full Theia access, for custom products
- **Theia plugins** → Avoid (deprecated), use alternatives instead
- **Headless plugins** → Backend-only, for CLI and server-side extensibility

![[extensiontypes.svg]]


