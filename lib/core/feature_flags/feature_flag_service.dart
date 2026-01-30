import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'feature_flag.dart';

/// Service untuk mengelola feature flags
class FeatureFlagService extends ChangeNotifier {
  static const String _boxName = 'feature_flags';
  static const String _remoteConfigKey = 'remote_config';
  
  late Box<dynamic> _flagBox;
  Map<String, bool> _localFlags = {};
  Map<String, bool> _remoteFlags = {};
  bool _isInitialized = false;

  /// Feature flag configurations
  static final Map<FeatureFlag, FeatureFlagConfig> _configs = {
    FeatureFlag.newDashboard: FeatureFlagConfig(
      name: 'New Dashboard',
      description: 'New dashboard UI with improved performance',
      defaultValue: false,
      minVersion: '1.5.0',
    ),
    FeatureFlag.advancedAnalytics: FeatureFlagConfig(
      name: 'Advanced Analytics',
      description: 'Advanced analytics features',
      defaultValue: false,
      minVersion: '1.3.0',
    ),
    FeatureFlag.betaPayment: FeatureFlagConfig(
      name: 'Beta Payment System',
      description: 'New payment system (beta)',
      defaultValue: false,
      minVersion: '1.2.0',
    ),
    FeatureFlag.darkModeSupport: FeatureFlagConfig(
      name: 'Dark Mode Support',
      description: 'Full dark mode theme support',
      defaultValue: true,
    ),
    FeatureFlag.offlineMode: FeatureFlagConfig(
      name: 'Offline Mode',
      description: 'Offline functionality support',
      defaultValue: false,
      minVersion: '1.4.0',
    ),
    FeatureFlag.newReportEngine: FeatureFlagConfig(
      name: 'New Report Engine',
      description: 'Improved report generation',
      defaultValue: false,
      minVersion: '1.6.0',
    ),
    FeatureFlag.pushNotifications: FeatureFlagConfig(
      name: 'Push Notifications',
      description: 'Push notification support',
      defaultValue: true,
    ),
  };

  /// Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _flagBox = await Hive.openBox<dynamic>(_boxName);
      _loadLocalFlags();
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing FeatureFlagService: $e');
      rethrow;
    }
  }

  /// Get feature flag value
  bool isEnabled(FeatureFlag flag) {
    // Check remote config first
    if (_remoteFlags.containsKey(flag.toString())) {
      return _remoteFlags[flag.toString()] ?? false;
    }

    // Then check local overrides
    if (_localFlags.containsKey(flag.toString())) {
      return _localFlags[flag.toString()] ?? false;
    }

    // Default value from config
    return _configs[flag]?.defaultValue ?? false;
  }

  /// Get all enabled flags
  List<String> getEnabledFlags() {
    return _configs.keys
        .where((flag) => isEnabled(flag))
        .map((flag) => flag.toString())
        .toList();
  }

  /// Get feature flag config
  FeatureFlagConfig? getConfig(FeatureFlag flag) {
    return _configs[flag];
  }

  /// Set local flag override (for testing/development)
  Future<void> setLocalFlag(FeatureFlag flag, bool value) async {
    _localFlags[flag.toString()] = value;
    await _flagBox.put('${flag.toString()}_local', value);
    notifyListeners();
  }

  /// Remove local flag override
  Future<void> removeLocalFlag(FeatureFlag flag) async {
    _localFlags.remove(flag.toString());
    await _flagBox.delete('${flag.toString()}_local');
    notifyListeners();
  }

  /// Update remote flags from remote config
  Future<void> updateRemoteFlags(Map<String, bool> remoteConfig) async {
    _remoteFlags = remoteConfig;
    try {
      await _flagBox.put(_remoteConfigKey, jsonEncode(remoteConfig));
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving remote config: $e');
    }
  }

  /// Clear all local overrides
  Future<void> clearLocalOverrides() async {
    _localFlags.clear();
    final keysToDelete = _flagBox.keys
        .where((key) => key.toString().endsWith('_local'))
        .toList();

    for (final key in keysToDelete) {
      await _flagBox.delete(key);
    }
    notifyListeners();
  }

  /// Load local flags from storage
  void _loadLocalFlags() {
    for (final flag in _configs.keys) {
      final key = '${flag.toString()}_local';
      if (_flagBox.containsKey(key)) {
        _localFlags[flag.toString()] = _flagBox.get(key) as bool? ?? false;
      }
    }

    // Load remote config
    try {
      final remoteConfigStr = _flagBox.get(_remoteConfigKey) as String?;
      if (remoteConfigStr != null) {
        _remoteFlags = Map<String, bool>.from(
          jsonDecode(remoteConfigStr) as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint('Error loading remote config: $e');
    }
  }

  /// Export current flags state as JSON
  Map<String, dynamic> exportState() {
    return {
      'local_overrides': _localFlags,
      'remote_config': _remoteFlags,
      'defaults': {
        for (final entry in _configs.entries)
          entry.key.toString(): entry.value.defaultValue,
      },
      'all_configs': {
        for (final entry in _configs.entries) entry.key.toString(): entry.value.toJson(),
      },
    };
  }

  /// Import flags state from JSON
  Future<void> importState(Map<String, dynamic> state) async {
    try {
      if (state.containsKey('local_overrides')) {
        _localFlags = Map<String, bool>.from(state['local_overrides'] as Map);
      }
      if (state.containsKey('remote_config')) {
        _remoteFlags = Map<String, bool>.from(state['remote_config'] as Map);
      }

      // Save to storage
      for (final entry in _localFlags.entries) {
        await _flagBox.put('${entry.key}_local', entry.value);
      }
      await _flagBox.put(_remoteConfigKey, jsonEncode(_remoteFlags));

      notifyListeners();
    } catch (e) {
      debugPrint('Error importing state: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _flagBox.close();
    super.dispose();
  }
}
