import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/shared/utils/firebase_error_helper.dart';
import '../../../user/domain/entities/report_entity.dart';
import '../../../user/domain/repositories/report_repository.dart';

part 'worker_report_event.dart';
part 'worker_report_state.dart';

class WorkerReportBloc extends Bloc<WorkerReportEvent, WorkerReportState> {
  final ReportRepository reportRepository;
  final SharedPreferences sharedPreferences;

  WorkerReportBloc({
    required this.reportRepository,
    required this.sharedPreferences,
  }) : super(const WorkerReportInitial()) {
    on<WorkerWatchReportsEvent>(_onWatchReports);
    on<WorkerTakeReportEvent>(_onTakeReport);
    on<WorkerRespondReportEvent>(_onRespondReport);
    on<WorkerResolveReportEvent>(_onResolveReport);
    on<WorkerDeleteReportEvent>(_onDeleteReport);
    on<WorkerFilterReportsEvent>(_onFilterReports);
  }

  List<ReportEntity> _allReports = [];
  ReportStatus? _filterStatus;

  String get _workerId =>
      sharedPreferences.getString('user_id') ?? 'worker_unknown';

  String get _workerName => sharedPreferences.getString('username') ?? 'عامل';

  WorkerReportLoaded _buildLoadedState() {
    return WorkerReportLoaded(
      reports: _applyFilter(_allReports),
      allReports: _allReports,
      filterStatus: _filterStatus,
    );
  }

  Future<void> _onWatchReports(
    WorkerWatchReportsEvent event,
    Emitter<WorkerReportState> emit,
  ) async {
    emit(const WorkerReportLoading());
    try {
      _allReports = await reportRepository.getAllReports();
      emit(_buildLoadedState());

      await emit.forEach<List<ReportEntity>>(
        reportRepository.watchAllReports(),
        onData: (reports) {
          _allReports = reports;
          return _buildLoadedState();
        },
        onError: (error, _) {
          if (_allReports.isNotEmpty) return _buildLoadedState();
          return WorkerReportError(
            message: FirebaseErrorHelper.toUserMessage(error),
          );
        },
      );
    } catch (e) {
      emit(WorkerReportError(message: FirebaseErrorHelper.toUserMessage(e)));
    }
  }

  void _onFilterReports(
    WorkerFilterReportsEvent event,
    Emitter<WorkerReportState> emit,
  ) {
    _filterStatus = event.status;
    if (_allReports.isNotEmpty || state is WorkerReportLoaded) {
      emit(_buildLoadedState());
    }
  }

  List<ReportEntity> _applyFilter(List<ReportEntity> reports) {
    if (_filterStatus == null) {
      return reports
          .where(
            (r) =>
                r.status != ReportStatus.resolved &&
                r.status != ReportStatus.rejected,
          )
          .toList();
    }
    return reports.where((r) => r.status == _filterStatus).toList();
  }

  Future<void> _onTakeReport(
    WorkerTakeReportEvent event,
    Emitter<WorkerReportState> emit,
  ) async {
    emit(WorkerReportActionInProgress(reportId: event.reportId));
    try {
      await reportRepository.updateReport(
        reportId: event.reportId,
        status: ReportStatus.inProgress,
        workerId: _workerId,
        workerName: _workerName,
      );
      emit(
        const WorkerReportActionSuccess(
          message: 'تم استلام البلاغ وبدء المعالجة',
        ),
      );
    } catch (e) {
      emit(
        WorkerReportActionFailure(
          message: FirebaseErrorHelper.toUserMessage(e),
        ),
      );
    }
  }

  Future<void> _onRespondReport(
    WorkerRespondReportEvent event,
    Emitter<WorkerReportState> emit,
  ) async {
    emit(WorkerReportActionInProgress(reportId: event.reportId));
    try {
      await reportRepository.updateReport(
        reportId: event.reportId,
        status: ReportStatus.inProgress,
        workerId: _workerId,
        workerName: _workerName,
        workerResponse: event.response,
      );
      emit(const WorkerReportActionSuccess(message: 'تم إرسال الرد'));
    } catch (e) {
      emit(
        WorkerReportActionFailure(
          message: FirebaseErrorHelper.toUserMessage(e),
        ),
      );
    }
  }

  Future<void> _onResolveReport(
    WorkerResolveReportEvent event,
    Emitter<WorkerReportState> emit,
  ) async {
    emit(WorkerReportActionInProgress(reportId: event.reportId));
    try {
      await reportRepository.markAsResolved(
        reportId: event.reportId,
        workerId: _workerId,
        workerName: _workerName,
        workerResponse: event.response,
      );
      emit(
        const WorkerReportActionSuccess(
          message: 'تم حل البلاغ — سيُحذف تلقائياً بعد 25 دقيقة',
        ),
      );
    } catch (e) {
      emit(
        WorkerReportActionFailure(
          message: FirebaseErrorHelper.toUserMessage(e),
        ),
      );
    }
  }

  Future<void> _onDeleteReport(
    WorkerDeleteReportEvent event,
    Emitter<WorkerReportState> emit,
  ) async {
    emit(WorkerReportActionInProgress(reportId: event.reportId));
    try {
      await reportRepository.deleteReport(event.reportId);
      emit(const WorkerReportActionSuccess(message: 'تم حذف البلاغ'));
    } catch (e) {
      emit(
        WorkerReportActionFailure(
          message: FirebaseErrorHelper.toUserMessage(e),
        ),
      );
    }
  }
}
