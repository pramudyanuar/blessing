# Blessing - CI/CD Pipeline & GitOps Documentation

## 🎯 Overview

Proyek ini menggunakan **GitHub Actions** untuk CI/CD pipeline yang sepenuhnya otomatis dengan prinsip GitOps. Pipeline ini mencakup:

- ✅ **Continuous Integration** - Analisis, testing, dan code quality checks
- 📦 **Automated Build** - APK/AAB generation otomatis
- 🚀 **Automated Deployment** - Direct ke Google Play Store
- 🔄 **Rollback Mechanism** - Emergency rollback dengan approval workflow
- 🚩 **Feature Flags** - Controlled releases dan A/B testing
- 📊 **Monitoring** - Slack notifications dan coverage tracking

---

## 📋 Workflow Architecture

### 1. **CI Workflow** (`.github/workflows/ci.yml`)
Berjalan otomatis pada setiap push/PR ke main/develop

```
┌─ Analyze Code
├─ Check Formatting
├─ Run Unit Tests
├─ Upload Coverage
└─ Build Test APK
```

**Trigger:** Push to main/develop, Pull requests

**Status:** Diperlukan untuk merge PR

### 2. **Release Workflow** (`.github/workflows/release.yml`)
Berjalan ketika:
- Tag dibuat: `git tag -a v1.2.0`
- Manual dispatch dari Actions tab

```
┌─ Analyze Code
├─ Run Tests
├─ Update Version
├─ Build APK/AAB
├─ Sign App (dengan keystore)
├─ Upload ke Play Store
├─ Create GitHub Release
└─ Notify Slack
```

**Output:** 
- APK & AAB files di GitHub Releases
- Automatic upload ke Play Store
- Slack notification

### 3. **Rollback Workflow** (`.github/workflows/rollback.yml`)
Manual trigger untuk emergency rollbacks

```
┌─ Verify Version Exists
├─ Create Rollback Branch
├─ Update Version
├─ Create Pull Request
└─ Notify Slack
```

**Approval:** Manual PR approval sebelum deploy

---

## 🔧 Setup Instructions

### Step 1: Generate Android Keystore

```bash
keytool -genkey -v -keystore android/app/keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload \
  -storepass my_secure_password \
  -keypass my_secure_password \
  -dname "CN=Pramudyana, O=Blessing, L=Jakarta, ST=Jakarta, C=ID"
```

Simpan passwords dengan aman!

### Step 2: Convert Keystore ke Base64

```bash
# macOS/Linux
base64 < android/app/keystore.jks | tr -d '\n' | pbcopy

# Linux
base64 -i android/app/keystore.jks | tr -d '\n' | xclip -selection clipboard
```

### Step 3: Setup GitHub Secrets

Go to: **GitHub Repository → Settings → Secrets and Variables → Actions**

Tambahkan secrets berikut:

| Secret | Value |
|--------|-------|
| `ANDROID_KEYSTORE_BASE64` | Output dari Step 2 |
| `KEY_STORE_PASSWORD` | Password keystore |
| `KEY_ALIAS` | `upload` (default) |
| `KEY_PASSWORD` | Password key |
| `PLAY_STORE_SERVICE_ACCOUNT` | JSON dari Play Store Console |
| `SLACK_WEBHOOK_URL` | Webhook URL (optional) |

### Step 4: Google Play Console Setup

1. Go to [Google Play Console](https://play.console.google.com/)
2. **Settings → API & Services**
3. Create Service Account
4. Grant **Release Manager** role
5. Create JSON key
6. Add JSON content ke `PLAY_STORE_SERVICE_ACCOUNT` secret

### Step 5: Setup Git Hooks (Optional)

```bash
chmod +x setup-cicd.sh
./setup-cicd.sh
```

Ini akan:
- Setup pre-commit hooks
- Get dependencies
- Run build_runner

---

## 🚀 How to Release

### Option A: Automatic Release (Tag-based)

1. **Update version di pubspec.yaml**
   ```bash
   # Change version: 1.0.0+1 → 1.1.0+1
   ```

2. **Create tag dan push**
   ```bash
   git tag -a v1.1.0 -m "Release v1.1.0: Add new features"
   git push origin main
   git push origin v1.1.0
   ```

3. **Pipeline automatically:**
   - Builds APK/AAB
   - Signs with keystore
   - Uploads to Play Store (beta track)
   - Creates GitHub Release
   - Sends Slack notification

### Option B: Manual Release (Workflow Dispatch)

1. Go to **Actions → Build & Release to Play Store**
2. Click **Run workflow**
3. Select release type:
   - **alpha** - Internal testing
   - **beta** - Public beta testing
   - **production** - Stable release
4. Click **Run workflow**

---

## 🚩 Feature Flags System

Location: `lib/core/feature_flags/`

### Available Flags

```dart
enum FeatureFlag {
  newDashboard,        // New dashboard UI
  advancedAnalytics,   // Advanced analytics
  betaPayment,         // Beta payment system
  darkModeSupport,     // Dark mode theme
  offlineMode,         // Offline functionality
  newReportEngine,     // New report generation
  pushNotifications,   // Push notification support
}
```

### Usage Examples

**1. Using Widget**
```dart
FeatureFlagWidget(
  flag: FeatureFlag.newDashboard,
  child: NewDashboard(),
  fallback: OldDashboard(),
)
```

**2. Using Extension**
```dart
if (context.isFeatureEnabled(FeatureFlag.newDashboard)) {
  // Show new dashboard
}
```

**3. Using Service**
```dart
final flagService = context.read<FeatureFlagService>();
if (flagService.isEnabled(FeatureFlag.betaPayment)) {
  // Show beta payment
}
```

### Adding New Features

1. **Add to enum**
   ```dart
   enum FeatureFlag {
     // ... existing
     myNewFeature,  // Add here
   }
   ```

2. **Add configuration**
   ```dart
   FeatureFlag.myNewFeature: FeatureFlagConfig(
     name: 'My New Feature',
     description: 'Description here',
     defaultValue: false,
     minVersion: '1.5.0',
   ),
   ```

3. **Use in code**
   ```dart
   FeatureFlagWidget(
     flag: FeatureFlag.myNewFeature,
     child: MyNewFeature(),
   )
   ```

### Controlling Flags

**Local Override (Development)**
```dart
// Enable for testing
await flagService.setLocalFlag(FeatureFlag.betaPayment, true);

// Disable
await flagService.removeLocalFlag(FeatureFlag.betaPayment);
```

**Remote Config (Production)**
```dart
// Update from backend
await flagService.updateRemoteFlags({
  'FeatureFlag.newDashboard': true,
  'FeatureFlag.betaPayment': false,
});
```

---

## 🔄 Rollback Procedure

### Emergency Rollback (Fast)

1. Go to **Actions → Rollback Release**
2. Click **Run workflow**
3. Enter version to rollback to (e.g., `1.0.0`)
4. Select release track
5. System creates PR automatically
6. **Approve and merge the PR**
7. Done! Pipeline handles the rest

### Manual Rollback (If needed)

```bash
# Get previous version
git log --oneline --all

# Checkout previous version
git checkout v1.0.0

# Update version and push
# Manually release
```

---

## 📊 Monitoring & Notifications

### Slack Notifications

Pipeline mengirim notifikasi untuk:

✅ **Successful Release**
```
✅ Release Deployed
Version: 1.1.0
Track: beta
```

❌ **Failed Release**
```
❌ Release Failed
Version: 1.1.0
Track: beta
Logs: [Check logs]
```

🔄 **Rollback Request**
```
🔄 Rollback Request
From: 1.1.0
Track: beta
Action: Approve PR
```

### Code Coverage

Uploads otomatis ke [Codecov](https://codecov.io) setiap release.

Check coverage: 
- GitHub: **Checks tab** in PR
- Codecov: codecov.io/gh/your-repo

---

## 🧪 Testing

### Run Locally Before Push

```bash
# Analyze
flutter analyze

# Format check
dart format --set-exit-if-changed .

# Unit tests
flutter test --coverage

# Integration tests
flutter test integration_test/

# Build APK
flutter build apk
```

### Enable Pre-commit Hooks

```bash
chmod +x .githooks/pre-commit
git config core.hooksPath .githooks
```

Now tests run automatically before commit!

---

## 📈 Release Naming Convention

Use **Semantic Versioning**: `MAJOR.MINOR.PATCH`

- **MAJOR** (1.0.0 → 2.0.0): Breaking changes
- **MINOR** (1.0.0 → 1.1.0): New features
- **PATCH** (1.0.0 → 1.0.1): Bug fixes

Example commit messages:
```
git tag -a v1.2.0 -m "feat: Add new payment system"
git tag -a v1.2.1 -m "fix: Resolve payment crash"
git tag -a v2.0.0 -m "feat!: Major redesign (breaking change)"
```

---

## ⚠️ Troubleshooting

### Build Fails

1. Check GitHub Actions logs:
   - **Actions → Release workflow → failed run**

2. Common issues:
   - ❌ Secrets not configured → Add all secrets
   - ❌ Wrong keystore password → Verify in secrets
   - ❌ Version not incremented → Update pubspec.yaml
   - ❌ Tests failing → Run locally: `flutter test`

### Play Store Upload Fails

1. Verify service account permissions:
   - Go to Play Console → Settings → User & Permissions
   - Check "Release Manager" role

2. Check version code:
   - Must be incremented each release
   - Pipeline does this automatically

3. Check app signing:
   - Same keystore must be used
   - Can't use different keystore per release

### Tests Failing

```bash
# Run locally to debug
flutter test --verbose

# Check dependencies
flutter pub get

# Update tests
# Add new test cases for new features
```

---

## 📚 Best Practices

✅ **DO:**
- Test locally before pushing
- Use meaningful commit messages
- Use feature flags for risky changes
- Review release notes before tagging
- Monitor first few hours after release

❌ **DON'T:**
- Force push to main
- Release untested code
- Use hardcoded features
- Ignore pipeline failures
- Skip code reviews

---

## 🔐 Security Considerations

1. **Keystore Security**
   - Don't commit keystore to git
   - Use strong passwords
   - Store backup securely

2. **Service Account**
   - Restrict to "Release Manager" only
   - Rotate keys periodically
   - Monitor access logs

3. **GitHub Secrets**
   - Never log secrets
   - Use branch protection rules
   - Enable required reviews

---

## 📞 Support & Documentation

- **GitHub Actions Docs**: https://docs.github.com/en/actions
- **Flutter Docs**: https://docs.flutter.dev
- **Play Store Guide**: https://developer.android.com/distribute/play-console

---

## 📝 Quick Reference

| Action | Command |
|--------|---------|
| Release | `git tag -a v1.2.0 && git push origin v1.2.0` |
| Rollback | Actions → Rollback Release workflow |
| Test locally | `flutter test --coverage` |
| Check status | GitHub Actions tab |
| View coverage | Codecov dashboard |

---

**Happy releasing! 🎉**
