# CI/CD Configuration

## GitHub Secrets yang Diperlukan

Tambahkan secrets berikut di GitHub Settings → Secrets and Variables → Actions:

### Android Build & Play Store Deployment

```
ANDROID_KEYSTORE_BASE64
  - Base64 encoded keystore file (.jks)
  - Generate: base64 -i android/app/keystore.jks | tr -d '\n' | pbcopy

KEY_STORE_PASSWORD
  - Password untuk keystore

KEY_ALIAS
  - Alias kunci dalam keystore (biasanya 'upload')

KEY_PASSWORD
  - Password untuk kunci individual

PLAY_STORE_SERVICE_ACCOUNT
  - JSON credentials dari Google Play Console
  - Download dari: Google Play Console → API & Services → Service Accounts
```

### Notification & Monitoring

```
SLACK_WEBHOOK_URL
  - Webhook untuk Slack notifications
  - Create di: https://api.slack.com/apps → Incoming Webhooks

CODECOV_TOKEN (Optional)
  - Token untuk Codecov
  - Get dari: https://codecov.io
```

## Setup Android Keystore

### 1. Generate Keystore (First time only)

```bash
keytool -genkey -v -keystore android/app/keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload \
  -storepass <PASSWORD> \
  -keypass <PASSWORD> \
  -dname "CN=<YOUR_NAME>, O=<COMPANY>, L=<CITY>, ST=<STATE>, C=<COUNTRY>"
```

### 2. Convert to Base64

```bash
base64 -i android/app/keystore.jks | tr -d '\n'
```

### 3. Add to GitHub Secrets

```bash
gh secret set ANDROID_KEYSTORE_BASE64 < keystore_base64.txt
gh secret set KEY_STORE_PASSWORD
gh secret set KEY_ALIAS
gh secret set KEY_PASSWORD
```

## Setup Play Store Service Account

### 1. Create Service Account

- Go to Google Play Console
- Settings → API & Services → Create new Service Account
- Grant "Release Manager" role

### 2. Generate JSON Key

- Select Service Account
- Create new key → JSON format
- Add to GitHub Secrets

```bash
gh secret set PLAY_STORE_SERVICE_ACCOUNT < service_account.json
```

## Workflow Files

### ci.yml
- Runs on: push to main/develop, pull requests
- Executes: analyze, format check, unit tests, integration tests
- Uploads: coverage reports to Codecov

### release.yml
- Triggers on: push to main with tags (v*) or manual dispatch
- Steps:
  1. Analyzes code
  2. Runs tests
  3. Updates version in pubspec.yaml
  4. Builds APK/AAB
  5. Deploys to Play Store (alpha/beta/production)
  6. Creates GitHub Release
  7. Notifies Slack

### rollback.yml
- Manual trigger from Actions tab
- Steps:
  1. Verifies version exists
  2. Creates rollback branch
  3. Updates version
  4. Creates Pull Request for approval
  5. Notifies Slack

## Release Process

### Automatic Release (via Tag)

```bash
# Create version tag
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin v1.2.0
```

### Manual Release (via Workflow Dispatch)

1. Go to Actions → Build & Release to Play Store
2. Click "Run workflow"
3. Select release type: alpha, beta, or production
4. Click "Run workflow"

### Rollback Process

1. Go to Actions → Rollback Release
2. Click "Run workflow"
3. Enter version to rollback to
4. Select release track
5. Review and merge the auto-created PR

## Version Numbering

Format: `MAJOR.MINOR.PATCH+BUILD_NUMBER`

Example:
```
version: 1.2.0+42
```

Build number auto-increments on each release.

## Feature Flags

Location: `lib/core/feature_flags/`

### Usage in Code

```dart
// Using widget
FeatureFlagWidget(
  flag: FeatureFlag.newDashboard,
  child: NewDashboard(),
  fallback: OldDashboard(),
)

// Using extension
if (context.isFeatureEnabled(FeatureFlag.newDashboard)) {
  // Show new dashboard
}

// Using service
final flagService = context.read<FeatureFlagService>();
if (flagService.isEnabled(FeatureFlag.newDashboard)) {
  // Show new dashboard
}
```

### Adding New Flags

1. Add to `FeatureFlag` enum
2. Add config to `FeatureFlagService._configs`
3. Use in code with feature flag widgets/extensions

### Enabling/Disabling Flags

```dart
// Local override (development)
await flagService.setLocalFlag(FeatureFlag.newDashboard, true);

// Remote config (from backend/Firebase)
await flagService.updateRemoteFlags({
  'FeatureFlag.newDashboard': true,
  'FeatureFlag.betaPayment': false,
});
```

## Testing

### Unit Tests

```bash
flutter test --coverage
```

### Integration Tests

```bash
flutter test integration_test/
```

### Generate Code Coverage Report

```bash
lcov --summary coverage/lcov.info
```

## Monitoring & Notifications

### Slack Integration

Release pipeline sends notifications for:
- ✅ Successful releases
- ❌ Failed builds
- 🔄 Rollback requests

Configure webhook in GitHub Secrets: `SLACK_WEBHOOK_URL`

## Troubleshooting

### Build Failures

1. Check GitHub Actions logs
2. Verify all secrets are configured
3. Ensure Flutter version matches (3.24.0)
4. Check Android/Java dependencies

### Play Store Upload Fails

1. Verify service account has "Release Manager" role
2. Check app signing configuration
3. Ensure version code is incremented
4. Verify app bundle is valid

### Tests Failing

1. Run locally: `flutter test`
2. Check test logs in Actions
3. Verify dependencies: `flutter pub get`
4. Update tests for new features

## Best Practices

1. **Always test locally before pushing**
   ```bash
   flutter analyze
   flutter test --coverage
   flutter build apk
   ```

2. **Use semantic versioning**
   - MAJOR: Breaking changes
   - MINOR: New features
   - PATCH: Bug fixes

3. **Create meaningful commit messages**
   - "feat: add new dashboard" 
   - "fix: resolve payment issue"
   - "ci: update release workflow"

4. **Review before merging to main**
   - Require PR reviews
   - Require status checks passing
   - Require branch to be up to date

5. **Use feature flags for risky changes**
   - New payment system? Use flag
   - UI redesign? Use flag
   - Major refactor? Use flag

6. **Monitor releases**
   - Check Slack notifications
   - Monitor crash reports
   - Track user feedback

## Next Steps

1. Configure all GitHub Secrets
2. Add integration tests
3. Setup Slack workspace integration
4. Configure branch protection rules
5. Add more feature flags as needed
6. Monitor first release closely
