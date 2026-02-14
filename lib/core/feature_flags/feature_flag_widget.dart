import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'feature_flag_service.dart';
import 'feature_flag.dart';

/// Widget untuk conditional rendering berdasarkan feature flags
class FeatureFlagWidget extends StatelessWidget {
  final FeatureFlag flag;
  final Widget child;
  final Widget? fallback;

  const FeatureFlagWidget({
    required this.flag,
    required this.child,
    this.fallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final flagService = _getFlagService(context);

    return flagService.isEnabled(flag) ? child : (fallback ?? const SizedBox.shrink());
  }

  FeatureFlagService _getFlagService(BuildContext context) {
    try {
      return context.read<FeatureFlagService>();
    } catch (e) {
      throw Exception(
        'FeatureFlagService not found in context. '
        'Make sure to wrap your app with ChangeNotifierProvider<FeatureFlagService>',
      );
    }
  }
}

/// Extension untuk kondisional rendering yang lebih mudah
extension FeatureFlagContext on BuildContext {
  bool isFeatureEnabled(FeatureFlag flag) {
    try {
      return read<FeatureFlagService>().isEnabled(flag);
    } catch (e) {
      return false;
    }
  }

  T? whenFeatureEnabled<T>(
    FeatureFlag flag,
    T Function() builder, {
    T Function()? orElse,
  }) {
    try {
      final service = read<FeatureFlagService>();
      if (service.isEnabled(flag)) {
        return builder();
      }
      return orElse?.call();
    } catch (e) {
      return orElse?.call();
    }
  }
}

/// Mixin untuk classes yang perlu menggunakan feature flags
mixin FeatureFlagMixin {
  bool isFeatureEnabled(FeatureFlag flag, FeatureFlagService service) {
    return service.isEnabled(flag);
  }

  Map<FeatureFlag, bool> getEnabledFlags(FeatureFlagService service) {
    return {
      for (final flag in FeatureFlag.values) flag: service.isEnabled(flag),
    };
  }
}
