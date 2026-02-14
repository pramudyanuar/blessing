import 'package:flutter_test/flutter_test.dart';
import 'package:blessing/core/feature_flags/feature_flag_service.dart';
import 'package:blessing/core/feature_flags/feature_flag.dart';

/// Mock FeatureFlagService untuk testing
class MockFeatureFlagService extends FeatureFlagService {
  final Map<FeatureFlag, bool> overrideFlags = {};

  @override
  bool isEnabled(FeatureFlag flag) {
    if (overrideFlags.containsKey(flag)) {
      return overrideFlags[flag] ?? false;
    }
    return super.isEnabled(flag);
  }

  void setTestFlag(FeatureFlag flag, bool value) {
    overrideFlags[flag] = value;
  }

  void reset() {
    overrideFlags.clear();
  }
}

/// Helper untuk setup feature flags dalam tests
Future<void> setupFeatureFlagsForTest({
  required WidgetTester tester,
  required Map<FeatureFlag, bool> flags,
}) async {
  // Implementation akan dilakukan saat menambah tests
  // untuk saat ini ini hanya template
}
