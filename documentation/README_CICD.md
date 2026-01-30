# 🎉 Blessing App - CI/CD Pipeline + Error Reporting

Production-ready Flutter app dengan fully automated CI/CD pipeline dan crash reporting.

## 🚀 Quick Start

### 1. Documentation
- **[Setup CI/CD](documentation/CICD_SETUP.md)** - Configure GitHub Actions & Play Store
- **[How to Release](documentation/CICD_GUIDE.md)** - Release process & troubleshooting
- **[Firebase Crashlytics](documentation/FIREBASE_CRASHLYTICS.md)** - Auto error reporting

### 2. Key Features

✅ **Automated CI/CD**
- Tests & analysis on every push
- Auto-build APK/AAB
- Auto-sign & upload to Play Store

✅ **Feature Flags** (7 flags)
- Controlled rollouts
- A/B testing support
- Production safe

✅ **Error Reporting**
- Firebase Crashlytics integration
- Auto-catch all crashes
- API error tracking

✅ **Rollback**
- Emergency rollback mechanism
- One-command recovery

✅ **Team Collaboration**
- PR templates
- Issue templates
- Code review requirements

### 3. First-Time Setup (30 minutes)

```bash
# 1. Read setup guide
# documentation/CICD_SETUP.md

# 2. Generate Android keystore
keytool -genkey -v -keystore android/app/keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload

# 3. Add 6 GitHub secrets
# ANDROID_KEYSTORE_BASE64, KEY_STORE_PASSWORD, KEY_ALIAS,
# KEY_PASSWORD, PLAY_STORE_SERVICE_ACCOUNT, SLACK_WEBHOOK_URL

# 4. Setup Firebase Crashlytics
# documentation/FIREBASE_CRASHLYTICS.md

# 5. Create first release
./bump-version.sh patch
git push origin main
git push origin v1.0.0
```

### 4. Monitor

- **GitHub Actions** - View CI/CD workflow
- **Firebase Console** - View crashes & errors
- **Play Store** - Verify deployment

## 📱 Project Structure

```
blessing-fe/
├── documentation/
│   ├── CICD_SETUP.md ................. GitHub Actions setup
│   ├── CICD_GUIDE.md ................. Release & usage guide
│   └── FIREBASE_CRASHLYTICS.md ....... Error reporting setup
│
├── .github/
│   ├── workflows/
│   │   ├── ci.yml .................... Continuous integration
│   │   ├── release.yml .............. Build & release to Play Store
│   │   ├── rollback.yml ............. Emergency rollback
│   │   ├── quality.yml .............. Code quality checks
│   │   └── deploy.yml ............... Manual deployments
│   │
│   ├── ISSUE_TEMPLATE/ ............... Issue templates
│   ├── pull_request_template.md ...... PR template
│   └── .githooks/pre-commit .......... Pre-commit hooks
│
├── lib/core/
│   ├── feature_flags/ ................ 7 feature flags system
│   └── services/
│       ├── crash_reporting_service.dart ... Crashlytics wrapper
│       └── crash_reporting_interceptor.dart .. DIO interceptor
│
├── README_CICD.md .................... This file
├── README.md ......................... Project README
├── bump-version.sh ................... Version automation
├── setup-cicd.sh .................... Initial setup
└── pubspec.yaml ..................... Dependencies
```

## 🔧 Commands

```bash
# Setup environment
./setup-cicd.sh

# Release new version (auto-increments)
./bump-version.sh patch    # 1.0.0 → 1.0.1
./bump-version.sh minor    # 1.0.0 → 1.1.0
./bump-version.sh major    # 1.0.0 → 2.0.0

# Test locally
flutter test --coverage
flutter analyze
dart format .

# Simulate crash (debug only)
import 'lib/core/services/crash_reporting_service.dart';
crashReporting.simulateCrash();
```

## 📊 Features

### Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| CI | Push/PR | Tests, analysis, coverage |
| Release | Git tag | Build, sign, deploy to Play Store |
| Rollback | Manual | Emergency version rollback |
| Quality | Weekly | Security & performance scan |
| Deploy | Manual | Environment-specific deployment |

### Feature Flags (7 total)

- `newDashboard` - New dashboard UI
- `advancedAnalytics` - Analytics features
- `betaPayment` - Beta payment system
- `darkModeSupport` - Dark mode theme
- `offlineMode` - Offline functionality
- `newReportEngine` - Report generation
- `pushNotifications` - Push notifications

### Error Reporting

- 🔴 **Uncaught Exceptions** - Auto-caught
- 🌐 **API Errors** - Auto-logged
- 📝 **Breadcrumbs** - Activity trail
- 👤 **User ID** - Identify affected users
- 📊 **Custom Data** - App version, feature flags, etc

## 🔐 Security

- ✅ Encrypted secrets (GitHub)
- ✅ Keystore protection
- ✅ Service account scoping
- ✅ No sensitive data in logs
- ✅ Branch protection rules

## 📈 Play Store Tracks

```
Internal → Alpha (5-50 users) 
         → Beta (50-1000 users) 
         → Production (all users)
```

## 🚀 Release Workflow

```
Code → PR → CI ✅ → Review → Main 
→ Tag → Release Workflow → Play Store 
→ Notification → Live!
```

## 📞 Support

| Issue | Reference |
|-------|-----------|
| Setup problems | `documentation/CICD_SETUP.md` |
| How to release | `documentation/CICD_GUIDE.md` |
| Crash reporting | `documentation/FIREBASE_CRASHLYTICS.md` |

## 🎯 Next Steps

1. ✅ Read [CICD_SETUP.md](documentation/CICD_SETUP.md)
2. ✅ Configure GitHub secrets
3. ✅ Setup Firebase Crashlytics
4. ✅ Create first release
5. ✅ Monitor in Play Store & Firebase

---

**Status:** ✅ Production Ready  
**Version:** 1.0.0  
**Created:** January 30, 2026

Happy building! 🚀
