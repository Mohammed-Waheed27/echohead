import 'package:firebase_database/firebase_database.dart';

import '../../domain/entities/smart_bin_realtime_entity.dart';

class SmartBinRealtimeDataSource {
  SmartBinRealtimeDataSource({DatabaseReference? binsRef})
    : _binsRef = binsRef ?? FirebaseDatabase.instance.ref('bins');

  final DatabaseReference _binsRef;

  Stream<Map<String, SmartBinRealtimeEntity>> watchAllBins() {
    return _binsRef.onValue.map((event) {
      final value = event.snapshot.value;
      if (value is! Map) return <String, SmartBinRealtimeEntity>{};

      final bins = <String, SmartBinRealtimeEntity>{};
      value.forEach((key, raw) {
        if (key is String && raw is Map) {
          bins[key] = SmartBinRealtimeEntity.fromMap(key, raw);
        }
      });
      return bins;
    });
  }

  Stream<SmartBinRealtimeEntity?> watchBin(String binId) {
    return _binsRef.child(binId).onValue.map((event) {
      final value = event.snapshot.value;
      if (value is! Map) return null;
      return SmartBinRealtimeEntity.fromMap(binId, value);
    });
  }
}
