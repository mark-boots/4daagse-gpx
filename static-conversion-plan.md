# Converting to Static Frontend

## Changes needed to make the app fully static:

### 1. Replace API calls in JavaScript:

```javascript
// Instead of: await fetch('/api/gpx-files')
// Use: await fetch('./gpx-files.json')

// Instead of: await fetch(`/api/download-gpx/${fileName}`)
// Use: await fetch(`./gpx/${fileName}`)
```

### 2. File structure for static hosting:
```
public/
├── index.html
├── gpx-files.json
└── gpx/
    ├── 4Daagse2025_-_Dag_1_30km_track.gpx
    ├── 4Daagse2025_-_Dag_1_Toiletten_waypoints.gpx
    └── ... (all GPX files)
```

### 3. Generate gpx-files.json:
Run a script once to create the file list, then deploy as static files.

### 4. Static hosting options:
- GitHub Pages (free)
- Netlify (free tier)
- Vercel (free tier)
- Any static file hosting

## Pros of static approach:
- ✅ Simpler deployment
- ✅ Free hosting options
- ✅ Better performance
- ✅ No server maintenance

## Cons of static approach:
- ❌ No dynamic KML conversion
- ❌ Manual file updates needed
- ❌ Larger initial download (all GPX files)
