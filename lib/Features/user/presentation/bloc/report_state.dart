part of 'report_bloc.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {
  const ReportInitial();
}

class ReportSubmitting extends ReportState {
  const ReportSubmitting();
}

class ReportSubmitSuccess extends ReportState {
  const ReportSubmitSuccess();
}

class ReportSubmitFailure extends ReportState {
  final String message;

  const ReportSubmitFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ReportHistoryLoading extends ReportState {
  const ReportHistoryLoading();
}

class ReportHistoryLoaded extends ReportState {
  final List<ReportEntity> reports;

  const ReportHistoryLoaded({required this.reports});

  @override
  List<Object?> get props => [reports];
}

class ReportHistoryLoadFailure extends ReportState {
  final String message;

  const ReportHistoryLoadFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
