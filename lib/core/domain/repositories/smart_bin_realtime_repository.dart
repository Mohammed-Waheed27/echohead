import '../../domain/entities/smart_bin_realtime_entity.dart';

abstract class SmartBinRealtimeRepository {
  Stream<Map<String, SmartBinRealtimeEntity>> watchAllBins();
  Stream<SmartBinRealtimeEntity?> watchBin(String binId);
}
