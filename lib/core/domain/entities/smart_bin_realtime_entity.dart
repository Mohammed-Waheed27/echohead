import 'package:equatable/equatable.dart';

class SmartBinLastStored extends Equatable {
  final bool buzzer;
  final double distance;
  final int gas;
  final bool greenLED;
  final bool redLED;
  final bool yellowLED;

  const SmartBinLastStored({
    required this.buzzer,
    required this.distance,
    required this.gas,
    required this.greenLED,
    required this.redLED,
    required this.yellowLED,
  });

  factory SmartBinLastStored.fromMap(Map<dynamic, dynamic> map) {
    return SmartBinLastStored(
      buzzer: map['buzzer'] == true,
      distance: _toDouble(map['distance']),
      gas: _toInt(map['gas']),
      greenLED: map['greenLED'] == true,
      redLED: map['redLED'] == true,
      yellowLED: map['yellowLED'] == true,
    );
  }

  @override
  List<Object?> get props => [
    buzzer,
    distance,
    gas,
    greenLED,
    redLED,
    yellowLED,
  ];
}

class SmartBinRealtimeEntity extends Equatable {
  final String binId;
  final bool buzzer;
  final double distance;
  final int gas;
  final bool gasDanger;
  final bool greenLED;
  final bool isEmpty;
  final bool isFull;
  final bool isMedium;
  final bool redLED;
  final bool yellowLED;
  final SmartBinLastStored? lastStored;

  const SmartBinRealtimeEntity({
    required this.binId,
    required this.buzzer,
    required this.distance,
    required this.gas,
    required this.gasDanger,
    required this.greenLED,
    required this.isEmpty,
    required this.isFull,
    required this.isMedium,
    required this.redLED,
    required this.yellowLED,
    this.lastStored,
  });

  factory SmartBinRealtimeEntity.fromMap(
    String binId,
    Map<dynamic, dynamic> map,
  ) {
    final lastStoredRaw = map['lastStored'];
    return SmartBinRealtimeEntity(
      binId: binId,
      buzzer: map['buzzer'] == true,
      distance: _toDouble(map['distance']),
      gas: _toInt(map['gas']),
      gasDanger: map['gasDanger'] == true,
      greenLED: map['greenLED'] == true,
      isEmpty: map['isEmpty'] == true,
      isFull: map['isFull'] == true,
      isMedium: map['isMedium'] == true,
      redLED: map['redLED'] == true,
      yellowLED: map['yellowLED'] == true,
      lastStored: lastStoredRaw is Map
          ? SmartBinLastStored.fromMap(lastStoredRaw)
          : null,
    );
  }

  bool get isReady => isEmpty;

  String get statusLabel {
    if (isFull) return 'ممتلئة';
    if (isMedium) return 'شبه ممتلئة';
    return 'جاهزة';
  }

  int gasPercent({int maxRawValue = 300}) {
    if (maxRawValue <= 0) return 0;
    return ((gas / maxRawValue) * 100).clamp(0, 100).round();
  }

  @override
  List<Object?> get props => [
    binId,
    buzzer,
    distance,
    gas,
    gasDanger,
    greenLED,
    isEmpty,
    isFull,
    isMedium,
    redLED,
    yellowLED,
    lastStored,
  ];
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _toDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}
