import '../entities/bin_entity.dart';

abstract class BinRepository {
  Future<List<BinEntity>> getAllBins();
  Future<List<BinEntity>> getBinsForWorker(); // Excludes maintenance
  Future<List<BinEntity>> getBinsForSupervisor(); // Includes all
}
