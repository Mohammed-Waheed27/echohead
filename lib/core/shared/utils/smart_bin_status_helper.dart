import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/smart_bin_realtime_entity.dart';
import '../constants/smart_bin_constants.dart';

class SmartBinStatusHelper {
  SmartBinStatusHelper._();

  static double markerHueFromRealtime(SmartBinRealtimeEntity bin) {
    if (bin.isFull) return BitmapDescriptor.hueRed;
    if (bin.isMedium) return BitmapDescriptor.hueYellow;
    return BitmapDescriptor.hueGreen;
  }

  static double markerHueFromFillPercent(int fillPercent) {
    if (fillPercent >= 80) return BitmapDescriptor.hueRed;
    if (fillPercent >= 50) return BitmapDescriptor.hueYellow;
    return BitmapDescriptor.hueGreen;
  }

  static int gasPercent(int gas) {
    return ((gas / SmartBinConstants.gasMaxRawValue) * 100)
        .clamp(0, 100)
        .round();
  }
}
