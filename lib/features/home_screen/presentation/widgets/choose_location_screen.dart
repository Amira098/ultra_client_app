import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../generated/locale_keys.g.dart';

class ChooseLocationScreen extends StatefulWidget {
  final LatLng initialLocation;

  const ChooseLocationScreen({super.key, required this.initialLocation});

  @override
  State<ChooseLocationScreen> createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String _address = '';
  bool isLoadingAddress = false;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    // نحدد إن فيه لودينج قبل أول طلب
    isLoadingAddress = true;
    _getAddressFromLatLng(_selectedLocation!);
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      final placemarks =
      await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

      // بعد الـ await لازم نتأكد إن الـ widget لسه موجودة
      if (!mounted) return;

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _address =
          "${place.name ?? ''}, ${place.street ?? ''}, ${place.locality ?? ''}";
          isLoadingAddress = false;
        });
      } else {
        setState(() {
          _address = LocaleKeys.Authentication_unknownLocation.tr();
          isLoadingAddress = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _address = LocaleKeys.Authentication_unknownLocation.tr();
        isLoadingAddress = false;
      });
    }
  }

  void goToMyLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final LatLng newLoc = LatLng(position.latitude, position.longitude);

      // ممكن الجهاز يكون رجع من الشاشة، نتأكد برضه
      if (!mounted) return;

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(newLoc),
      );
      _selectedLocation = newLoc;
      isLoadingAddress = true;
      _getAddressFromLatLng(newLoc);
    } catch (e) {
      // تقدرِ تضيفي Toast أو SnackBar هنا لو حبيتي
      // debugPrint("goToMyLocation error: $e");
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
            CameraPosition(target: widget.initialLocation, zoom: 16),
            onMapCreated: (controller) => _mapController = controller,
            onCameraMove: (position) {
              if (!mounted) return;
              _selectedLocation = position.target;
              setState(() {
                isLoadingAddress = true;
              });
            },
            onCameraIdle: () {
              if (!mounted) return;
              if (_selectedLocation != null) {
                _getAddressFromLatLng(_selectedLocation!);
              }
            },
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            mapType: MapType.normal,
          ),

          // Back button
          Positioned(
            top: 50,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.7),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // العنوان + أيقونة اللوكيشن في النص
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 160,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomText(
                    isLoadingAddress ? LocaleKeys.Loading.tr() : _address,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 13,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Icon(
                  Icons.location_on,
                  size: 40,
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ),

          // زر الذهاب لموقعي الحالي
          Positioned(
            right: 16,
            bottom: 120,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.7),
              child: IconButton(
                icon: const Icon(Icons.my_location, color: Colors.white),
                onPressed: goToMyLocation,
              ),
            ),
          ),

          // زر Done
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomButton(
                onTap: () {
                  Navigator.pop(context, _selectedLocation);
                },
                text: LocaleKeys.Authentication_done.tr(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
