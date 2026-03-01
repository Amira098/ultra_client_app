import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState extends Equatable {
  final LatLng? currentLocation;
  final LatLng? driverLocation;
  final bool loadingCurrent;
  final bool loadingDriver;
  final String? tripStatus;
  final DateTime? tripStartedAt;
  final DateTime? tripCompletedAt;
  final String currentDuration; // Pre-formatted duration string

  // From/To location fields
  final String fromText;
  final String toText;
  final LatLng? fromLocation;
  final LatLng? toLocation;

  const MapState({
    this.currentLocation,
    this.driverLocation,
    this.loadingCurrent = false,
    this.loadingDriver = false,
    this.tripStatus,
    this.tripStartedAt,
    this.tripCompletedAt,
    this.currentDuration = '',
    this.fromText = '',
    this.toText = '',
    this.fromLocation,
    this.toLocation,
  });

  MapState copyWith({
    LatLng? currentLocation,
    LatLng? driverLocation,
    bool? loadingCurrent,
    bool? loadingDriver,
    String? tripStatus,
    DateTime? tripStartedAt,
    DateTime? tripCompletedAt,
    String? currentDuration,
    String? fromText,
    String? toText,
    LatLng? fromLocation,
    LatLng? toLocation,
  }) {
    return MapState(
      currentLocation: currentLocation ?? this.currentLocation,
      driverLocation: driverLocation ?? this.driverLocation,
      loadingCurrent: loadingCurrent ?? this.loadingCurrent,
      loadingDriver: loadingDriver ?? this.loadingDriver,
      tripStatus: tripStatus ?? this.tripStatus,
      tripStartedAt: tripStartedAt ?? this.tripStartedAt,
      tripCompletedAt: tripCompletedAt ?? this.tripCompletedAt,
      currentDuration: currentDuration ?? this.currentDuration,
      fromText: fromText ?? this.fromText,
      toText: toText ?? this.toText,
      fromLocation: fromLocation ?? this.fromLocation,
      toLocation: toLocation ?? this.toLocation,
    );
  }

  @override
  List<Object?> get props => [
    currentLocation,
    driverLocation,
    loadingCurrent,
    loadingDriver,
    tripStatus,
    tripStartedAt,
    tripCompletedAt,
    currentDuration,
    fromText,
    toText,
    fromLocation,
    toLocation,
  ];
}