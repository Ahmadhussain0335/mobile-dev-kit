#!/usr/bin/env node
import { runCli } from '../lib/index.js';

// Exit quietly when the reader goes away, for example `mobile-dev-kit list | head`.
process.stdout.on('error', (error) => {
  if (/** @type {NodeJS.ErrnoException} */ (error).code === 'EPIPE') process.exit(0);
  throw error;
});

process.exitCode = await runCli(process.argv.slice(2));
