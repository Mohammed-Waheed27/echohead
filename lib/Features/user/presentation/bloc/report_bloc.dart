import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';
import '../../data/models/report_model.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository reportRepository;

  ReportBloc({required this.reportRepository}) : super(const ReportInitial()) {
    on<SubmitReportEvent>(_onSubmitReport);
    on<LoadReportsHistoryEvent>(_onLoadReportsHistory);
  }

  Future<void> _onSubmitReport(
    SubmitReportEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(const ReportSubmitting());
    try {
      final report = ReportModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        issueType: event.issueType,
        description: event.description,
        latitude: event.latitude,
        longitude: event.longitude,
        address: event.address,
        imagePath: event.imagePath,
        severity: event.severity,
        status: ReportStatus.pending,
        createdAt: DateTime.now(),
      );
      await reportRepository.submitReport(report);
      emit(const ReportSubmitSuccess());
    } catch (e) {
      emit(ReportSubmitFailure(message: e.toString()));
    }
  }

  Future<void> _onLoadReportsHistory(
    LoadReportsHistoryEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(const ReportHistoryLoading());
    try {
      final reports = await reportRepository.getReportsHistory();
      emit(ReportHistoryLoaded(reports: reports));
    } catch (e) {
      emit(ReportHistoryLoadFailure(message: e.toString()));
    }
  }
}
