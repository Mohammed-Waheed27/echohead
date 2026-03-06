import 'package:equatable/equatable.dart';

/// Battery health based on charge level - links to solar power system.
enum BatteryHealth {
  good,    // Charge is good (>60%)
  warning, // Starting to decrease (20-60%)
  critical, // Very low (<20%)
}

/// Priority level for bins - helps workers know what to handle first.
enum BinPriority {
  low,
  medium,
  high,
}

/// Single reading record for bin history.
class BinReading extends Equatable {
  final DateTime timestamp;
  final int fillPercent;
  final double gasLevel;

  const BinReading({
    required this.timestamp,
    required this.fillPercent,
    required this.gasLevel,
  });

  @override
  List<Object?> get props => [timestamp, fillPercent, gasLevel];
}

/// Trash can / container entity with full sensor data.
class BinEntity extends Equatable {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String? address;
  final int fillPercent;
  final double gasLevel; // 0-100, high = emergency
  final int batteryPercent;
  final BatteryHealth batteryHealth;
  final BinPriority priority;
  final bool isUnderMaintenance;
  final DateTime lastUpdatedAt;
  final DateTime? lastEmptiedAt;
  final DateTime? lastReportAt;
  final String? lastReportDescription;
  final List<BinReading> lastReadings;

  const BinEntity({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address,
    required this.fillPercent,
    required this.gasLevel,
    required this.batteryPercent,
    required this.batteryHealth,
    required this.priority,
    required this.isUnderMaintenance,
    required this.lastUpdatedAt,
    this.lastEmptiedAt,
    this.lastReportAt,
    this.lastReportDescription,
    this.lastReadings = const [],
  });

  static BatteryHealth getBatteryHealthFromPercent(int percent) {
    if (percent > 60) return BatteryHealth.good;
    if (percent > 20) return BatteryHealth.warning;
    return BatteryHealth.critical;
  }

  static BinPriority calculatePriority({
    required int fillPercent,
    required double gasLevel,
    required DateTime? lastEmptiedAt,
  }) {
    // High gas = emergency, always High priority
    if (gasLevel >= 80) return BinPriority.high;
    // High fill = High priority
    if (fillPercent >= 90) return BinPriority.high;
    // Not emptied for 2+ days = Medium or High
    if (lastEmptiedAt != null) {
      final daysSince = DateTime.now().difference(lastEmptiedAt).inDays;
      if (daysSince >= 2) return BinPriority.high;
      if (daysSince >= 1) return BinPriority.medium;
    }
    // Medium fill
    if (fillPercent >= 50) return BinPriority.medium;
    return BinPriority.low;
  }

  String get batteryHealthLabel {
    switch (batteryHealth) {
      case BatteryHealth.good:
        return 'جيد';
      case BatteryHealth.warning:
        return 'تحذير';
      case BatteryHealth.critical:
        return 'حرج';
    }
  }

  String get priorityLabel {
    switch (priority) {
      case BinPriority.low:
        return 'منخفضة';
      case BinPriority.medium:
        return 'متوسطة';
      case BinPriority.high:
        return 'عالية';
    }
  }

  bool get hasGasEmergency => gasLevel >= 80;

  @override
  List<Object?> get props => [
        id,
        name,
        latitude,
        longitude,
        fillPercent,
        gasLevel,
        batteryPercent,
        batteryHealth,
        priority,
        isUnderMaintenance,
        lastUpdatedAt,
      ];
}
