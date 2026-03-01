import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TripRepository {
  final FirebaseFirestore _fs;
  TripRepository(this._fs);

  Stream<DocumentSnapshot<Map<String, dynamic>>> tripStream(String tripId) =>
      _fs.collection('trips').doc(tripId).snapshots();

  Stream<DocumentSnapshot<Map<String, dynamic>>> driverLocationStream(String tripId) =>
      _fs.collection('trips_locations').doc(tripId).snapshots();

  LatLng? parseLatLng(Map<String, dynamic>? data) {
    if (data == null) return null;
    final lat = (data['lat'] as num?)?.toDouble();
    final lng = (data['lng'] as num?)?.toDouble();
    if (lat == null || lng == null) return null;
    return LatLng(lat, lng);
  }
}
