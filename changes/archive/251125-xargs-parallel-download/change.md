# Change: Use xargs to download files in parallel

## Why

The current file download process is sequential, downloading one file at a time, which is inefficient when multiple files need to be downloaded from remote sources.

## How

Implement parallel file downloads using xargs with the -P flag to spawn multiple concurrent download processes, significantly reducing total download time for multiple files.

### Parallelism level

Use 4 parallel downloads to balance speed improvement with resource usage, working well on most systems.

### Scope

Apply parallel downloads only to remote mode, as local file copying is already fast and parallelism mainly benefits network operations.

### Error handling

Implement fail-fast behavior on first error, stopping all downloads immediately if any fails for clearer error reporting.
