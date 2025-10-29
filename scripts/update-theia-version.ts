/********************************************************************************
 * Copyright (C) 2021 EclipseSource and others.
 *
 * This program and the accompanying materials are made available under the
 * terms of the MIT License, which is available in the project root.
 *
 * SPDX-License-Identifier: MIT
 ********************************************************************************/
import * as fs from 'fs';
import * as path from 'path';

interface PackageJson {
    dependencies?: Record<string, string>;
    devDependencies?: Record<string, string>;
}

execute();

async function execute(): Promise<void> {
    const theiaVersion = process.argv[2];
    
    if (!theiaVersion) {
        console.error('❌ Error: Please provide a Theia version as argument.');
        console.log('Usage: ts-node scripts/update-theia-version.ts <version>');
        console.log('Example: ts-node scripts/update-theia-version.ts 1.65.0');
        console.log('         ts-node scripts/update-theia-version.ts next');
        process.exit(1);
    }

    const packageJsonPath = path.resolve('./', 'package.json');

    console.log(`\n🔄 Updating Theia version to: ${theiaVersion}`);
    console.log(`📦 Updating ${packageJsonPath}...`);

    const packageJsonContents: string = fs.readFileSync(packageJsonPath, { encoding: 'utf8' });
    const packageJson: PackageJson = JSON.parse(packageJsonContents);

    let updatedCount = 0;

    console.log('   ...dependencies...');
    if (packageJson.dependencies) {
        updatedCount += updateTheiaVersions(packageJson.dependencies, theiaVersion);
    }

    console.log('   ...devDependencies...');
    if (packageJson.devDependencies) {
        updatedCount += updateTheiaVersions(packageJson.devDependencies, theiaVersion);
    }

    // note: "null" is valid as per `stringify()` signature
    // eslint-disable-next-line no-null/no-null
    fs.writeFileSync(packageJsonPath, JSON.stringify(packageJson, null, 2) + '\n');
    
    console.log(`✅ Updated ${updatedCount} @theia/* packages in root package.json`);
}

function updateTheiaVersions(dependencies: Record<string, string>, theiaVersion: string): number {
    let count = 0;
    for (const dependency in dependencies) {
        if (dependency.startsWith('@theia/')) {
            const oldVersion = dependencies[dependency];
            dependencies[dependency] = theiaVersion;
            console.log(`      ${dependency}: ${oldVersion} → ${theiaVersion}`);
            count++;
        }
    }
    return count;
}
