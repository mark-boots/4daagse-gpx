# 4Daagse GPX Deployment Instructions

## Quick Reference

### Two-Step Workflow (Recommended)

#### Step 1: Backend Processing
```powershell
.\generate.ps1
```
- Converts KML files to GPX
- Copies files to `docs/` folder
- **No deployment yet** - gives you time to review

#### Step 2: Review & Deploy
```powershell
# Review/edit files in docs/ folder if needed
.\deploy.ps1 "Your commit message"
```
- Commits and pushes to GitHub
- Site goes live in 2-10 minutes

---

## Common Workflows

### 🗺️ Adding New KML Files
```powershell
# 1. Add new .kml files to kmlfiles/ folder
# 2. Process backend
.\generate.ps1

# 3. Review generated files in docs/ folder
# 4. Make any frontend changes (colors, labels, etc.)
# 5. Deploy when ready
.\deploy.ps1 "Added 2026 route data"
```

### 🎨 Frontend Changes Only
```powershell
# 1. Edit docs/index.html directly
# 2. Deploy
.\deploy.ps1 "Updated sidebar colors"
```

### 🧪 Test Before Deploy
```powershell
# 1. Make changes
.\generate.ps1  # (if needed)

# 2. Test locally
.\test-local.ps1
# Opens http://localhost:8000 - press Ctrl+C to stop

# 3. Deploy when satisfied
.\deploy.ps1 "Tested and ready"
```

### ⚡ Automated with Review Pause
```powershell
.\update-routes.ps1 "Added new routes"
# Script will pause after generating files
# Press any key when ready to deploy
```

---

## File Locations

- **Source KML files**: `kmlfiles/` folder
- **Generated GPX files**: `public/gpx/` folder (intermediate)
- **Website files**: `docs/` folder (what gets deployed)
- **Live website**: https://mark-boots.github.io/4daagse-gpx/

---

## Important Notes

✅ **Always edit files in `docs/` folder** - not `public/`  
✅ **Changes go live automatically** after `git push`  
✅ **GitHub Pages takes 2-10 minutes** to deploy  
✅ **Check deployment status**: https://github.com/mark-boots/4daagse-gpx/actions  
✅ **Hard refresh browser** (Ctrl+F5) to see changes immediately  

---

## Troubleshooting

### Site not updating?
- Check GitHub Actions for deployment status
- Wait 5-10 minutes for deployment
- Hard refresh browser (Ctrl+F5)

### PowerShell execution policy error?
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Want to undo last deployment?
```powershell
git revert HEAD
git push
```

---

## Example Scenarios

### Scenario 1: 4Daagse 2026 Routes Released
```powershell
# 1. Download new KML files to kmlfiles/ folder
# 2. Process them
.\generate.ps1

# 3. Check docs/index.html - maybe update year in title
# 4. Deploy
.\deploy.ps1 "Added 4Daagse 2026 routes"
```

### Scenario 2: Fix Typo in Route Names
```powershell
# 1. Edit docs/index.html
# 2. Deploy immediately
.\deploy.ps1 "Fixed typo in route names"
```

### Scenario 3: Improve Map Colors
```powershell
# 1. Edit docs/index.html - update CSS colors
# 2. Test locally first
.\test-local.ps1

# 3. Deploy when happy
.\deploy.ps1 "Improved route color scheme"
```

---

## Scripts Summary

| Script | Purpose | When to Use |
|--------|---------|-------------|
| `generate.ps1` | Process KML → GPX, copy to docs | New KML files |
| `deploy.ps1` | Commit & push to GitHub | Ready to go live |
| `update-routes.ps1` | Generate + pause + deploy | Full update with review |
| `test-local.ps1` | Local test server | Test before deploy |

---

**Happy Deploying! 🚀**
