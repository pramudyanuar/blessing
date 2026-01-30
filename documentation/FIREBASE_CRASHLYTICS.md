# Firebase Crashlytics Setup

## 🚀 Overview

Firebase Crashlytics otomatis menangkap dan melaporkan semua errors di production:

- ✅ **Uncaught Exceptions** - Semua crash app
- ✅ **Network Errors** - API request failures  
- ✅ **Async Errors** - Background process errors
- ✅ **Custom Errors** - Manual error reporting
- ✅ **Breadcrumbs** - Activity trail sebelum crash

---

## 📋 Setup Steps

### 1. Create Firebase Project

```bash
# Visit Firebase Console
https://console.firebase.google.com/

# Create new project atau gunakan yang existing
# Project name: blessing (atau sesuai project)
```

### 2. Add Android App

- Go to Project Settings → Add App
- Select Android
- Package name: `com.example.blessing` (sesuaikan)
- Get `google-services.json`
- Place di: `android/app/google-services.json`

### 3. Add iOS App (Optional)

- Go to Project Settings → Add App
- Select iOS
- Bundle ID: `com.example.blessing`
- Download `GoogleService-Info.plist`
- Add ke Xcode project

### 4. Enable Crashlytics

- Go to Firebase Console
- Analytics → Crashlytics
- Enable collection

### 5. Configure Google Services

Sudah ada di `build.gradle`:
```gradle
plugins {
    id 'com.google.gms.google-services'
}
```

---

## 📱 How to Use

### In main.dart

```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'lib/core/services/crash_reporting_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize crash reporting
  await crashReporting.initialize();

  runApp(const MyApp());
}
```

### Report Custom Error

```dart
import 'lib/core/services/crash_reporting_service.dart';

try {
  // Your code
  performRiskyOperation();
} catch (e, stackTrace) {
  // Report to Crashlytics
  await crashReporting.recordError(
    e,
    stackTrace,
    reason: 'Failed to process payment',
  );
}
```

### Log Messages (Breadcrumbs)

```dart
// Info log
await crashReporting.logMessage('User started payment process');

// Warning log
await crashReporting.logMessage(
  'Payment retry #3',
  level: 'WARNING',
);

// Error log
await crashReporting.logMessage(
  'Payment failed with code: ${error.code}',
  level: 'ERROR',
);
```

### Set User ID

```dart
// When user logs in
await crashReporting.setUserId(user.id);

// Helps identify which user had the crash
```

### Set Custom Data

```dart
// Add context to crashes
await crashReporting.setCustomKey('app_version', '1.2.0');
await crashReporting.setCustomKey('user_type', 'premium');
await crashReporting.setCustomKey('feature_flag_payment', true);
```

### Report API Error

```dart
// Manual API error reporting
await crashReporting.reportApiError(
  endpoint: '/api/payment/process',
  statusCode: 500,
  message: 'Internal server error',
  responseBody: response.body,
);
```

### Auto-Report API Errors

Add interceptor ke Dio:

```dart
import 'package:dio/dio.dart';
import 'lib/core/services/crash_reporting_interceptor.dart';

final dio = Dio();
dio.interceptors.add(CrashReportingInterceptor());
```

Sekarang semua API errors otomatis di-report ke Crashlytics!

---

## 📊 View Crashes in Firebase Console

1. Go to Firebase Console
2. Analytics → Crashlytics
3. View:
   - Crash timeline
   - Stack traces
   - Affected users
   - Device info
   - Logs (breadcrumbs)

---

## 🧪 Testing Locally

### Simulate Crash (Debug only)

```dart
import 'lib/core/services/crash_reporting_service.dart';

// In button or method
crashReporting.simulateCrash(); // Hanya works di debug
```

### Enable Collection in Debug

```dart
// Force enable untuk testing (di crash_reporting_service.dart)
await crashlytics.setCrashlyticsCollectionEnabled(true);
```

---

## ⚙️ Configuration

### Auto-Enabled in Production Only

```dart
// Automatically:
// - Disabled di debug mode
// - Enabled di release/production
// - All errors caught automatically
```

### Customize Behavior

```dart
// Di crash_reporting_service.dart
// Sesuaikan errorDetails handling
// Tambah custom logic saat crash
```

---

## 🔐 Privacy

- ✅ User IDs hanya di-set jika user login
- ✅ Custom keys tidak sensitive data
- ✅ Stack traces helpful untuk debugging
- ✅ Firebase handles data securely

---

## 📝 Common Usage Patterns

### Pattern 1: Try-Catch

```dart
try {
  await processPayment();
} catch (e, st) {
  await crashReporting.recordError(e, st);
  showErrorDialog('Payment failed');
}
```

### Pattern 2: Global Error Handling

```dart
// Automatically caught:
// - Uncaught exceptions
// - Async errors
// - Platform errors
```

### Pattern 3: Feature Tracking

```dart
// Log which features are used
await crashReporting.logMessage('User opened advanced settings');
await crashReporting.logMessage('Beta feature X enabled');

// If crash, you see what user was doing
```

---

## 📞 Troubleshooting

**Crashes not showing?**
- Verify `google-services.json` in place
- Check Crashlytics enabled in Firebase Console
- Restart app after setup
- Wait 5-10 minutes for first crash

**Can't see in debug?**
- Crashes disabled in debug by default
- Use `simulateCrash()` to test
- Force enable for testing only

**Missing stack trace?**
- App must crash and restart
- Make sure error handling not catching exception
- Add `recordError()` manually if needed

---

## 🚀 Next Steps

1. ✅ Create Firebase project
2. ✅ Add android/iOS apps
3. ✅ Download google-services.json
4. ✅ Place in android/app/
5. ✅ Run `flutter pub get`
6. ✅ Test with `simulateCrash()`
7. ✅ Monitor in Firebase Console

---

**Your app now has automatic error reporting! 📊**
