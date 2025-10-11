# Theia IDE Project `package.json` Scripts Guide

## Introduction
This document summarizes the purpose of each script declared in the project's `package.json` files (`/package.json`, `/applications/browser/package.json` and `/applications/electron/package.json`). Additionally, it describes how the scripts are structured, which tools they invoke, and the meaning of the most relevant arguments so you can modify or reuse them with confidence.

## How `package.json` scripts work
- Each entry in `scripts` follows the structure `"name": "command"`. When running `yarn <name>` (or `npm run <name>`), the command is resolved from the package root.
- You can chain scripts with `&&` (subsequent ones execute only if the previous one succeeded) or with `||` (executes if the previous one fails).
- Environment variables can be defined at the beginning (e.g., `NODE_ENV=production`), respecting the system shell syntax (in Linux/Bash, as in this project, `VAR=value command` is used).
- The most frequently used tools here are:
  - **Lerna** (`lerna <subcommand>`): coordinates scripts in monorepo packages. Key arguments:
    - `run`: executes a homonymous script in multiple packages.
    - `--scope="string"`: limits target packages to those matching the string.
    - `--concurrency <n>`: limits the number of simultaneous processes.
  - **Theia CLI** (`theia <subcommand>`): compiles and serves Theia applications. Common arguments:
    - `build`: packages the application (with `--mode development` or without it for production).
    - `start`: starts the backend + frontend.
    - `rebuild:<target>`: recompiles native addons for the target platform (`browser`, `electron`).
  - **Utility tools**:
    - `rimraf`: cross-platform equivalent of `rm -rf`.
    - `ts-node`: executes TypeScript scripts directly.
    - `concurrently`: launches multiple processes in parallel maintaining labeled output.
    - `electron-builder`, `electron`: package or launch the desktop app.

## Root `package.json` Scripts
| Script | Actual Command | Description | Notable Arguments |
| --- | --- | --- | --- |
| `clean` | `lerna run clean && rimraf node_modules` | Cleans artifacts from all packages and removes root `node_modules` for a fresh start. | `lerna run clean`: executes the `clean` script of each package; `rimraf node_modules`: deletes installed dependencies.
| `build` | `yarn build:extensions && yarn build:applications` | Compiles extensions and applications following the production flow. | Chains scripts defined in this same root.
| `build:dev` | `yarn build:extensions && yarn build:applications:dev` | Same as `build`, but leaving applications in development mode. | `build:applications:dev` uses `lerna run ... build` (dev mode).
| `build:applications` | `yarn build:extensions && lerna run --scope="theia-ide*app" build:prod --concurrency 1` | Ensures extensions are ready and then executes, one by one, the production build of each application (`browser` and `electron`). | `--scope="theia-ide*app"` filters packages whose name starts with `theia-ide` and ends with `app`; `--concurrency 1` avoids simultaneous builds.
| `build:applications:dev` | `yarn build:extensions && lerna run --scope="theia-ide*app" build --concurrency 1` | Same as above but calling the `build` script (development mode) of each app. | Same flags as above.
| `build:extensions` | `lerna run --scope="theia-ide*ext" build` | Compiles all product extensions. | `--scope="theia-ide*ext"` limits to packages ending in `ext`.
| `download:plugins` | `theia download:plugins --rate-limit=15 --parallel=false && yarn permissions:writeable` | Downloads plugins listed in `theiaPlugins` and ensures they have write permissions. | `--rate-limit=15` controls requests per minute to marketplace; `--parallel=false` forces sequential downloads.
| `package:applications` | `lerna run --scope="theia-ide*app" package --concurrency 1` | Generates distribution artifacts (installers, packaged files) in default mode. | Like other `lerna run` commands, serializes execution.
| `package:applications:preview` | `lerna run --scope="theia-ide*app" package:preview --concurrency 1` | Produces packages in "preview" mode (usually unsigned and ready for testing). | `package:preview` is a script specific to each application.
| `package:applications:prod` | `lerna run --scope="theia-ide*app" package:prod --concurrency 1` | Generates artifacts ready for final distribution (signatures, definitive configurations). | Same as above.
| `permissions:writeable` | `ts-node scripts/make-files-writeable.ts plugins` | Adjusts permissions of downloaded plugins to allow local modifications. | The `plugins` argument indicates the target folder.
| `watch` | `lerna run --parallel watch` | Launches all `watch` scripts of packages in parallel for hot development. | `--parallel` avoids queuing and shows labeled logs.
| `test` | `lerna run test` | Executes test suites of each package that has a `test` script. | Inherits configuration from each package.
| `electron` | `yarn --cwd applications/electron` | Delegation to the Electron package's `package.json`; installs dependencies and exposes its scripts. | `--cwd` changes to the given directory before executing Yarn.
| `browser` | `yarn --cwd applications/browser` | Same as `electron`, but for the web app. | —
| `package:applications:preview` | `lerna run --scope="theia-ide*app" package:preview --concurrency 1` | Produce paquetes en modo “preview” (normalmente sin firma y listos para pruebas). | `package:preview` es un script propio de cada aplicación.
| `package:applications:prod` | `lerna run --scope="theia-ide*app" package:prod --concurrency 1` | Genera artefactos listos para distribución final (firmas, configuraciones definitivas). | Igual que los anteriores.
| `permissions:writeable` | `ts-node scripts/make-files-writeable.ts plugins` | Ajusta permisos de los plugins descargados para permitir modificaciones locales. | El argumento `plugins` indica la carpeta objetivo.
| `watch` | `lerna run --parallel watch` | Lanza todos los scripts `watch` de los paquetes en paralelo para desarrollo en caliente. | `--parallel` evita la cola y muestra logs etiquetados.
| `test` | `lerna run test` | Ejecuta las suites de pruebas de cada paquete que tenga script `test`. | Hereda la configuración de cada paquete.
| `electron` | `yarn --cwd applications/electron` | Delegación al `package.json` del paquete Electron; instala dependencias y expone sus scripts. | `--cwd` cambia al directorio dado antes de ejecutar Yarn.
| `browser` | `yarn --cwd applications/browser` | Igual que `electron`, pero para la app web. | —
| `update:theia` | `ts-node scripts/update-theia-version.ts` | Executes the script that synchronizes all `@theia/*` dependency versions. | Allows passing version as argument (via standard `ts-node` CLI).
| `update:theia:children` | `lerna run update:theia -- ` | Propagates the `update:theia` script in child packages. | The `--` separates extra arguments, which can be added at the end when executing the script.
| `update:next` | `ts-node scripts/update-theia-version.ts next && lerna run update:next` | Updates dependencies to Theia's `next` branch and synchronizes secondary packages. | Combines `ts-node` and `lerna`.
| `lint` | `eslint --ext js,jsx,ts,tsx scripts && lerna run lint` | Lints root scripts and then each package. | `--ext` defines analyzed extensions.
| `lint:fix` | `eslint --ext js,jsx,ts,tsx scripts --fix && lerna run lint:fix` | Same as `lint`, but attempting to auto-correct errors when possible. | `--fix` enables automatic corrections.
| `license:check` | `npx dash-licenses-wrapper  --configFile=./configs/license-check-config.json` | Verifies license status according to corporate configuration. | `--configFile` points to the rules file.
| `license:check:review` | `npx dash-licenses-wrapper  --configFile=./configs/license-check-config.json --review` | Generates an interactive/manual license review report. | `--review` opens review mode.
| `postinstall` | `theia-patch` | Hook that runs after each `yarn install` to apply custom patches included in `patches/`. | This command is provided by `@theia/cli`.

## `applications/browser/package.json` Scripts
| Script | Actual Command | Description | Notable Arguments |
| --- | --- | --- | --- |
| `clean` | `theia clean && rimraf node_modules` | Removes generated artifacts and local dependencies from the web app. | `theia clean` deletes the compilation folder according to configuration; `rimraf` removes dependencies.
| `build` | `yarn -s rebuild && theia build --app-target="browser" --mode development` | Rebuilds native dependencies, then creates a development bundle for browser. | `yarn -s` silences logs; `--app-target="browser"` indicates web target; `--mode development` preserves sourcemaps.
| `build:prod` | `yarn -s rebuild && theia  build --app-target="browser"` | Same as `build` but generates minified artifacts ready for production. | Without `--mode` production mode is assumed.
| `rebuild` | `theia rebuild:browser --cacheRoot ../..` | Recompiles native binaries (e.g., node-gyp modules) using the shared cache from the monorepo root. | `--cacheRoot ../..` reuses compilations between apps.
| `start` | `theia start --plugins=local-dir:../../plugins` | Starts the backend and serves the web app loading plugins from the local folder. | `--plugins=local-dir:...` registers the local folder of VSX extensions.
| `watch` | `concurrently --kill-others -n tsc,build -c red,yellow "tsc -b -w --preserveWatchOutput" "yarn -s watch:bundle"` | Runs TypeScript in watch mode and the bundler in parallel. | `--kill-others` kills the other process if one fails; `-n` names processes; `-c` colors output; `tsc -b -w` recompiles incrementally; `watch:bundle` is defined by Theia CLI.
| `update:theia` | `ts-node ../../scripts/update-theia-version.ts` | Updates `@theia/*` dependencies specific to the web app. | Inherits optional arguments from the script.
| `update:next` | `ts-node ../../scripts/update-theia-version.ts next` | Same as above but using the `next` tag from the Theia ecosystem. | `next` argument is passed as parameter to the script.

## `applications/electron/package.json` Scripts
| Script | Actual Command | Description | Notable Arguments |
| --- | --- | --- | --- |
| `clean` | `theia clean && rimraf node_modules` | Cleans artifacts and local dependencies from the desktop app. | — |
| `clean:dist` | `rimraf dist` | Deletes the distribution directory generated by `electron-builder`. | — |
| `build` | `yarn -s rebuild && theia build --app-target="electron" --mode development` | Rebuilds native dependencies and compiles the Electron bundle in development mode. | `--app-target="electron"` changes the preset; `--mode` stays in development.
| `build:prod` | `yarn -s rebuild && theia build --app-target="electron"` | Equivalent production-oriented compilation (optimized/minified). | — |
| `rebuild` | `theia rebuild:electron --cacheRoot ../..` | Recompiles native modules adjusted to Electron runtime, using the monorepo cache. | — |
| `watch` | `concurrently -n compile,build "theiaext watch --preserveWatchOutput" "theia build --watch --mode development"` | Keeps the main extension in watch mode (`theiaext watch`) and recompiles the bundle when there are changes. | `--watch` in `theia build` recompiles incrementally; `--preserveWatchOutput` avoids clearing the console.
| `start` | `electron scripts/theia-electron-main.js --plugins=local-dir:../../plugins` | Starts the Electron application pointing to the main executable and loading local plugins. | Arguments after the script are passed to the app (here, `--plugins=...`).
| `start:debug` | `yarn start --log-level=debug` | Reuses the `start` script adding verbose logs: the flag propagates to `electron`. | `--log-level=debug` increases verbosity.
| `package` | `yarn clean:dist && yarn rebuild && electron-builder -c.mac.identity=null --publish never` | Cleans artifacts, recompiles and packages the app without publishing it. | `-c.mac.identity=null` avoids signing requirements on macOS; `--publish never` generates local artifacts.
| `package:prod` | `yarn deploy` | Production alias that delegates to `deploy`. | — |
| `deploy` | `yarn clean:dist && yarn rebuild && electron-builder -c.mac.identity=null --publish always` | Similar to `package`, but `electron-builder` will publish artifacts according to configuration (repositories, CDN, etc.). | `--publish always` forces automatic upload.
| `package:preview` | `yarn clean:dist && yarn rebuild && electron-builder -c.mac.identity=null --dir` | Generates a package in directory format, useful for quick inspection. | `--dir` creates an uncompressed folder.
| `update:checksum` | `ts-node scripts/update-checksum.ts` | Recalculates checksums of installers, useful for automatic updates. | — |
| `update:blockmap` | `ts-node scripts/update-blockmap.ts` | Generates blockmap files that optimize differential downloads. | — |
| `update:theia` | `ts-node ../../scripts/update-theia-version.ts` | Synchronizes `@theia/*` dependency versions in the desktop app. | — |
| `update:next` | `ts-node ../../scripts/update-theia-version.ts next` | Variant pointing to the `next` branch of the Theia ecosystem. | `next` is passed as parameter.
| `sign:directory` | `ts-node scripts/sign-directory.ts` | Signs a distribution folder (macOS/Windows) using configured certificates. | Additional arguments can be provided in the CLI (e.g., certificate path). |
| `test` | `mocha --timeout 60000 "./test/*.spec.js"` | Runs integration tests for Electron with Mocha/WebdriverIO. | `--timeout 60000` sets 60s per test; glob delimits the directory.
| `lint` | `eslint --ext js,jsx,ts,tsx scripts && eslint --ext js,jsx,ts,tsx test` | Lints scripts and tests of the desktop app. | `--ext` restricts extensions.
| `lint:fix` | `eslint --ext js,jsx,ts,tsx scripts --fix && eslint --ext js,jsx,ts,tsx test -fix` | Same as `lint`, but tries to correct. Note: the second command should be `--fix`; the single dash seems like a typo. | Pointing out the possible correction helps maintain consistency.

## Key Concepts and Recommendations
- **Chain execution**: many scripts reuse others (`yarn build:extensions`, `yarn rebuild`). Changes in one script can impact others in cascade.
- **Serialization with `--concurrency 1`**: used to avoid competing for intensive resources (compilation of large bundles) or avoid race conditions in log output.
- **Environments**: The distinction between `build` and `build:prod` comes from the `--mode` flag. Review your needs before changing it.
- **Dependency updates**: the `update:*` scripts centralize Theia version management, facilitating coordinated upgrades.
- **Possible improvements**: 
  - Fix Electron's `lint:fix` to use `--fix` correctly.
  - Define quick verification scripts (e.g., `yarn check:release`) that combine `lint`, `test` and `build`.

With this summary you should be able to interpret, execute or adapt each command with confidence. If you need to add new scripts, take as reference the structure and conventions described here.
