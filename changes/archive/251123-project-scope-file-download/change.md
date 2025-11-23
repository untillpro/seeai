# Change: Project scope installation should download files

## Why

The seeai.sh installation script assumes files already exist in specs/agents/seeai/ when installing in Project Scope, but doesn't download them. This causes installations to fail silently, creating only seeai-version.yml without the actual Action and Spec files.

## How

Modify the install_files function to download files from GitHub (or copy from local source) even in Project Scope. Always overwrite existing files to ensure consistency with the installed version. Validate that all required files were successfully downloaded and fail with clear error if any file is missing.

## What

- This is a wrong claim and must be fixed: For user scope installations, files are copied from specs/agents/seeai/ to agent-specific directories in user home
  - Files are downloaded same way for both project and user scope
  - Only if -l option is used, files are copied from local source instead of downloaded
