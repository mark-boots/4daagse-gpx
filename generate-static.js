const fs = require('fs');
const path = require('path');

function generateStaticFiles() {
    const gpxOutputDir = './gpx-output';
    const publicGpxDir = './public/gpx';
    
    // Create public/gpx directory if it doesn't exist
    if (!fs.existsSync(publicGpxDir)) {
        fs.mkdirSync(publicGpxDir, { recursive: true });
    }
    
    // Copy all GPX files to public/gpx
    const gpxFiles = fs.readdirSync(gpxOutputDir).filter(file => file.endsWith('.gpx'));
    
    gpxFiles.forEach(file => {
        const sourcePath = path.join(gpxOutputDir, file);
        const destPath = path.join(publicGpxDir, file);
        fs.copyFileSync(sourcePath, destPath);
        console.log(`Copied: ${file}`);
    });
    
    // Generate file list JSON
    const fileList = gpxFiles.map(fileName => {
        const type = fileName.toLowerCase().includes('waypoints') ? 'poi' : 'track';
        return {
            fileName,
            type
        };
    });
    
    const gpxFilesData = {
        success: true,
        files: fileList
    };
    
    // Write the JSON file
    fs.writeFileSync('./public/gpx-files.json', JSON.stringify(gpxFilesData, null, 2));
    
    console.log(`\n✅ Generated static files:`);
    console.log(`📁 Copied ${gpxFiles.length} GPX files to public/gpx/`);
    console.log(`📄 Created public/gpx-files.json`);
    console.log(`\n🚀 Ready for static deployment!`);
}

// Run the script
generateStaticFiles();
