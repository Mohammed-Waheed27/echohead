import 'package:equatable/equatable.dart';

import '../../domain/entities/smart_bin_realtime_entity.dart';

abstract class SmartBinRealtimeState extends Equatable {
  const SmartBinRealtimeState();

  @override
  List<Object?> get props => [];
}

class SmartBinRealtimeInitial extends SmartBinRealtimeState {
  const SmartBinRealtimeInitial();
}

class SmartBinRealtimeLoading extends SmartBinRealtimeState {
  const SmartBinRealtimeLoading();
}

class SmartBinRealtimeLoaded extends SmartBinRealtimeState {
  final Map<String, SmartBinRealtimeEntity> bins;

  const SmartBinRealtimeLoaded({required this.bins});

  SmartBinRealtimeEntity? bin(String binId) => bins[binId];

  @override
  List<Object?> get props => [bins];
}

class SmartBinRealtimeError extends SmartBinRealtimeState {
  final String message;

  const SmartBinRealtimeError(this.message);

  @override
  List<Object?> get props => [message];
}
