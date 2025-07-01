# GitHub Pages Deployment Guide

## Manual Upload Method (No Git Required)

### Step 1: Create GitHub Repository
1. Go to [GitHub.com](https://github.com)
2. Click the "+" icon in top-right corner
3. Select "New repository"
4. Name it: `4daagse-2025-routes` (or any name you prefer)
5. Make it **Public**
6. ✅ Check "Add a README file"
7. Click "Create repository"

### Step 2: Upload Your Files
1. In your new repository, click "uploading an existing file"
2. Upload these files from your project:
   - `README.md`
   - `public/index.html`
   - `public/gpx-files.json`
   - `public/gpx/` folder (all GPX files)

OR drag and drop your entire `public` folder contents.

### Step 3: Enable GitHub Pages
1. In your repository, go to **Settings** tab
2. Scroll down to **Pages** section (left sidebar)
3. Under "Source", select **"Deploy from a branch"**
4. Choose **"main"** branch
5. Choose **"/ (root)"** folder
6. Click **Save**

### Step 4: Access Your Site
- Your site will be available at: `https://yourusername.github.io/4daagse-2025-routes/`
- It may take 5-10 minutes to deploy

## File Structure for Upload
```
Repository root:
├── README.md
├── index.html              (from public/index.html)
├── gpx-files.json         (from public/gpx-files.json)
└── gpx/                   (from public/gpx/)
    ├── 4Daagse2025_-_Dag_1_30km_30km.gpx
    └── ... (all GPX files)
```

## Alternative: Git Method (if you have Git)
```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/yourusername/4daagse-2025-routes.git
git push -u origin main
```
