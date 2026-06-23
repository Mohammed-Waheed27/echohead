import '../../domain/entities/bin_entity.dart';
import '../../domain/entities/smart_bin_realtime_entity.dart';
import '../../data/smart_bin_satellite_bins_data.dart';
import 'smart_bin_status_helper.dart';

class SmartBinEntityMapper {
  SmartBinEntityMapper._();

  static int fillPercentFromStatus(SmartBinRealtimeEntity data) {
    if (data.isFull) return 95;
    if (data.isMedium) return 60;
    return 10;
  }

  static BinPriority priorityFromStatus(SmartBinRealtimeEntity data) {
    if (data.gasDanger || data.isFull) return BinPriority.high;
    if (data.isMedium) return BinPriority.medium;
    return BinPriority.low;
  }

  static BinEntity fromSatelliteItem(
    SmartBinSatelliteBinItem item,
    DateTime now,
  ) {
    final data = item.data;
    final fillPercent = fillPercentFromStatus(data);
    final gasLevel = SmartBinStatusHelper.gasPercent(data.gas).toDouble();

    return BinEntity(
      id: item.userHomeBinId,
      name: item.name,
      latitude: item.position.latitude,
      longitude: item.position.longitude,
      address: 'ضمن نطاق 300 متر من الحاوية الذكية',
      fillPercent: fillPercent,
      gasLevel: gasLevel,
      batteryPercent: 75,
      batteryHealth: BatteryHealth.good,
      priority: priorityFromStatus(data),
      isUnderMaintenance: false,
      lastUpdatedAt: now,
      lastEmptiedAt: data.isEmpty
          ? now.subtract(const Duration(hours: 2))
          : now.subtract(const Duration(days: 1)),
      lastReportAt: data.gasDanger
          ? now.subtract(const Duration(hours: 1))
          : null,
      lastReportDescription: data.gasDanger
          ? 'تنبيه غاز سام من الحاوية الذكية'
          : null,
      lastReadings: [
        BinReading(
          timestamp: now.subtract(const Duration(minutes: 5)),
          fillPercent: fillPercent,
          gasLevel: gasLevel,
        ),
      ],
    );
  }
}
