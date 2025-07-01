# 4Daagse 2025 Route Viewer

Een interactieve route viewer voor de 4Daagse van Nijmegen 2025.

## Features

- 🗺️ Interactieve kaart met Leaflet
- 📍 Material Icons voor POI markers
- 🎨 Color-coded routes en dagen
- 📱 Responsive design
- 🇳🇱 Nederlandse interface
- 📥 GPX download functionaliteit

## Routes

- **Day 1 - Blauwe Dinsdag**: 30km, 40km, 40km MIL, 50km
- **Day 2 - Roze Woensdag**: 30km, 40km, 40km ML, 50km  
- **Day 3 - Groene Donderdag**: 30km, 40km, 40km MIL, 50km
- **Day 4 - Oranje Vrijdag**: 30km, 40km, 40km MIL, 50km

Plus verzorgingsposten, toiletten en waterpunten voor elke dag.

## Live Demo

[View Live Demo](https://mark-boots.github.io/4daagse-gpx/)

## Development

```bash
# Generate static files
npm run generate-static

# Test locally
cd public
python -m http.server 8000
```
