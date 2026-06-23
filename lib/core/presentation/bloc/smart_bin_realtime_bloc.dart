import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/smart_bin_realtime_entity.dart';
import '../../domain/repositories/smart_bin_realtime_repository.dart';
import 'smart_bin_realtime_event.dart';
import 'smart_bin_realtime_state.dart';

class SmartBinRealtimeBloc
    extends Bloc<SmartBinRealtimeEvent, SmartBinRealtimeState> {
  SmartBinRealtimeBloc({required this.repository})
    : super(const SmartBinRealtimeInitial()) {
    on<SmartBinRealtimeWatchAllRequested>(_onWatchAllRequested);
    on<SmartBinRealtimeWatchBinRequested>(_onWatchBinRequested);
    on<SmartBinRealtimeDataUpdated>(_onDataUpdated);
    on<SmartBinRealtimeStreamError>(_onStreamError);
  }

  final SmartBinRealtimeRepository repository;
  StreamSubscription<Map<String, SmartBinRealtimeEntity>>? _allBinsSubscription;
  StreamSubscription<SmartBinRealtimeEntity?>? _singleBinSubscription;

  Future<void> _onWatchAllRequested(
    SmartBinRealtimeWatchAllRequested event,
    Emitter<SmartBinRealtimeState> emit,
  ) async {
    await _cancelSubscriptions();
    emit(const SmartBinRealtimeLoading());
    _allBinsSubscription = repository.watchAllBins().listen(
      (bins) => add(SmartBinRealtimeDataUpdated(bins)),
      onError: (error) => add(SmartBinRealtimeStreamError(error.toString())),
    );
  }

  Future<void> _onWatchBinRequested(
    SmartBinRealtimeWatchBinRequested event,
    Emitter<SmartBinRealtimeState> emit,
  ) async {
    await _cancelSubscriptions();
    emit(const SmartBinRealtimeLoading());
    _singleBinSubscription = repository.watchBin(event.binId).listen((bin) {
      if (bin == null) {
        add(const SmartBinRealtimeDataUpdated({}));
        return;
      }
      add(SmartBinRealtimeDataUpdated({event.binId: bin}));
    }, onError: (error) => add(SmartBinRealtimeStreamError(error.toString())));
  }

  void _onDataUpdated(
    SmartBinRealtimeDataUpdated event,
    Emitter<SmartBinRealtimeState> emit,
  ) {
    emit(
      SmartBinRealtimeLoaded(
        bins: Map<String, SmartBinRealtimeEntity>.from(event.bins),
      ),
    );
  }

  void _onStreamError(
    SmartBinRealtimeStreamError event,
    Emitter<SmartBinRealtimeState> emit,
  ) {
    emit(SmartBinRealtimeError(event.message));
  }

  Future<void> _cancelSubscriptions() async {
    await _allBinsSubscription?.cancel();
    await _singleBinSubscription?.cancel();
    _allBinsSubscription = null;
    _singleBinSubscription = null;
  }

  @override
  Future<void> close() async {
    await _cancelSubscriptions();
    return super.close();
  }
}
