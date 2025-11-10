# Version Update & Force Update Setup Guide

## Overview

This app uses **Firebase Remote Config** for version checking and force update functionality. This approach gives you complete control over when and how users are prompted to update.

## Testing the Update Dialog

### Using Firebase Remote Config

1. Open Firebase Console for your project
2. Go to Remote Config
3. Add/Update these parameters:

```
min_app_version: "1.1.29"  (set higher than current version)
latest_app_version: "1.1.29"
force_update_enabled: true
force_update_message_en: "A new version is available. Please update to continue using the app."
force_update_message_ar: "يتوفر إصدار جديد. يرجى التحديث للمتابعة."
```

4. Publish the changes
5. Run the app - it should show the force update dialog

### For Testing During Development

You can temporarily change the default values in `lib/services/remote_config_service.dart`:

```dart
'min_app_version': '1.1.29', // Set higher than current version to force update
'latest_app_version': '1.1.29',
'force_update_enabled': true,
```

## Configuration

### Current App Version

The current app version is defined in `pubspec.yaml`:

```yaml
version: 1.1.29+29
```

### Version Check Service

Located in `lib/services/version_check_service.dart` - handles all version comparison logic and dialog display.

### Firebase Remote Config Defaults

Located in `lib/services/remote_config_service.dart`:

```dart
'min_app_version': '1.1.22',     // Minimum required version
'latest_app_version': '1.1.29',  // Latest available version
'force_update_enabled': true,    // Enable/disable force updates
'force_update_message_en': 'A new version is available. Please update to continue using the app.',
'force_update_message_ar': 'يتوفر إصدار جديد. يرجى التحديث للمتابعة.',
```

## How It Works

1. **App Launch**: When the app starts, it goes through the splash screen
2. **Version Check**: After 1 second delay, `VersionCheckService.checkForUpdate()` is called
3. **Remote Config**: Service fetches latest version and control parameters from Firebase Remote Config
4. **Comparison**: The service compares current app version with Remote Config version
5. **Dialog Display**: If newer version available, dialog is shown (Later button depends on `force_update_required`)
6. **Store Redirect**: Tapping "Update Now" opens the Play Store/App Store

## Troubleshooting

### Dialog Not Showing

1. **Check Remote Config**: Ensure `force_update_enabled` is `true`
2. **Check Version Numbers**: Ensure version comparison is correct
3. **Check Logs**: Look for version check logs in console with 🔄 🚨 ✅ emojis
4. **Check Internet**: Remote Config needs internet connection

### Firebase Remote Config Issues

1. **Initialization**: Check if Remote Config initialized successfully
2. **Fetch Interval**: In debug mode, fetch interval is 1 minute
3. **Default Values**: App uses default values if Remote Config fails

## Testing Scenarios

### Test Case 1: Force Update Required

```
Current Version: 1.1.29
Min Version: 1.1.29
Expected: Force update dialog (non-dismissible)
```

### Test Case 2: Optional Update Available

```
Current Version: 1.1.29
Min Version: 1.1.22
Latest Version: 1.1.29
Expected: Optional update dialog (dismissible)
```

### Test Case 3: No Update Needed

```
Current Version: 1.1.29
Min Version: 1.1.22
Latest Version: 1.1.29
Expected: No dialog
```

## Production Deployment

1. **Update Firebase Remote Config** with actual version numbers
2. **Test on real devices** with different app versions
3. **Monitor logs** for any issues
4. **Update Remote Config as needed** without app store releases

## Files Created/Modified

- `lib/main.dart` - Removed upgrader package
- `lib/services/remote_config_service.dart` - Remote Config parameters
- `lib/services/version_check_service.dart` - Version checking logic
- `lib/services/store_version_service.dart` - Store version fetching
- `lib/splash_screen.dart` - Version check trigger
- `pubspec.yaml` - Added html package, removed upgrader packages

## iOS Support

✅ **Fully supported!** The system works on both Android and iOS:

- **Android**: Opens Google Play Store using package name
- **iOS**: Opens App Store using your App Store ID (`ios_app_store_id` from Remote Config)
- **URL Schemes**: Uses `itms-apps://` scheme for direct App Store opening, with `https://` fallback
- **Configuration**: Added `LSApplicationQueriesSchemes` to `Info.plist` for iOS compatibility

## Notes

- The version checking happens after the splash screen completes (1 second delay)
- **Cross-platform**: Works on both Android and iOS devices
- You manually control the latest version via Firebase Remote Config
- Firebase Remote Config controls the update behavior (force vs optional)
- The dialog is localized (Arabic/English) based on user's language setting
- `force_update_required: true` removes the Later button
- Look for console logs with emojis (🔄 🔍 📱 🏪 📊 🚨 ✅) to debug issues
- **Remember**: Update `latest_app_version` in Remote Config when you release new versions!
