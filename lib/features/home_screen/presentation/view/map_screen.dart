// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ultra_client/features/home_screen/presentation/widgets/search_pages/search_bottom_sheet_content.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/constants/font_size.dart';
import '../../../../core/utils/app_shared_preference.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/utils/customTextField.dart';
import '../../../../core/widgets/circle_icon_button.dart';
import '../../../../core/widgets/loading_circle_icon_button.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../drawer_screen/presentation/view/notifications_screen.dart';
import '../widgets/choose_location_screen.dart';
import '../widgets/client_driver_tracking_map.dart';
import '../widgets/custom_drawer.dart';
import '../../../chat/presentation/view/chat_screen.dart';
import '../widgets/live_timer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key? key,
    this.tripId,
    this.driverStart,
    this.pickupLocation,
    this.dropoffLocation,
    this.driverPhone,
  }) : super(key: key);

  final String? tripId;
  final LatLng? driverStart;
  final LatLng? pickupLocation;
  final LatLng? dropoffLocation;
  final String? driverPhone;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LatLng? currentLocation;
  LatLng? driverLocation;

  final _fromLocationController = TextEditingController();
  final _toLocationController = TextEditingController();

  LatLng? _fromLocation;
  LatLng? _toLocation;
  String? _currentField;

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();

  bool _shownDriverArrivedSnack = false;
  bool _shownCompletedDialog = false;

  StreamSubscription<DocumentSnapshot>? _tripSubscription;
  StreamSubscription<DocumentSnapshot>? _locationSubscription;

  String _userName = '';
  String _userEmail = '';
  String _image = '';

  Future<void> _makePhoneCall(BuildContext context, String? phone) async {
    if (phone == null || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(LocaleKeys.Authentication_phoneNotAvailable.tr())),
      );
      return;
    }

    final Uri callUri = Uri(scheme: 'tel', path: phone);
    try {
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(LocaleKeys.Authentication_cannotMakeCall.tr())),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                LocaleKeys.Authentication_errorMakingCall.tr(args: ['$e']))),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchCurrentLocation();
    _setupTripListeners();
  }

  void _loadUserData() {
    final userJson = SharedPreferencesUtils.getData(key: AppValues.user);
    if (userJson != null && userJson is String && userJson.isNotEmpty) {
      try {
        final userMap = jsonDecode(userJson);
        setState(() {
          _userName = userMap['name'] ?? '';
          _userEmail = userMap['email'] ?? '';
          _image = userMap['image'] ?? '';
        });
      } catch (e) {
        debugPrint('Error decoding user data: $e');
      }
    }
  }

  @override
  void dispose() {
    _fromLocationController.dispose();
    _toLocationController.dispose();
    mapController?.dispose();
    _tripSubscription?.cancel();
    _locationSubscription?.cancel();
    super.dispose();
  }

  void _setupTripListeners() {
    if (widget.tripId == null || widget.tripId!.isEmpty) return;

    _tripSubscription = FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.tripId)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists || !mounted) return;

      final data = snapshot.data();
      final String? status = data?['status'] as String?;

      if (status == 'driver_arrived' && !_shownDriverArrivedSnack) {
        _shownDriverArrivedSnack = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.Authentication_driverArrived.tr())),
        );
      } else if (status == 'completed' && !_shownCompletedDialog) {
        _shownCompletedDialog = true;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(LocaleKeys.Authentication_tripCompleted.tr()),
            content:
            Text(LocaleKeys.Authentication_tripCompletedMessage.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(LocaleKeys.Ok.tr()),
              ),
            ],
          ),
        );
      }
    });

    _locationSubscription = FirebaseFirestore.instance
        .collection('trips_locations')
        .doc(widget.tripId)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists || !mounted) return;

      final data = snapshot.data();
      if (data != null) {
        final double lat = (data['lat'] as num).toDouble();
        final double lng = (data['lng'] as num).toDouble();
        setState(() => driverLocation = LatLng(lat, lng));

        if (mapController != null && widget.pickupLocation == null) {
          mapController!.animateCamera(
            CameraUpdate.newLatLng(LatLng(lat, lng)),
          );
        }
      }
    });
  }

  Future<String> getAddressFromLatLng(LatLng loc) async {
    try {
      final placemarks =
      await placemarkFromCoordinates(loc.latitude, loc.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = [
          if ((place.name ?? '').trim().isNotEmpty) place.name,
          if ((place.street ?? '').trim().isNotEmpty) place.street,
          if ((place.locality ?? '').trim().isNotEmpty) place.locality,
        ].whereType<String>();
        return parts.join(', ').trim().isNotEmpty
            ? parts.join(', ')
            : LocaleKeys.Authentication_unknownLocation.tr();
      }
      return LocaleKeys.Authentication_unknownLocation.tr();
    } catch (_) {
      return LocaleKeys.Authentication_unknownLocation.tr();
    }
  }

  Future<void> _fetchCurrentLocation() async {
    LocationPermission p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) {
      p = await Geolocator.requestPermission();
      if (p == LocationPermission.denied) return;
    }
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    if (mounted) {
      setState(() => currentLocation = LatLng(pos.latitude, pos.longitude));
    }
  }

  Future<void> _chooseOnMap() async {
    if (currentLocation == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChooseLocationScreen(
          initialLocation: currentLocation!,
        ),
      ),
    );

    if (result != null && result is LatLng && mounted) {
      final address = await getAddressFromLatLng(result);

      setState(() {
        if (_currentField == 'from') {
          _fromLocationController.text = address;
          _fromLocation = result;
        } else if (_currentField == 'to') {
          _toLocationController.text = address;
          _toLocation = result;
        }
      });

      /// ✅ تحريك الخريطة
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(result, 16),
      );
    }
  }

  Future<void> _goToMyLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final newLocation = LatLng(position.latitude, position.longitude);

    if (mounted) {
      setState(() => currentLocation = newLocation);
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(newLocation, 16),
      );
    }
  }

  /// ✅ دي اتعدلت
  Future<void> _updateLocationFromAddress(String address, String field) async {
    if (address.trim().isEmpty) return;

    try {
      final locations = await locationFromAddress(address);
      if (locations.isNotEmpty && mounted) {
        final location = locations.first;
        final latLng = LatLng(location.latitude, location.longitude);

        setState(() {
          if (field == 'from') {
            _fromLocation = latLng;
          } else if (field == 'to') {
            _toLocation = latLng;
          }
        });

        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(latLng, 16),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.Error_Not_found.tr())),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.Error_Unexpected_error.tr())),
      );
    }
  }

  void openSearchBottomSheet(
      BuildContext context, {
        required TextEditingController fromController,
        required TextEditingController toController,
        required Future<void> Function(String field) onChooseOnMap,
        LatLng? fromLocation,
        LatLng? toLocation,
      }) {
    final pageController = PageController(initialPage: 0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SearchBottomSheetContent(
        fromController: fromController,
        toController: toController,
        pageController: pageController,
        onChooseOnMap: onChooseOnMap,
        fromLocation: fromLocation,
        toLocation: toLocation,
        getFromLocation: () => _fromLocation,
        getToLocation: () => _toLocation,
        onAddressSubmitted: _updateLocationFromAddress,
      ),
    );
  }

  Widget _buildHomeMap() {
    if (currentLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: currentLocation!,
        zoom: 16,
      ),
      onMapCreated: (controller) => mapController = controller,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      markers: {
        Marker(
          markerId: const MarkerId('me'),
          position: currentLocation!,
          infoWindow: InfoWindow(title: LocaleKeys.Authentication_you.tr()),
        ),
        if (_fromLocation != null)
          Marker(
            markerId: const MarkerId('from'),
            position: _fromLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            infoWindow:
            InfoWindow(title: LocaleKeys.Authentication_from.tr()),
          ),
        if (_toLocation != null)
          Marker(
            markerId: const MarkerId('to'),
            position: _toLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),
            infoWindow:
            InfoWindow(title: LocaleKeys.Authentication_to.tr()),
          ),
      },
    );
  }
  Widget _buildBaseMap() {
    final bool inTrip = widget.tripId != null && widget.tripId!.isNotEmpty;
    if (!inTrip) return _buildHomeMap();

    final bool hasSimulationPoints = widget.driverStart != null &&
        widget.pickupLocation != null &&
        widget.dropoffLocation != null;

    if (hasSimulationPoints) {
      return ClientDriverTrackingMap(
        tripId: widget.tripId!,
        clientLocation: widget.pickupLocation!,
        destination: widget.dropoffLocation!,
      );
    }

    if (driverLocation == null) {
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.pickupLocation ?? const LatLng(0, 0),
          zoom: 14,
        ),
        onMapCreated: (controller) => mapController = controller,
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
      );
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: driverLocation!,
        zoom: 16,
      ),
      onMapCreated: (controller) => mapController = controller,
      markers: {
        Marker(
          markerId: const MarkerId('driver'),
          position: driverLocation!,
          infoWindow:
          InfoWindow(title: LocaleKeys.Authentication_driver.tr()),
        ),
      },
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
    );
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildTripTimer() {
    if (widget.tripId == null || widget.tripId!.isEmpty) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('trips')
          .doc(widget.tripId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!.data()!;
        final startedAtTs = data['startedAt'] as Timestamp?;
        final completedAtTs = data['completedAt'] as Timestamp?;

        if (startedAtTs == null) return const SizedBox.shrink();

        final startedAt = startedAtTs.toDate();
        final completedAt = completedAtTs?.toDate();

        if (completedAt != null) {
          final duration = completedAt.difference(startedAt);
          return _buildTimerBadge(
            LocaleKeys.Authentication_tripDuration
                .tr(args: [_formatDuration(duration)]),
          );
        }

        return LiveTimer(
          startedAt: startedAt,
          formatDuration: _formatDuration,
        );
      },
    );
  }

  Widget _buildTimerBadge(String text) {
    return Positioned(
      top: 120,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.amber,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timer, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripStatusOverlay() {
    if (widget.tripId == null || widget.tripId!.isEmpty) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('trips')
          .doc(widget.tripId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!.data();
        final String? status = data?['status'] as String?;

        if (status == null) return const SizedBox.shrink();

        String message;
        Color color;

        switch (status) {
          case 'driver_arrived':
            message = LocaleKeys.Authentication_driverArrived.tr();
            color = Colors.green;
            break;
          case 'near_dropoff':
            message = LocaleKeys.Authentication_almostThere.tr();
            color = Colors.orange;
            break;
          case 'in_progress':
            message = LocaleKeys.Authentication_tripInProgress.tr();
            color = Colors.blue;
            break;
          case 'completed':
            message = LocaleKeys.Authentication_tripCompleted.tr();
            color = Colors.blueGrey;
            break;
          default:
            return const SizedBox.shrink();
        }

        return Positioned(
          top: 70,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.95),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool inTrip = widget.tripId != null && widget.tripId!.isNotEmpty;

    return Scaffold(
      key: _drawerKey,
      drawer: Drawer(
        child: CustomDrawer(
          userName: _userName,
          email: _userEmail,
          avatarUrl: _image,
        ),
      ),
      body: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            _buildBaseMap(),
            _buildTripStatusOverlay(),
            _buildTripTimer(),

            // Menu button
            Positioned(
              top: 60,
              left: 20,
              child: Material(
                type: MaterialType.transparency,
                child: CircleIconButton(
                  icon: Icons.menu,
                  onTap: () => _drawerKey.currentState?.openDrawer(),
                ),
              ),
            ),

            // Notifications button
            Positioned(
              top: 60,
              right: 20,
              child: Material(
                type: MaterialType.transparency,
                child: CircleIconButton(
                  icon: Icons.notifications_none,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),

            // My location button
            if (driverLocation == null && inTrip)
              const Positioned(
                right: 16,
                bottom: 230,
                child: Material(
                  type: MaterialType.transparency,
                  child: LoadingCircleIconButton(),
                ),
              )
            else
              Positioned(
                right: 16,
                bottom: 230,
                child: Material(
                  type: MaterialType.transparency,
                  child: CircleIconButton(
                    icon: Icons.my_location,
                    onTap: _goToMyLocation,
                  ),
                ),
              ),


            if (inTrip)
              Positioned(
                bottom: 160,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      type: MaterialType.transparency,
                      child: CircleIconButton(
                        icon: Icons.message,
                        onTap: () {
                          if (widget.tripId == null || widget.tripId!.isEmpty) {
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ChatScreen(rideId: widget.tripId!),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 24),
                    // زر الاتصال
                    Material(
                      type: MaterialType.transparency,
                      child: CircleIconButton(
                        icon: Icons.call,
                        onTap: () =>
                            _makePhoneCall(context, widget.driverPhone),
                      ),
                    ),
                  ],
                ),
              ),

            // Search box
            Positioned(
              bottom: 60,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: inTrip
                          ? null
                          : () async {
                        if (_fromLocationController.text.isEmpty &&
                            currentLocation != null) {
                          final initialAddress =
                          await getAddressFromLatLng(
                              currentLocation!);
                          setState(() {
                            _fromLocationController.text = initialAddress;
                            _fromLocation = currentLocation;
                          });
                        }
                        openSearchBottomSheet(
                          context,
                          fromController: _fromLocationController,
                          toController: _toLocationController,
                          onChooseOnMap: (field) async {
                            _currentField = field;
                            await _chooseOnMap();
                          },
                          fromLocation: _fromLocation,
                          toLocation: _toLocation,
                        );
                      },
                      child: AbsorbPointer(
                        child: CommonTextFormField(
                          readOnly: true,
                          prefixIcon: const Icon(Icons.search),
                          textInputAction: TextInputAction.done,
                          maxLines: 1,
                          fillColor:
                          inTrip ? AppColors.grey200 : AppColors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 8,
                          ),
                          hintColor: AppColors.grey500,
                          hint: inTrip
                              ? LocaleKeys.Authentication_tripInProgress.tr()
                              : LocaleKeys.Authentication_whereToGo.tr(),
                          borderRadius: 8,
                          fontSize: AppSizes.BODY_TEXT4_SIZE,
                          borderColor: AppColors.grey300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      onTap: inTrip
                          ? null
                          : () async {
                        if (_fromLocationController.text.isEmpty &&
                            currentLocation != null) {
                          final initialAddress =
                          await getAddressFromLatLng(
                              currentLocation!);
                          setState(() {
                            _fromLocationController.text = initialAddress;
                            _fromLocation = currentLocation;
                          });
                        }
                        openSearchBottomSheet(
                          context,
                          fromController: _fromLocationController,
                          toController: _toLocationController,
                          onChooseOnMap: (field) async {
                            _currentField = field;
                            await _chooseOnMap();
                          },
                          fromLocation: _fromLocation,
                          toLocation: _toLocation,
                        );
                      },
                      text: inTrip
                          ? LocaleKeys.Authentication_tripInProgress.tr()
                          : LocaleKeys.Authentication_search.tr(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
