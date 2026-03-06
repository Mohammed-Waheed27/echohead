import '../../domain/entities/bin_entity.dart';
import '../../domain/repositories/bin_repository.dart';

class BinRepositoryImpl implements BinRepository {
  static List<BinEntity> _mockBins = _createMockBins();

  static List<BinEntity> _createMockBins() {
    final now = DateTime.now();
    return [
      BinEntity(
        id: 'trash_can_1',
        name: 'حاوية وسط المنزلة',
        latitude: 31.1582,
        longitude: 31.9360,
        address: 'وسط مدينة المنزلة',
        fillPercent: 2,
        gasLevel: 5,
        batteryPercent: 85,
        batteryHealth: BatteryHealth.good,
        priority: BinPriority.low,
        isUnderMaintenance: false,
        lastUpdatedAt: now.subtract(const Duration(seconds: 15)),
        lastEmptiedAt: now.subtract(const Duration(hours: 4)),
        lastReportAt: null,
        lastReportDescription: null,
        lastReadings: [
          BinReading(timestamp: now.subtract(const Duration(minutes: 2)), fillPercent: 2, gasLevel: 5),
          BinReading(timestamp: now.subtract(const Duration(minutes: 15)), fillPercent: 1, gasLevel: 4),
          BinReading(timestamp: now.subtract(const Duration(minutes: 30)), fillPercent: 3, gasLevel: 5),
          BinReading(timestamp: now.subtract(const Duration(hours: 1)), fillPercent: 2, gasLevel: 5),
          BinReading(timestamp: now.subtract(const Duration(hours: 2)), fillPercent: 1, gasLevel: 4),
        ],
      ),
      BinEntity(
        id: 'trash_can_2',
        name: 'حاوية كلية المنزلة',
        latitude: 31.1620,
        longitude: 31.9320,
        address: 'محيط كلية المنزلة',
        fillPercent: 100,
        gasLevel: 92, // High gas - emergency
        batteryPercent: 25,
        batteryHealth: BatteryHealth.warning,
        priority: BinPriority.high,
        isUnderMaintenance: false,
        lastUpdatedAt: now.subtract(const Duration(seconds: 8)),
        lastEmptiedAt: now.subtract(const Duration(days: 3)),
        lastReportAt: now.subtract(const Duration(hours: 2)),
        lastReportDescription: 'رائحة كريهة - مستوى غاز مرتفع',
        lastReadings: [
          BinReading(timestamp: now.subtract(const Duration(minutes: 1)), fillPercent: 100, gasLevel: 92),
          BinReading(timestamp: now.subtract(const Duration(minutes: 10)), fillPercent: 98, gasLevel: 88),
          BinReading(timestamp: now.subtract(const Duration(minutes: 25)), fillPercent: 95, gasLevel: 85),
          BinReading(timestamp: now.subtract(const Duration(hours: 1)), fillPercent: 90, gasLevel: 80),
          BinReading(timestamp: now.subtract(const Duration(hours: 2)), fillPercent: 85, gasLevel: 75),
        ],
      ),
      BinEntity(
        id: 'trash_can_3',
        name: 'حاوية شرق المنزلة',
        latitude: 31.1550,
        longitude: 31.9400,
        address: 'شرق المنزلة',
        fillPercent: 50,
        gasLevel: 25,
        batteryPercent: 45,
        batteryHealth: BatteryHealth.warning,
        priority: BinPriority.medium,
        isUnderMaintenance: false,
        lastUpdatedAt: now.subtract(const Duration(seconds: 45)),
        lastEmptiedAt: now.subtract(const Duration(days: 1)),
        lastReportAt: null,
        lastReportDescription: null,
        lastReadings: [
          BinReading(timestamp: now.subtract(const Duration(minutes: 5)), fillPercent: 50, gasLevel: 25),
          BinReading(timestamp: now.subtract(const Duration(minutes: 20)), fillPercent: 48, gasLevel: 24),
          BinReading(timestamp: now.subtract(const Duration(minutes: 45)), fillPercent: 45, gasLevel: 22),
          BinReading(timestamp: now.subtract(const Duration(hours: 1)), fillPercent: 42, gasLevel: 20),
          BinReading(timestamp: now.subtract(const Duration(hours: 2)), fillPercent: 38, gasLevel: 18),
        ],
      ),
      BinEntity(
        id: 'trash_can_4',
        name: 'حاوية غرب المنزلة',
        latitude: 31.1520,
        longitude: 31.9300,
        address: 'غرب المنزلة',
        fillPercent: 25,
        gasLevel: 12,
        batteryPercent: 15,
        batteryHealth: BatteryHealth.critical,
        priority: BinPriority.medium,
        isUnderMaintenance: true, // Under maintenance - hidden from worker
        lastUpdatedAt: now.subtract(const Duration(seconds: 120)),
        lastEmptiedAt: now.subtract(const Duration(hours: 12)),
        lastReportAt: now.subtract(const Duration(days: 1)),
        lastReportDescription: 'مشكلة في المستشعر - البطارية ضعيفة',
        lastReadings: [
          BinReading(timestamp: now.subtract(const Duration(minutes: 30)), fillPercent: 25, gasLevel: 12),
          BinReading(timestamp: now.subtract(const Duration(hours: 1)), fillPercent: 24, gasLevel: 11),
          BinReading(timestamp: now.subtract(const Duration(hours: 2)), fillPercent: 22, gasLevel: 10),
          BinReading(timestamp: now.subtract(const Duration(hours: 3)), fillPercent: 20, gasLevel: 9),
          BinReading(timestamp: now.subtract(const Duration(hours: 4)), fillPercent: 18, gasLevel: 8),
        ],
      ),
      BinEntity(
        id: 'trash_can_5',
        name: 'حاوية شمال المنزلة',
        latitude: 31.1650,
        longitude: 31.9380,
        address: 'شمال المنزلة - قرب الكلية',
        fillPercent: 75,
        gasLevel: 35,
        batteryPercent: 70,
        batteryHealth: BatteryHealth.good,
        priority: BinPriority.high,
        isUnderMaintenance: false,
        lastUpdatedAt: now.subtract(const Duration(seconds: 30)),
        lastEmptiedAt: now.subtract(const Duration(days: 2)),
        lastReportAt: null,
        lastReportDescription: null,
        lastReadings: [
          BinReading(timestamp: now.subtract(const Duration(minutes: 3)), fillPercent: 75, gasLevel: 35),
          BinReading(timestamp: now.subtract(const Duration(minutes: 18)), fillPercent: 72, gasLevel: 33),
          BinReading(timestamp: now.subtract(const Duration(minutes: 40)), fillPercent: 68, gasLevel: 30),
          BinReading(timestamp: now.subtract(const Duration(hours: 1)), fillPercent: 65, gasLevel: 28),
          BinReading(timestamp: now.subtract(const Duration(hours: 2)), fillPercent: 60, gasLevel: 25),
        ],
      ),
    ];
  }

  @override
  Future<List<BinEntity>> getAllBins() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_mockBins);
  }

  @override
  Future<List<BinEntity>> getBinsForWorker() async {
    final bins = await getAllBins();
    return bins.where((b) => !b.isUnderMaintenance).toList();
  }

  @override
  Future<List<BinEntity>> getBinsForSupervisor() async {
    return getAllBins();
  }
}
