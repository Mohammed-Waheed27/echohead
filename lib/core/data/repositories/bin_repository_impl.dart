import '../../domain/entities/bin_entity.dart';
import '../../domain/repositories/bin_repository.dart';
import '../../shared/constants/smart_bin_constants.dart';
import '../../shared/utils/smart_bin_entity_mapper.dart';
import '../smart_bin_satellite_bins_data.dart';

class BinRepositoryImpl implements BinRepository {
  static List<BinEntity> _mockBins = _createMockBins();

  static List<BinEntity> _createMockBins() {
    final now = DateTime.now();
    final satelliteBins = SmartBinSatelliteBinsData.satelliteBins()
        .map((item) => SmartBinEntityMapper.fromSatelliteItem(item, now))
        .toList();

    return [
      BinEntity(
        id: 'trash_can_1',
        name: 'حاوية ذكية - مباشر',
        latitude: SmartBinConstants.workerRealtimeBinLat,
        longitude: SmartBinConstants.workerRealtimeBinLng,
        address: 'موقع الحاوية الذكية الحقيقي',
        fillPercent: 10,
        gasLevel: 20,
        batteryPercent: 85,
        batteryHealth: BatteryHealth.good,
        priority: BinPriority.low,
        isUnderMaintenance: false,
        lastUpdatedAt: now.subtract(const Duration(seconds: 15)),
        lastEmptiedAt: now.subtract(const Duration(hours: 4)),
        lastReportAt: null,
        lastReportDescription: null,
        lastReadings: [
          BinReading(
            timestamp: now.subtract(const Duration(minutes: 2)),
            fillPercent: 10,
            gasLevel: 20,
          ),
        ],
      ),
      ...satelliteBins,
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
