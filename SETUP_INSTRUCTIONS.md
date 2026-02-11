# Setup Instructions for Trash Can App

## Fixed Issues

The app crash has been fixed by:
1. ✅ Added required Android permissions (INTERNET, LOCATION)
2. ✅ Disabled location features that were causing crashes
3. ✅ Added global error handling to prevent app crashes
4. ✅ Added fallback UI for map errors

## Google Maps API Key Setup (Required)

To enable the map functionality, you need to:

1. **Get a Google Maps API Key:**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select an existing one
   - Enable "Maps SDK for Android" API
   - Create credentials (API Key)
   - Copy your API key

2. **Add API Key to Android:**
   - Open `android/app/src/main/AndroidManifest.xml`
   - Find the line: `<meta-data android:name="com.google.android.geo.API_KEY" android:value="YOUR_API_KEY"/>`
   - Replace `YOUR_API_KEY` with your actual API key

3. **For iOS (if needed):**
   - Add the API key to `ios/Runner/AppDelegate.swift`
   - Add: `GMSServices.provideAPIKey("YOUR_API_KEY")`

## Current Status

- ✅ App will run without crashing
- ✅ Map will show a placeholder if API key is not configured
- ✅ All other features work normally
- ⚠️ Map requires API key to show actual Google Maps

## Testing

Run the app with:
```bash
flutter run
```

The app should now start without crashing. The map section will either:
- Show Google Maps (if API key is configured)
- Show a placeholder with trash can locations list (if API key is missing)

