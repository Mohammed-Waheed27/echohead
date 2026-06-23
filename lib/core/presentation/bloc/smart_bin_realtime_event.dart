import 'package:equatable/equatable.dart';

import '../../domain/entities/smart_bin_realtime_entity.dart';

abstract class SmartBinRealtimeEvent extends Equatable {
  const SmartBinRealtimeEvent();

  @override
  List<Object?> get props => [];
}

class SmartBinRealtimeWatchAllRequested extends SmartBinRealtimeEvent {
  const SmartBinRealtimeWatchAllRequested();
}

class SmartBinRealtimeWatchBinRequested extends SmartBinRealtimeEvent {
  final String binId;

  const SmartBinRealtimeWatchBinRequested(this.binId);

  @override
  List<Object?> get props => [binId];
}

class SmartBinRealtimeDataUpdated extends SmartBinRealtimeEvent {
  final Map<String, SmartBinRealtimeEntity> bins;

  const SmartBinRealtimeDataUpdated(this.bins);

  @override
  List<Object?> get props => [bins];
}

class SmartBinRealtimeStreamError extends SmartBinRealtimeEvent {
  final String message;

  const SmartBinRealtimeStreamError(this.message);

  @override
  List<Object?> get props => [message];
}
