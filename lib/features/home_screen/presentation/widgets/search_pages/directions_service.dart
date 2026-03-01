import 'package:flutter_google_maps_webservices/directions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/constants/app_values.dart';

class DirectionsService {
  final _directions = GoogleMapsDirections(
    apiKey: AppValues.googleMapsApiKey,
  );
  Future<RouteInfo> getRouteInfo(LatLng from, LatLng to) async {
    final result = await _directions.directionsWithLocation(
      Location(lat: from.latitude, lng: from.longitude),
      Location(lat: to.latitude, lng: to.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.isOkay && result.routes.isNotEmpty) {
      final leg = result.routes.first.legs.first;
      return RouteInfo(
        distanceKm: leg.distance.value.toDouble() / 1000,
        durationText: leg.duration.text,
        durationSeconds: leg.duration.value.toInt(),
        polyline: result.routes.first.overviewPolyline.points,
      );
    } else {
      throw Exception(result.errorMessage ?? 'Directions API error');
    }
  }
}

class RouteInfo {
  final double distanceKm;
  final String durationText;
  final int durationSeconds;
  final String polyline;

  RouteInfo({
    required this.distanceKm,
    required this.durationText,
    required this.durationSeconds,
    required this.polyline,
  });
}
