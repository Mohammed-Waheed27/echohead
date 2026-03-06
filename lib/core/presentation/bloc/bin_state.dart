import 'package:equatable/equatable.dart';
import '../../domain/entities/bin_entity.dart';

abstract class BinState extends Equatable {
  const BinState();

  @override
  List<Object?> get props => [];
}

class BinInitial extends BinState {
  const BinInitial();
}

class BinLoading extends BinState {
  const BinLoading();
}

class BinLoaded extends BinState {
  final List<BinEntity> bins;

  const BinLoaded({required this.bins});

  bool get hasGasEmergency =>
      bins.any((b) => b.hasGasEmergency);

  @override
  List<Object?> get props => [bins];
}

class BinError extends BinState {
  final String message;

  const BinError(this.message);

  @override
  List<Object?> get props => [message];
}
