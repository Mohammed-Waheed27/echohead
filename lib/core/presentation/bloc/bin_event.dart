import 'package:equatable/equatable.dart';

abstract class BinEvent extends Equatable {
  const BinEvent();

  @override
  List<Object?> get props => [];
}

class BinLoadRequested extends BinEvent {
  const BinLoadRequested();
}
