# 4Daagse GPX Deployment Scripts

This folder contains PowerShell scripts to automate deployment tasks. All scripts are located in the `scripts/` folder.

## Scripts

### `scripts/generate.ps1` - Generate Static Files
Process KML files and copy to docs folder (no deployment):
```powershell
.\scripts\generate.ps1
```

### `scripts/deploy.ps1` - Deploy to GitHub Pages
Deploy current docs/ folder contents:
```powershell
.\scripts\deploy.ps1 "Updated map styling"
```

### `scripts/update-routes.ps1` - Full Route Update (Two-Step)
Generate files, pause for review, then deploy:
```powershell
.\scripts\update-routes.ps1 "Added 2026 route data"
```

### `scripts/test-local.ps1` - Test Locally
To test your changes locally before deploying:
```powershell
.\scripts\test-local.ps1
```
Then open http://localhost:8000

## Windows Batch Scripts (Local Only)
For convenience, there are also batch scripts in the `scripts/` folder that wrap the PowerShell commands:
- `scripts/4daagse-dev.bat` - Full development workflow
- `scripts/quick-serve.bat` - Quick local server
- `scripts/quick-deploy.bat` - Quick deployment
- `scripts/full-auto.bat` - Complete automation

*Note: Batch scripts are gitignored and only exist locally for convenience.*

## Workflow Examples

### Two-step process for new KML files:
1. Process files: `.\scripts\generate.ps1`
2. Review/edit files in `docs/` folder
3. Deploy: `.\scripts\deploy.ps1 "Added Day 5 routes"`

### Quick frontend changes:
1. Edit files in `docs/` folder
2. Test: `.\scripts\test-local.ps1` 
3. Deploy: `.\scripts\deploy.ps1 "Improved sidebar design"`

### Full automated update (with review pause):
```powershell
.\scripts\update-routes.ps1 "Added 2026 routes"
# Script will pause for you to review before deploying
```

### Backend processing only:
```powershell
.\scripts\generate.ps1
# Files are ready in docs/, make changes, then deploy later
```

## Notes
- All scripts will automatically commit and push to GitHub
- GitHub Pages deployment takes 2-10 minutes
- Check deployment status: https://github.com/mark-boots/4daagse-gpx/actions
- Live site: https://mark-boots.github.io/4daagse-gpx/
