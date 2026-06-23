import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/shared/utils/firebase_error_helper.dart';
import '../../../user/domain/entities/report_entity.dart';
import '../../../user/domain/repositories/report_repository.dart';

part 'admin_report_event.dart';
part 'admin_report_state.dart';

class AdminReportBloc extends Bloc<AdminReportEvent, AdminReportState> {
  final ReportRepository reportRepository;

  AdminReportBloc({required this.reportRepository})
    : super(const AdminReportInitial()) {
    on<AdminWatchReportsEvent>(_onWatchReports);
    on<AdminUpdateReportEvent>(_onUpdateReport);
    on<AdminDeleteReportEvent>(_onDeleteReport);
    on<AdminFilterReportsEvent>(_onFilterReports);
  }

  List<ReportEntity> _allReports = [];
  ReportStatus? _filterStatus;

  AdminReportLoaded _buildLoadedState() {
    return AdminReportLoaded(
      reports: _applyFilter(_allReports),
      allReports: _allReports,
      filterStatus: _filterStatus,
    );
  }

  Future<void> _onWatchReports(
    AdminWatchReportsEvent event,
    Emitter<AdminReportState> emit,
  ) async {
    emit(const AdminReportLoading());
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
          return AdminReportError(
            message: FirebaseErrorHelper.toUserMessage(error),
          );
        },
      );
    } catch (e) {
      emit(AdminReportError(message: FirebaseErrorHelper.toUserMessage(e)));
    }
  }

  void _onFilterReports(
    AdminFilterReportsEvent event,
    Emitter<AdminReportState> emit,
  ) {
    _filterStatus = event.status;
    if (_allReports.isNotEmpty || state is AdminReportLoaded) {
      emit(_buildLoadedState());
    }
  }

  List<ReportEntity> _applyFilter(List<ReportEntity> reports) {
    if (_filterStatus == null) return reports;
    return reports.where((r) => r.status == _filterStatus).toList();
  }

  Future<void> _onUpdateReport(
    AdminUpdateReportEvent event,
    Emitter<AdminReportState> emit,
  ) async {
    emit(AdminReportActionInProgress(reportId: event.reportId));
    try {
      await reportRepository.updateReport(
        reportId: event.reportId,
        status: event.status,
        adminNote: event.adminNote,
      );
      emit(const AdminReportActionSuccess(message: 'تم تحديث البلاغ بنجاح'));
    } catch (e) {
      emit(
        AdminReportActionFailure(message: FirebaseErrorHelper.toUserMessage(e)),
      );
    }
  }

  Future<void> _onDeleteReport(
    AdminDeleteReportEvent event,
    Emitter<AdminReportState> emit,
  ) async {
    emit(AdminReportActionInProgress(reportId: event.reportId));
    try {
      await reportRepository.deleteReport(event.reportId);
      emit(const AdminReportActionSuccess(message: 'تم حذف البلاغ'));
    } catch (e) {
      emit(
        AdminReportActionFailure(message: FirebaseErrorHelper.toUserMessage(e)),
      );
    }
  }
}
