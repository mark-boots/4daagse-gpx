# 4Daagse GPX Deployment Scripts

This folder contains PowerShell scripts to automate deployment:

## Scripts

### `generate.ps1` - Generate Static Files
Process KML files and copy to docs folder (no deployment):
```powershell
.\generate.ps1
```

### `deploy.ps1` - Deploy to GitHub Pages
Deploy current docs/ folder contents:
```powershell
.\deploy.ps1 "Updated map styling"
```

### `update-routes.ps1` - Full Route Update (Two-Step)
Generate files, pause for review, then deploy:
```powershell
.\update-routes.ps1 "Added 2026 route data"
```

### `test-local.ps1` - Test Locally
To test your changes locally before deploying:
```powershell
.\test-local.ps1
```
Then open http://localhost:8000

## Workflow Examples

### Two-step process for new KML files:
1. Process files: `.\generate.ps1`
2. Review/edit files in `docs/` folder
3. Deploy: `.\deploy.ps1 "Added Day 5 routes"`

### Quick frontend changes:
1. Edit files in `docs/` folder
2. Test: `.\test-local.ps1` 
3. Deploy: `.\deploy.ps1 "Improved sidebar design"`

### Full automated update (with review pause):
```powershell
.\update-routes.ps1 "Added 2026 routes"
# Script will pause for you to review before deploying
```

### Backend processing only:
```powershell
.\generate.ps1
# Files are ready in docs/, make changes, then deploy later
```

## Notes
- All scripts will automatically commit and push to GitHub
- GitHub Pages deployment takes 2-10 minutes
- Check deployment status: https://github.com/mark-boots/4daagse-gpx/actions
- Live site: https://mark-boots.github.io/4daagse-gpx/
