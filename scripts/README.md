# Scripts Folder

This folder contains automation scripts for the 4Daagse GPX project.

## PowerShell Scripts (.ps1)

These are the main automation scripts:

- **`generate.ps1`** - Converts KML files to GPX and copies to docs/ folder
- **`deploy.ps1`** - Commits and pushes changes to GitHub Pages
- **`test-local.ps1`** - Starts a local development server for testing
- **`update-routes.ps1`** - Full workflow: generate, pause for review, then deploy

## Batch Scripts (.bat) - Local Only

Windows convenience wrappers (gitignored):

- **`4daagse-dev.bat`** - Full development workflow
- **`quick-serve.bat`** - Quick local server startup
- **`quick-deploy.bat`** - Quick deployment
- **`full-auto.bat`** - Complete automation

## Usage

Run scripts from the project root directory:

```powershell
# From project root
.\scripts\generate.ps1
.\scripts\deploy.ps1 "Your commit message"
.\scripts\test-local.ps1
.\scripts\update-routes.ps1 "Your commit message"
```

See `../SCRIPTS.md` for detailed usage examples and workflows.
