import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/bin_entity.dart';
import '../../domain/repositories/bin_repository.dart';
import 'bin_event.dart';
import 'bin_state.dart';

class BinBloc extends Bloc<BinEvent, BinState> {
  final BinRepository binRepository;

  BinBloc({required this.binRepository}) : super(const BinInitial()) {
    on<BinLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    BinLoadRequested event,
    Emitter<BinState> emit,
  ) async {
    emit(const BinLoading());
    try {
      final bins = await binRepository.getAllBins();
      emit(BinLoaded(bins: bins));
    } catch (e) {
      emit(BinError(e.toString()));
    }
  }
}
