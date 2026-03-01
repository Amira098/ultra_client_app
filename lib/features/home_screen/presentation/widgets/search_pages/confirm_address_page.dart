import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_maps_webservices/directions.dart';
import 'package:ultra_client/core/di/service_locator.dart';

import '../../../../../core/constants/app_values.dart';
import '../../../../../core/utils/custom_button.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../view_model/confirm_locations/confirm_locations_cubit.dart';
import '../../view_model/confirm_locations/confirm_locations_state.dart';

class ConfirmAddressPage extends StatefulWidget {
  final ScrollController controller;
  final TextEditingController fromController;
  final TextEditingController toController;
  final PageController pageController;

  final LatLng? Function() getFromLocation;
  final LatLng? Function() getToLocation;

  final void Function(
      int idTrip,
      String time,
      double destination,
      double price,
      ) onConfirmSuccess;

  const ConfirmAddressPage({
    Key? key,
    required this.controller,
    required this.fromController,
    required this.toController,
    required this.pageController,
    required this.getFromLocation,
    required this.getToLocation,
    required this.onConfirmSuccess,
  }) : super(key: key);

  @override
  State<ConfirmAddressPage> createState() => _ConfirmAddressPageState();
}

final ConfirmLocationsCubit confirmLocationsCubit =
serviceLocator<ConfirmLocationsCubit>();

class _ConfirmAddressPageState extends State<ConfirmAddressPage> {
  bool _loading = false;

  double? _googleDistance;
  String? _googleDuration;

  final GoogleMapsDirections _directions = GoogleMapsDirections(
    apiKey: AppValues.googleMapsApiKey,
  );

  Future<void> _confirmLocations() async {
    final fromLocation = widget.getFromLocation();
    final toLocation = widget.getToLocation();

    if (fromLocation == null || toLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            LocaleKeys.Authentication_selectBothLocations.tr(),
          ),
        ),
      );
      return;
    }

    try {
      setState(() => _loading = true);

      // =======================
      // 1️⃣ Google Directions
      // =======================
      final result = await _directions.directionsWithLocation(
        Location(lat: fromLocation.latitude, lng: fromLocation.longitude),
        Location(lat: toLocation.latitude, lng: toLocation.longitude),
        travelMode: TravelMode.driving,
      );

      if (!result.isOkay || result.routes.isEmpty) {
        throw Exception(result.errorMessage ?? "Directions API error");
      }

      final leg = result.routes.first.legs.first;

      _googleDistance = leg.distance!.value.toDouble() / 1000;
      _googleDuration = leg.duration!.text;

      // =======================
      // 2️⃣ Create Trip (Cubit)
      // =======================
      confirmLocationsCubit.confirmLocations(
        fromLatitude: fromLocation.latitude,
        fromLongitude: fromLocation.longitude,
        toLatitude: toLocation.latitude,
        toLongitude: toLocation.longitude,
        fromAddress: widget.fromController.text,
        toAddress: widget.toController.text,
        isSpecial: 0,
      );
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.controller,
      padding: const EdgeInsets.all(16),
      child: BlocProvider.value(
        value: confirmLocationsCubit,
        child: BlocConsumer<ConfirmLocationsCubit, ConfirmLocationsState>(
          listener: (context, state) {
            if (state is ConfirmLocationsSuccess) {
              final tripId = state.data.tripId;
              final price = state.data.price;

              if (tripId != null && price != null) {
                widget.onConfirmSuccess(
                  tripId,
                  _googleDuration ?? state.data.durationHhmm ?? '',
                  _googleDistance ?? state.data.distanceKm ?? 0,
                  price,
                );

                widget.pageController.animateToPage(
                  2,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      LocaleKeys.Authentication_invalidTripData.tr(),
                    ),
                  ),
                );
              }

              setState(() => _loading = false);
            } else if (state is ConfirmLocationsError) {
              setState(() => _loading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is ConfirmLocationsLoading) {
              setState(() => _loading = true);
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.Authentication_confirmAddress.tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

                _buildLocationRow(
                  Icons.location_on,
                  Colors.red,
                  LocaleKeys.Authentication_fromLocation.tr(),
                  widget.fromController.text.isEmpty
                      ? LocaleKeys.Authentication_notSelected.tr()
                      : widget.fromController.text,
                ),

                const SizedBox(height: 20),

                _buildLocationRow(
                  Icons.location_on,
                  Colors.green,
                  LocaleKeys.Authentication_toLocation.tr(),
                  widget.toController.text.isEmpty
                      ? LocaleKeys.Authentication_notSelected.tr()
                      : widget.toController.text,
                ),

                const SizedBox(height: 30),

                CustomButton(
                  text: _loading
                      ? LocaleKeys.Loading.tr()
                      : LocaleKeys.Authentication_confirmLocation.tr(),
                  onTap: _loading ? null : _confirmLocations,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLocationRow(
      IconData icon,
      Color color,
      String title,
      String subtitle,
      ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
