enum AppThemeMode { system, light, dark }

class LocalTimeOfDay {
  final int hour;
  final int minute;

  const LocalTimeOfDay({required this.hour, required this.minute})
      : assert(hour >= 0 && hour <= 23),
        assert(minute >= 0 && minute <= 59);

  DateTime onDate(DateTime date) {
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  Map<String, Object?> toJson() => {'hour': hour, 'minute': minute};

  factory LocalTimeOfDay.fromJson(Map<String, Object?> json) {
    return LocalTimeOfDay(
      hour: json['hour'] as int? ?? 0,
      minute: json['minute'] as int? ?? 0,
    );
  }
}

class QuietHours {
  final bool enabled;
  final LocalTimeOfDay start;
  final LocalTimeOfDay end;

  const QuietHours({
    this.enabled = false,
    this.start = const LocalTimeOfDay(hour: 22, minute: 0),
    this.end = const LocalTimeOfDay(hour: 6, minute: 0),
  });

  bool isInQuietHours(DateTime dateTime) {
    if (!enabled) {
      return false;
    }
    final startTime = start.onDate(dateTime);
    final endTime = end.onDate(dateTime);
    if (startTime.isBefore(endTime) || startTime.isAtSameMomentAs(endTime)) {
      return !dateTime.isBefore(startTime) && !dateTime.isAfter(endTime);
    }
    // Quiet hours span overnight.
    return dateTime.isAfter(startTime) || dateTime.isBefore(endTime);
  }

  Map<String, Object?> toJson() => {
        'enabled': enabled,
        'start': start.toJson(),
        'end': end.toJson(),
      };

  factory QuietHours.fromJson(Map<String, Object?> json) {
    return QuietHours(
      enabled: json['enabled'] as bool? ?? false,
      start: json['start'] is Map
          ? LocalTimeOfDay.fromJson(
              Map<String, Object?>.from(json['start'] as Map),
            )
          : const LocalTimeOfDay(hour: 22, minute: 0),
      end: json['end'] is Map
          ? LocalTimeOfDay.fromJson(
              Map<String, Object?>.from(json['end'] as Map),
            )
          : const LocalTimeOfDay(hour: 6, minute: 0),
    );
  }
}

class ParentalControlSettings {
  final bool enabled;
  final Set<String> allowedClassIds;
  final Set<String> blockedClassIds;
  final bool allowChatNotifications;

  const ParentalControlSettings({
    this.enabled = false,
    this.allowedClassIds = const {},
    this.blockedClassIds = const {},
    this.allowChatNotifications = true,
  });

  bool allowsClass(String classId) {
    if (!enabled) {
      return true;
    }
    if (!allowChatNotifications) {
      return false;
    }
    if (blockedClassIds.contains(classId)) {
      return false;
    }
    if (allowedClassIds.isEmpty) {
      return true;
    }
    return allowedClassIds.contains(classId);
  }

  Map<String, Object?> toJson() => {
        'enabled': enabled,
        'allowedClassIds': allowedClassIds.toList(),
        'blockedClassIds': blockedClassIds.toList(),
        'allowChatNotifications': allowChatNotifications,
      };

  factory ParentalControlSettings.fromJson(Map<String, Object?> json) {
    return ParentalControlSettings(
      enabled: json['enabled'] as bool? ?? false,
      allowedClassIds: {
        for (final value in (json['allowedClassIds'] as List<dynamic>? ?? const []))
          value.toString(),
      },
      blockedClassIds: {
        for (final value in (json['blockedClassIds'] as List<dynamic>? ?? const []))
          value.toString(),
      },
      allowChatNotifications: json['allowChatNotifications'] as bool? ?? true,
    );
  }
}

class NotificationPreferences {
  final bool pushEnabled;
  final bool localNotificationsEnabled;
  final QuietHours quietHours;
  final ParentalControlSettings parentalControls;

  const NotificationPreferences({
    this.pushEnabled = true,
    this.localNotificationsEnabled = true,
    this.quietHours = const QuietHours(),
    this.parentalControls = const ParentalControlSettings(),
  });

  bool shouldNotify(String classId, DateTime dateTime) {
    if (!pushEnabled && !localNotificationsEnabled) {
      return false;
    }
    if (quietHours.isInQuietHours(dateTime)) {
      return false;
    }
    return parentalControls.allowsClass(classId);
  }

  Map<String, Object?> toJson() => {
        'pushEnabled': pushEnabled,
        'localNotificationsEnabled': localNotificationsEnabled,
        'quietHours': quietHours.toJson(),
        'parentalControls': parentalControls.toJson(),
      };

  factory NotificationPreferences.fromJson(Map<String, Object?> json) {
    return NotificationPreferences(
      pushEnabled: json['pushEnabled'] as bool? ?? true,
      localNotificationsEnabled: json['localNotificationsEnabled'] as bool? ?? true,
      quietHours: json['quietHours'] is Map
          ? QuietHours.fromJson(
              Map<String, Object?>.from(json['quietHours'] as Map),
            )
          : const QuietHours(),
      parentalControls: json['parentalControls'] is Map
          ? ParentalControlSettings.fromJson(
              Map<String, Object?>.from(json['parentalControls'] as Map),
            )
          : const ParentalControlSettings(),
    );
  }
}
