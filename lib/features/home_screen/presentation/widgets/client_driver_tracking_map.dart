import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ultra_client/features/chat/presentation/view/chat_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../generated/locale_keys.g.dart';
import '../view/map_screen.dart';

class ClientDriverTrackingMap extends StatefulWidget {
  const ClientDriverTrackingMap({
    super.key,
    required this.tripId,
    required this.clientLocation,
    required this.destination,
    this.driverPhone,
  });

  final String tripId;
  final LatLng clientLocation;
  final LatLng destination;
  final String? driverPhone;

  @override
  State<ClientDriverTrackingMap> createState() =>
      _ClientDriverTrackingMapState();
}

class _ClientDriverTrackingMapState extends State<ClientDriverTrackingMap>
    with SingleTickerProviderStateMixin {
  GoogleMapController? _mapController;

  // 🔆 أيقونات السائق كنقطة مضيئة
  BitmapDescriptor? _carIcon;
  BitmapDescriptor? _redCarIcon;

  late AnimationController _rotationController;
  double _currentBearing = 0.0;
  double _targetBearing = 0.0;
  double _startBearing = 0.0;

  LatLng? _driverPosition;

  // UI flags
  bool _reachedClient = false;
  bool _reachedDestination = false;
  bool _isFollowingDriver = true;
  bool _isUserInteracting = false;
  double _mapZoom = 16.0;
  bool _showProgressBox = true;

  // Route (client → destination) للعرض والحساب
  List<LatLng> _routeClientToDestination = [];
  List<double> _routeCumulativeDistances = []; // مسافات تراكمية على طول المسار
  double _routeProgressFraction = 0.0; // 0 → 1
  double _totalRouteDistanceMeters = 0.0;

  final String _googleApiKey = AppValues.googleMapsApiKey;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  bool _isLoading = false;
  StreamSubscription<DocumentSnapshot>? _locationSub;
  Timer? _followTimer;

  static const double _arriveThresholdMeters = 50.0;
  static const int _cameraUpdateMinMs = 500;
  DateTime _lastCameraUpdate = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {
          _currentBearing = ui.lerpDouble(
            _startBearing,
            _targetBearing,
            _rotationController.value,
          )!;
        });
      });

    _initCarIcons();
    _setupMarkers();
    _loadRouteClientToDestination();
    _listenToDriverLocation();
  }

  Future<void> _initCarIcons() async {
    try {
      _carIcon = await _createGlowingDotIcon(Colors.blue);
      _redCarIcon = await _createGlowingDotIcon(Colors.red);
    } catch (e) {
      debugPrint("Error creating glowing icons: $e");
      _carIcon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      _redCarIcon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }

  Future<BitmapDescriptor> _createGlowingDotIcon(Color color) async {
    const double coreSize = 40;
    const double glowSpread = 180;
    final double size = coreSize + glowSpread * 2;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTRB(0, 0, size, size));
    final center = Offset(size / 2, size / 2);

    final outerGlowPaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        glowSpread,
        [
          color.withOpacity(0.0),
          color.withOpacity(0.18),
          color.withOpacity(0.0),
        ],
        [0.0, 0.55, 1.0],
      );
    canvas.drawCircle(center, glowSpread, outerGlowPaint);

    final middleGlowPaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        glowSpread * 0.55,
        [
          color.withOpacity(0.0),
          color.withOpacity(0.35),
          color.withOpacity(0.0),
        ],
        [0.0, 0.7, 1.0],
      );
    canvas.drawCircle(center, glowSpread * 0.55, middleGlowPaint);

    final corePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, coreSize / 2, corePaint);

    final highlightPaint = Paint()..color = Colors.white.withOpacity(0.85);
    canvas.drawCircle(
      center.translate(-4, -4),
      4,
      highlightPaint,
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  void _setupMarkers() {
    _markers = {
      Marker(
        markerId: const MarkerId("client"),
        position: widget.clientLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow:
            InfoWindow(title: LocaleKeys.Authentication_clientLocation.tr()),
        anchor: const Offset(0.5, 0.5),
      ),
      Marker(
        markerId: const MarkerId("destination"),
        position: widget.destination,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow:
            InfoWindow(title: LocaleKeys.Authentication_destination.tr()),
        anchor: const Offset(0.5, 0.5),
      ),
    };
  }

  Future<void> _loadRouteClientToDestination() async {
    setState(() => _isLoading = true);

    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/directions/json?"
      "origin=${widget.clientLocation.latitude},${widget.clientLocation.longitude}&"
      "destination=${widget.destination.latitude},${widget.destination.longitude}&"
      "key=$_googleApiKey",
    );

    try {
      final response = await Dio().get(url.toString());
      final data =
          response.data is String ? json.decode(response.data) : response.data;

      if (data['status'] == 'OK') {
        final points = data['routes'][0]['overview_polyline']['points'];
        final decoded = PolylinePoints().decodePolyline(points);

        List<LatLng> route =
            decoded.map((p) => LatLng(p.latitude, p.longitude)).toList();

        if (route.isNotEmpty) {
          route[0] = widget.clientLocation;
          route[route.length - 1] = widget.destination;
        } else {
          route = [widget.clientLocation, widget.destination];
        }

        final cumulative = <double>[];
        double acc = 0.0;
        cumulative.add(0.0);

        for (int i = 1; i < route.length; i++) {
          acc += _distanceBetween(
            route[i - 1].latitude,
            route[i - 1].longitude,
            route[i].latitude,
            route[i].longitude,
          );
          cumulative.add(acc);
        }

        setState(() {
          _routeClientToDestination = route;
          _routeCumulativeDistances = cumulative;
          _totalRouteDistanceMeters =
              cumulative.isNotEmpty ? cumulative.last : 0.0;

          _polylines.add(
            Polyline(
              polylineId: const PolylineId("client_to_destination"),
              color: Colors.orange,
              width: 5,
              points: _routeClientToDestination,
            ),
          );
        });
      } else {
        debugPrint("Route error: ${data['status']}");
      }
    } catch (e) {
      debugPrint("Directions API error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _listenToDriverLocation() {
    _locationSub = FirebaseFirestore.instance
        .collection('trips_locations')
        .doc(widget.tripId)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) return;
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data == null) return;

      final lat = data['lat'] as num?;
      final lng = data['lng'] as num?;
      if (lat == null || lng == null) return;

      final newPos = LatLng(lat.toDouble(), lng.toDouble());

      // حساب الاتجاه (bearing)
      if (_driverPosition != null) {
        final bearing = _calculateBearing(_driverPosition!, newPos);
        _updateBearing(bearing);
      }

      _updateDriverPosition(newPos);
      _updateProgressAndStatus(newPos);
    }, onError: (e) {
      debugPrint('Client driver location listener error: $e');
    });
  }

  double _calculateBearing(LatLng from, LatLng to) {
    final lat1 = from.latitude * math.pi / 180;
    final lon1 = from.longitude * math.pi / 180;
    final lat2 = to.latitude * math.pi / 180;
    final lon2 = to.longitude * math.pi / 180;

    final dLon = lon2 - lon1;

    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    final bearing = math.atan2(y, x);

    return (bearing * 180 / math.pi + 360) % 360;
  }

  void _updateBearing(double newBearing) {
    double diff = (newBearing - _currentBearing).abs();
    if (diff > 180) diff = 360 - diff;
    if (diff < 1) return;

    _startBearing = _currentBearing;
    _targetBearing = newBearing;

    _rotationController
      ..reset()
      ..forward();
  }

  void _updateDriverPosition(LatLng position) {
    final now = DateTime.now();
    final canAnimateCamera = _isFollowingDriver &&
        !_isUserInteracting &&
        _mapController != null &&
        now.difference(_lastCameraUpdate).inMilliseconds > _cameraUpdateMinMs;

    setState(() {
      _driverPosition = position;

      _markers.removeWhere((m) => m.markerId.value == "driver");
      _markers.add(
        Marker(
          markerId: const MarkerId("driver"),
          position: position,
          icon: (_reachedDestination ? _redCarIcon : _carIcon) ??
              BitmapDescriptor.defaultMarker,
          rotation: _currentBearing,
          anchor: const Offset(0.5, 0.5),
          infoWindow: _reachedDestination
              ? InfoWindow(
                  title: LocaleKeys.Authentication_arrivedAtDestination.tr())
              : InfoWindow(
                  title: LocaleKeys.Authentication_driverOnTheWay.tr()),
        ),
      );

      if (canAnimateCamera) {
        _lastCameraUpdate = now;
      }
    });

    if (canAnimateCamera) {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: _mapZoom,
            bearing: _currentBearing,
          ),
        ),
      );
    }
  }

  void _updateProgressAndStatus(LatLng driverPos) {
    // مسافة بين السواق والعميل
    final distanceToClient = _distanceBetween(
      driverPos.latitude,
      driverPos.longitude,
      widget.clientLocation.latitude,
      widget.clientLocation.longitude,
    );

    // مسافة بين السواق والوجهة
    final distanceToDestination = _distanceBetween(
      driverPos.latitude,
      driverPos.longitude,
      widget.destination.latitude,
      widget.destination.longitude,
    );

    // لو لسه ماوصلش للعميل
    if (!_reachedClient && distanceToClient <= _arriveThresholdMeters) {
      _reachedClient = true;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.amber,
            content: Text(
                LocaleKeys.Authentication_driverArrivedAtYourLocation.tr(),style: TextStyle(fontSize: 16, color: AppColors.white)),
          ),
        );
      }
    }

    // لو وصل قريب من الوجهة
    if (!_reachedDestination &&
        distanceToDestination <= _arriveThresholdMeters) {
      _reachedDestination = true;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.amber,
            content: Text(LocaleKeys.Authentication_arrivedAtDestination.tr(),style: TextStyle(fontSize: 16, color: AppColors.white)),
          ),
        );
      }

      _showArrivalDialog();
    }

    // Progress على طول مسار Google Directions
    if (_routeClientToDestination.isNotEmpty &&
        _routeCumulativeDistances.length == _routeClientToDestination.length &&
        _totalRouteDistanceMeters > 0) {
      final fraction = _calculateRouteProgressFraction(driverPos);
      setState(() {
        _routeProgressFraction = fraction;
      });
    }
  }

  double _calculateRouteProgressFraction(LatLng driverPos) {
    if (_routeClientToDestination.isEmpty ||
        _routeCumulativeDistances.isEmpty ||
        _totalRouteDistanceMeters <= 0) {
      return 0.0;
    }

    int closestIndex = 0;
    double closestDist = double.infinity;

    for (int i = 0; i < _routeClientToDestination.length; i++) {
      final p = _routeClientToDestination[i];
      final d = _distanceBetween(
        driverPos.latitude,
        driverPos.longitude,
        p.latitude,
        p.longitude,
      );

      if (d < closestDist) {
        closestDist = d;
        closestIndex = i;
      }
    }

    final covered = _routeCumulativeDistances[closestIndex];
    final fraction = (covered / _totalRouteDistanceMeters).clamp(0.0, 1.0);

    return fraction;
  }

  double _distanceBetween(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  void _showArrivalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.Authentication_arrived.tr(),style: TextStyle(fontSize: 16, color: AppColors.amber)),
        content: Text(LocaleKeys.Authentication_arrivalMessage.tr(),style: TextStyle(fontSize: 16, color: AppColors.amber)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MapScreen())),
            child: Text(
              LocaleKeys.Authentication_ok.tr(),
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _handleUserInteraction() {
    setState(() {
      _isUserInteracting = true;
      _isFollowingDriver = false;
    });
    _followTimer?.cancel();
  }

  void _startFollowTimer() {
    _followTimer?.cancel();
    _followTimer = Timer(const Duration(seconds: 10), () {
      if (!mounted) return;
      if (!_isUserInteracting && _driverPosition != null) {
        setState(() => _isFollowingDriver = true);
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _driverPosition!,
              zoom: _mapZoom,
              bearing: _currentBearing,
            ),
          ),
        );
        _lastCameraUpdate = DateTime.now();
      }
    });
  }

  Future<void> _callDriver() async {
    final phone = widget.driverPhone;
    if (phone == null || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(  backgroundColor: AppColors.amber,
          content: Text(LocaleKeys.Authentication_driverPhoneNotAvailable.tr(),style: TextStyle(fontSize: 16, color: AppColors.white)),
        ),
      );
      return;
    }

    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.amber,
          content: Text(LocaleKeys.Authentication_cannotMakeCallNow.tr(),style: TextStyle(fontSize: 16, color: AppColors.white)),
        ),
      );
    }
  }

  // 🆕 فتح شاشة الشات
  void _openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          rideId: widget.tripId,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _locationSub?.cancel();
    _followTimer?.cancel();
    _rotationController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressPercent = _routeClientToDestination.isNotEmpty
        ? (_routeProgressFraction * 100).toStringAsFixed(1)
        : "0.0";

    String remainingText =
        LocaleKeys.Authentication_metersRemaining.tr(args: ['0.0']);

    if (_routeClientToDestination.isNotEmpty && _totalRouteDistanceMeters > 0) {
      final remainingMeters =
          _totalRouteDistanceMeters * (1 - _routeProgressFraction);

      if (remainingMeters >= 1000) {
        remainingText = LocaleKeys.Authentication_kmRemaining.tr(
            args: [(remainingMeters / 1000).toStringAsFixed(1)]);
      } else {
        remainingText = LocaleKeys.Authentication_metersRemaining.tr(
            args: [remainingMeters.toStringAsFixed(0)]);
      }
    }

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.clientLocation,
              zoom: _mapZoom,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            onCameraMove: (position) => _mapZoom = position.zoom,
            onCameraMoveStarted: _handleUserInteraction,
            onCameraIdle: () {
              setState(() => _isUserInteracting = false);
              _startFollowTimer();
            },
          ),

          // صندوق التقدم
          if (_showProgressBox && !_reachedDestination)
            Positioned(
              top: 95,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _reachedClient
                          ? LocaleKeys.Authentication_onTheWayToDestination.tr()
                          : LocaleKeys.Authentication_driverOnTheWayToYou.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _routeClientToDestination.isNotEmpty
                          ? _routeProgressFraction
                          : null,
                      backgroundColor: Colors.grey[300],
                      color: _reachedClient ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$progressPercent%",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          remainingText,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // توضيح الألوان (العميل / الوجهة)
          if (!_reachedDestination)
            Positioned(
              top: 30,
              left: 100,
              right: 100,
              child: InkWell(
                onTap: () =>
                    setState(() => _showProgressBox = !_showProgressBox),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // العميل
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.Authentication_client.tr(),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 16),
                      // الوجهة
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.Authentication_destination.tr(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          if (_isLoading) const Center(child: CircularProgressIndicator()),

          // أزرار الكول والشات
          if (!_reachedDestination)
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green,
                        side: const BorderSide(color: Colors.green),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: _callDriver,
                      icon: const Icon(Icons.call),
                      label: Text(
                        LocaleKeys.Authentication_callDriver.tr(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: _openChat,
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: Text(
                        LocaleKeys.Authentication_chatWithDriver.tr(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
