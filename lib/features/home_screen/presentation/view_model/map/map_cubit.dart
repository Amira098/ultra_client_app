import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../../data/data_sources_imp/location_service.dart';
import '../../../data/data_sources_imp/trip_repository.dart';
import 'map_state.dart';

@injectable
class MapCubit extends Cubit<MapState> {
  final LocationService locationService;
  final TripRepository tripRepository;

  StreamSubscription? _tripSub;
  StreamSubscription? _driverSub;
  Timer? _durationTimer;

  MapCubit({
    required this.locationService,
    required this.tripRepository,
  }) : super(const MapState());

  Future<void> initCurrentLocation() async {
    emit(state.copyWith(loadingCurrent: true));
    final res = await locationService.getCurrentLatLng();
    emit(state.copyWith(currentLocation: res, loadingCurrent: false));
  }

  void startTripStreams(String tripId) {
    _tripSub?.cancel();
    _driverSub?.cancel();
    _durationTimer?.cancel();

    _tripSub = tripRepository.tripStream(tripId).listen((snap) {
      if (!snap.exists) return;
      final data = snap.data();
      final status = data?['status'] as String?;
      final startedAt = (data?['startedAt'] as Timestamp?)?.toDate();
      final completedAt = (data?['completedAt'] as Timestamp?)?.toDate();

      emit(state.copyWith(
        tripStatus: status,
        tripStartedAt: startedAt,
        tripCompletedAt: completedAt,
      ));

      // Start or stop timer based on trip state
      if (startedAt != null && completedAt == null) {
        _startDurationTimer();
      } else {
        _stopDurationTimer();
      }
    });

    _driverSub = tripRepository.driverLocationStream(tripId).listen((snap) {
      if (!snap.exists) return;
      emit(state.copyWith(
        driverLocation: tripRepository.parseLatLng(snap.data()),
        loadingDriver: false,
      ));
    }, onError: (_) {
      emit(state.copyWith(loadingDriver: false));
    });
  }

  void _startDurationTimer() {
    _durationTimer?.cancel();

    // Update immediately
    emit(state.copyWith(currentDuration: _calculateDuration()));

    // Then update every second
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.tripCompletedAt == null) {
        emit(state.copyWith(currentDuration: _calculateDuration()));
      }
    });
  }

  void _stopDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = null;
  }

  String _calculateDuration() {
    final s = state;
    if (s.tripStartedAt == null) return '';
    final end = s.tripCompletedAt ?? DateTime.now();
    final d = end.difference(s.tripStartedAt!);
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final sec = d.inSeconds.remainder(60);

    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  void stopStreams() {
    _tripSub?.cancel();
    _driverSub?.cancel();
    _stopDurationTimer();
  }

  void setFrom(LatLng loc, String label) =>
      emit(state.copyWith(fromLocation: loc, fromText: label));

  void setTo(LatLng loc, String label) =>
      emit(state.copyWith(toLocation: loc, toText: label));

  String formatDurationText() {
    return state.currentDuration;
  }

  @override
  Future<void> close() {
    stopStreams();
    return super.close();
  }
}