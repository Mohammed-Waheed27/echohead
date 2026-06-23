import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/shared/utils/firebase_error_helper.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';
import '../../data/models/report_model.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository reportRepository;
  final SharedPreferences sharedPreferences;

  ReportBloc({required this.reportRepository, required this.sharedPreferences})
    : super(const ReportInitial()) {
    on<SubmitReportEvent>(_onSubmitReport);
    on<LoadReportsHistoryEvent>(_onLoadReportsHistory);
    on<WatchUserReportsEvent>(_onWatchUserReports);
  }

  Future<String> _resolveUserId() async {
    final userId = sharedPreferences.getString('user_id');
    if (userId != null && userId.isNotEmpty) return userId;
    return reportRepository.getOrCreateGuestUserId();
  }

  String _resolveUserName() {
    return sharedPreferences.getString('username') ?? 'مستخدم';
  }

  Future<void> _onSubmitReport(
    SubmitReportEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(const ReportSubmitting());
    Object? lastError;

    for (var attempt = 0; attempt < 3; attempt++) {
      try {
        if (attempt > 0) {
          await Future<void>.delayed(Duration(seconds: attempt));
        }
        final userId = await _resolveUserId();
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
          userId: userId,
          userName: _resolveUserName(),
        );
        await reportRepository.submitReport(report);
        emit(const ReportSubmitSuccess());
        return;
      } catch (e) {
        lastError = e;
      }
    }

    emit(
      ReportSubmitFailure(
        message: FirebaseErrorHelper.toUserMessage(lastError ?? 'unknown'),
      ),
    );
  }

  Future<void> _onLoadReportsHistory(
    LoadReportsHistoryEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(const ReportHistoryLoading());
    try {
      final userId = await _resolveUserId();
      final reports = await reportRepository.getReportsHistory(userId: userId);
      emit(ReportHistoryLoaded(reports: reports));
    } catch (e) {
      emit(
        ReportHistoryLoadFailure(message: FirebaseErrorHelper.toUserMessage(e)),
      );
    }
  }

  Future<void> _onWatchUserReports(
    WatchUserReportsEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(const ReportHistoryLoading());
    try {
      final userId = await _resolveUserId();
      final initialReports = await reportRepository.getReportsHistory(
        userId: userId,
      );
      emit(ReportHistoryLoaded(reports: initialReports));

      await emit.forEach<List<ReportEntity>>(
        reportRepository.watchUserReports(userId),
        onData: (reports) => ReportHistoryLoaded(reports: reports),
        onError: (error, _) => ReportHistoryLoadFailure(
          message: FirebaseErrorHelper.toUserMessage(error),
        ),
      );
    } catch (e) {
      emit(
        ReportHistoryLoadFailure(message: FirebaseErrorHelper.toUserMessage(e)),
      );
    }
  }
}
