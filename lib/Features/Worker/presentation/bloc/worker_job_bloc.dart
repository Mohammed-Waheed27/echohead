import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/worker_job_entity.dart';
import '../../domain/repositories/worker_job_repository.dart';

part 'worker_job_event.dart';
part 'worker_job_state.dart';

class WorkerJobBloc extends Bloc<WorkerJobEvent, WorkerJobState> {
  final WorkerJobRepository jobRepository;

  WorkerJobBloc({required this.jobRepository}) : super(WorkerJobInitial()) {
    on<WorkerJobLoadRequested>(_onLoadRequested);
    on<WorkerJobMarkDoneRequested>(_onMarkDoneRequested);
    on<WorkerJobShowOptimizedRouteRequested>(_onShowOptimizedRouteRequested);
  }

  Future<void> _onLoadRequested(
    WorkerJobLoadRequested event,
    Emitter<WorkerJobState> emit,
  ) async {
    emit(WorkerJobLoading());
    try {
      final jobs = await jobRepository.getAssignedJobs();
      emit(WorkerJobLoaded(jobs: jobs));
    } catch (e) {
      emit(WorkerJobError(e.toString()));
    }
  }

  Future<void> _onMarkDoneRequested(
    WorkerJobMarkDoneRequested event,
    Emitter<WorkerJobState> emit,
  ) async {
    if (state is! WorkerJobLoaded) return;
    final currentState = state as WorkerJobLoaded;
    try {
      await jobRepository.markJobAsDone(event.jobId);
      final updatedJobs = currentState.jobs.map((job) {
        if (job.id == event.jobId) {
          return job.copyWith(status: WorkerJobStatus.done);
        }
        return job;
      }).toList();
      emit(WorkerJobLoaded(
        jobs: updatedJobs,
        optimizedRouteOrder: currentState.optimizedRouteOrder,
      ));
    } catch (e) {
      emit(WorkerJobError(e.toString()));
    }
  }

  void _onShowOptimizedRouteRequested(
    WorkerJobShowOptimizedRouteRequested event,
    Emitter<WorkerJobState> emit,
  ) {
    if (state is! WorkerJobLoaded) return;
    final currentState = state as WorkerJobLoaded;
    final pending = currentState.pendingJobs;
    if (pending.isEmpty) return;
    final ordered = _shortestPathRoute(pending);
    emit(WorkerJobLoaded(
      jobs: currentState.jobs,
      optimizedRouteOrder: ordered,
    ));
  }

  /// Computes the true shortest path by trying all permutations (TSP).
  List<WorkerJobEntity> _shortestPathRoute(List<WorkerJobEntity> jobs) {
    if (jobs.isEmpty) return [];
    if (jobs.length == 1) return jobs;
    List<WorkerJobEntity> bestOrder = List.from(jobs);
    double bestTotal = double.infinity;
    final indices = List.generate(jobs.length, (i) => i);
    final perms = _permutations(indices);
    for (final perm in perms) {
      final order = perm.map((i) => jobs[i]).toList();
      double total = 0;
      for (var i = 0; i < order.length - 1; i++) {
        total += _haversine(
          order[i].latitude,
          order[i].longitude,
          order[i + 1].latitude,
          order[i + 1].longitude,
        );
      }
      if (total < bestTotal) {
        bestTotal = total;
        bestOrder = order;
      }
    }
    return bestOrder;
  }

  List<List<int>> _permutations(List<int> items) {
    if (items.isEmpty) return [[]];
    if (items.length == 1) return [items];
    final result = <List<int>>[];
    for (var i = 0; i < items.length; i++) {
      final rest = List<int>.from(items)..removeAt(i);
      for (final perm in _permutations(rest)) {
        result.add([items[i], ...perm]);
      }
    }
    return result;
  }

  double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371000.0;
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRad(double deg) => deg * math.pi / 180;
}
