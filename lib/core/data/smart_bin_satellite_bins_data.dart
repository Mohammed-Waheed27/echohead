import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../domain/entities/smart_bin_realtime_entity.dart';
import '../shared/constants/smart_bin_constants.dart';
import '../shared/utils/smart_bin_positions_helper.dart';

class SmartBinSatelliteBinsData {
  SmartBinSatelliteBinsData._();

  static LatLng get center => const LatLng(
    SmartBinConstants.workerRealtimeBinLat,
    SmartBinConstants.workerRealtimeBinLng,
  );

  static List<SmartBinSatelliteBinItem> satelliteBins() {
    final positions = SmartBinPositionsHelper.satellitePositions(
      center: center,
      radiusMeters: SmartBinConstants.satelliteRadiusMeters,
      count: 4,
    );

    return [
      SmartBinSatelliteBinItem(
        id: 'bin2',
        userHomeBinId: 'trash_can_2',
        name: 'حاوية ذكية 2',
        position: positions[0],
        data: const SmartBinRealtimeEntity(
          binId: 'bin2',
          buzzer: false,
          distance: 0.92,
          gas: 120,
          gasDanger: false,
          greenLED: false,
          isEmpty: false,
          isFull: false,
          isMedium: true,
          redLED: false,
          yellowLED: true,
        ),
      ),
      SmartBinSatelliteBinItem(
        id: 'bin3',
        userHomeBinId: 'trash_can_3',
        name: 'حاوية ذكية 3',
        position: positions[1],
        data: const SmartBinRealtimeEntity(
          binId: 'bin3',
          buzzer: true,
          distance: 0.35,
          gas: 245,
          gasDanger: true,
          greenLED: false,
          isEmpty: false,
          isFull: true,
          isMedium: false,
          redLED: true,
          yellowLED: false,
        ),
      ),
      SmartBinSatelliteBinItem(
        id: 'bin4',
        userHomeBinId: 'trash_can_4',
        name: 'حاوية ذكية 4',
        position: positions[2],
        data: const SmartBinRealtimeEntity(
          binId: 'bin4',
          buzzer: false,
          distance: 1.45,
          gas: 42,
          gasDanger: false,
          greenLED: true,
          isEmpty: true,
          isFull: false,
          isMedium: false,
          redLED: false,
          yellowLED: false,
        ),
      ),
      SmartBinSatelliteBinItem(
        id: 'bin5',
        userHomeBinId: 'trash_can_5',
        name: 'حاوية ذكية 5',
        position: positions[3],
        data: const SmartBinRealtimeEntity(
          binId: 'bin5',
          buzzer: false,
          distance: 0.78,
          gas: 165,
          gasDanger: false,
          greenLED: false,
          isEmpty: false,
          isFull: false,
          isMedium: true,
          redLED: false,
          yellowLED: true,
        ),
      ),
    ];
  }

  static Map<String, SmartBinSatelliteBinItem> byUserHomeBinId() {
    return {for (final item in satelliteBins()) item.userHomeBinId: item};
  }
}

class SmartBinSatelliteBinItem {
  final String id;
  final String userHomeBinId;
  final String name;
  final LatLng position;
  final SmartBinRealtimeEntity data;

  const SmartBinSatelliteBinItem({
    required this.id,
    required this.userHomeBinId,
    required this.name,
    required this.position,
    required this.data,
  });
}
