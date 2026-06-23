import '../../domain/entities/smart_bin_realtime_entity.dart';
import '../../domain/repositories/smart_bin_realtime_repository.dart';
import '../datasources/smart_bin_realtime_datasource.dart';

class SmartBinRealtimeRepositoryImpl implements SmartBinRealtimeRepository {
  SmartBinRealtimeRepositoryImpl({SmartBinRealtimeDataSource? dataSource})
    : _dataSource = dataSource ?? SmartBinRealtimeDataSource();

  final SmartBinRealtimeDataSource _dataSource;

  @override
  Stream<Map<String, SmartBinRealtimeEntity>> watchAllBins() {
    return _dataSource.watchAllBins();
  }

  @override
  Stream<SmartBinRealtimeEntity?> watchBin(String binId) {
    return _dataSource.watchBin(binId);
  }
}
