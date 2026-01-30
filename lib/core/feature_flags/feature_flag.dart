/// Feature flags enumeration
enum FeatureFlag {
  /// New dashboard UI
  newDashboard,
  
  /// Advanced analytics
  advancedAnalytics,
  
  /// Beta payment system
  betaPayment,
  
  /// Dark mode support
  darkModeSupport,
  
  /// Offline functionality
  offlineMode,
  
  /// New report generation
  newReportEngine,
  
  /// Push notifications
  pushNotifications,
}

/// Feature flag configuration
class FeatureFlagConfig {
  final String name;
  final String description;
  final bool defaultValue;
  final String? minVersion;
  final String? maxVersion;
  final List<String>? enabledCountries;
  final List<String>? disabledCountries;

  FeatureFlagConfig({
    required this.name,
    required this.description,
    this.defaultValue = false,
    this.minVersion,
    this.maxVersion,
    this.enabledCountries,
    this.disabledCountries,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'defaultValue': defaultValue,
    'minVersion': minVersion,
    'maxVersion': maxVersion,
    'enabledCountries': enabledCountries,
    'disabledCountries': disabledCountries,
  };
}
