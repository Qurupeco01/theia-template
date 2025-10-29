/********************************************************************************
 * Copyright (C) 2025 EclipseSource and others.
 *
 * This program and the accompanying materials are made available under the
 * terms of the MIT License, which is available in the project root.
 *
 * SPDX-License-Identifier: MIT
 ********************************************************************************/

import * as fs from 'fs';
import * as path from 'path';

execute();

async function execute(): Promise<void> {
    const directory = process.argv[2] || 'plugins';
    console.log(`🔓 Making files writable in: ${directory}`);

    try {
        const processed = makeWritable(directory);
        console.log(`✅ Processed ${processed} files`);
    } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        console.error(`❌ Failed to make files writable: ${message}`);
        process.exit(1);
    }
}

function makeWritable(dir: string): number {
    if (!fs.existsSync(dir)) {
        throw new Error(`Directory '${dir}' does not exist.`);
    }

    let fileCount = 0;
    const entries = fs.readdirSync(dir, { withFileTypes: true });

    for (const entry of entries) {
        const fullPath = path.join(dir, entry.name);
        if (entry.isDirectory()) {
            fileCount += makeWritable(fullPath);
        } else if (entry.isFile()) {
            const stats = fs.statSync(fullPath);
            const isWritable = (stats.mode & 0o200) !== 0;
            if (!isWritable) {
                const isExecutable = (stats.mode & 0o111) !== 0;
                const newMode = isExecutable ? 0o755 : 0o644;
                console.log(`   Making '${fullPath}' writable (mode ${isExecutable ? '0o755' : '0o644'})`);
                fs.chmodSync(fullPath, newMode);
            }
            fileCount++;
        }
    }
    
    return fileCount;
}
