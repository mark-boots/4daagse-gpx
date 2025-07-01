# Deployment Instructions

## Local Development & File Generation

1. **Convert KML files to GPX** (when needed):
   ```bash
   npm start
   # Visit http://localhost:3000 and use the convert buttons
   ```

2. **Generate static files** for deployment:
   ```bash
   npm run generate-static
   ```
   This will:
   - Copy all GPX files from `gpx-output/` to `public/gpx/`
   - Create `public/gpx-files.json` with file metadata

## Static Deployment Options

### Option 1: GitHub Pages (Free)
1. Push your code to GitHub
2. Go to repository Settings > Pages
3. Select "Deploy from a branch" and choose `main` branch, `/public` folder
4. Your site will be at: `https://yourusername.github.io/repository-name/`

### Option 2: Netlify (Free)
1. Drag and drop the `public/` folder to Netlify
2. Or connect your GitHub repo and set build directory to `public`

### Option 3: Vercel (Free)
1. Import project from GitHub
2. Set output directory to `public`

## File Structure for Deployment
```
public/
├── index.html          # Main application
├── gpx-files.json      # Generated file list
└── gpx/               # Generated GPX files
    ├── 4Daagse2025_-_Dag_1_30km_track.gpx
    ├── 4Daagse2025_-_Dag_1_Toiletten_waypoints.gpx
    └── ... (all other GPX files)
```

## Workflow

1. **When KML files change**:
   - Run backend locally: `npm start`
   - Convert new KML files via web interface
   - Generate static files: `npm run generate-static`
   - Deploy updated `public/` folder

2. **For updates**:
   - Only the `public/` folder needs to be deployed
   - No server required in production
   - Free hosting options available
