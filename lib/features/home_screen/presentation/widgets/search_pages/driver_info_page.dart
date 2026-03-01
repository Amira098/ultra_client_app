import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ultra_client/features/home_screen/presentation/widgets/client_driver_tracking_map.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/custom_button.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../chat/presentation/view/chat_screen.dart';
import '../cancel_reason_screen.dart';


class DriverInfoPage extends StatefulWidget {
  final ScrollController controller;

  final String? driverName;
  final String? driverImage;
  final String? carMaker;
  final String? carColor;
  final String? carImage;
  final String? time;
  final double? destination;
  final double? price;
  final String? ratingAverage;
  final String? ratingCount;
  final String? phone;
  final int tripId;
  final LatLng? pickupLocation;
  final LatLng? dropoffLocation;
  const DriverInfoPage({
    Key? key,
    required this.controller,
    this.driverName,
    this.driverImage,
    this.carMaker,
    this.carColor,
    this.carImage,
    this.time,
    this.destination,
    this.price,
    this.ratingAverage,
    this.ratingCount,
    this.phone,
    required this.tripId,
    this.pickupLocation,
    this.dropoffLocation,
  }) : super(key: key);

  @override
  _DriverInfoPageState createState() => _DriverInfoPageState();
}

class _DriverInfoPageState extends State<DriverInfoPage> {
  bool isRideBooked = false;
  bool isCancelled = false;

  @override
  Widget build(BuildContext context) {
    final priceText =
    widget.price != null ? widget.price!.toStringAsFixed(2) : "--";

    return SingleChildScrollView(
      controller: widget.controller,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isRideBooked) const SizedBox(height: 16),

          _buildDriverInfo(),

          const SizedBox(height: 30),

          Text(
            LocaleKeys.Authentication_price.tr(args: [priceText]),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 8),
          Text(
            LocaleKeys.Authentication_estimatedTripTime.tr(),
            style: const TextStyle(fontSize: 16, color: AppColors.black),
          ),

          Text(
            widget.time?.isNotEmpty == true
                ? widget.time!
                : LocaleKeys.Authentication_na.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.grey500,
            ),
          ),

          if (widget.destination != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.location_on, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    "${widget.destination!.toStringAsFixed(1)} km",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 30),

          isRideBooked
              ? Column(
            children: [
              _buildCallMessageButtons(
                tripId: widget.tripId,
              ),
              const SizedBox(height: 16),
              _buildCancelButton(),
            ],
          )
              : _buildBookNowButton(),
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: AppColors.red.withOpacity(0.2),
      ),
      child: isCancelled
          ? Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            LocaleKeys.Authentication_cancelReason.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ),
      )
          : Dismissible(
        key: const Key('cancel_request_button'),
        direction: DismissDirection.startToEnd,
        onDismissed: (_) async {
          setState(() => isCancelled = true);
          await Future.delayed(const Duration(milliseconds: 200));

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CancelReasonScreen(
                tripId: widget.tripId,
              ),
            ),
          );
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.close, color: Colors.red),
        ),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.grey500,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              LocaleKeys.Authentication_swipeToCancel.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDriverInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildDriverAvatar(),
          const SizedBox(width: 12),
          Expanded(child: _buildDriverDetails()),
          const SizedBox(width: 8),
          _buildCarInfo(),
        ],
      ),
    );
  }

  Widget _buildDriverAvatar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        widget.driverImage ?? "",
        width: 55,
        height: 55,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          "assets/images/no_data.png",
          width: 55,
          height: 55,
        ),
      ),
    );
  }

  Widget _buildDriverDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.driverName ?? LocaleKeys.Authentication_driver.tr(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        if ((widget.phone ?? '').isNotEmpty)
          Row(
            children: [
              const SizedBox(width: 4),
              Text(
                widget.phone!,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        Row(
          children: [
            const Icon(Icons.star, size: 14, color: Colors.amber),
            const SizedBox(width: 4),
            Text(
              "${widget.ratingAverage ?? "0.0"} (${widget.ratingCount ?? "0"})",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCarInfo() {
    return Column(
      children: [
        Image.network(
          widget.carImage ?? "",
          width: 70,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Image.asset(
            "assets/images/no_data.png",
            width: 70,
            height: 40,
          ),
        ),
        Text(
          widget.carMaker ?? "--",
          style: const TextStyle(fontSize: 12, color: Colors.orange),
        ),
        Text(
          widget.carColor ?? "",
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildBookNowButton() {
    return CustomButton(
      onTap: () => setState(() => isRideBooked = true),
      text: LocaleKeys.Authentication_bookRide.tr(),
    );
  }

  Widget _buildCallMessageButtons({
    required int tripId,
  }) {
    return Row(
      children: [
        // Call
        Expanded(
          child: CustomButton(
            text: LocaleKeys.Authentication_call.tr(),
            textColor: AppColors.amber,
            btnColor: AppColors.white,
            borderColor: AppColors.amber,
            onTap: () async {
              final phone = widget.phone;

              if (phone != null && phone.isNotEmpty) {
                final Uri callUri = Uri(scheme: 'tel', path: phone);

                if (await canLaunchUrl(callUri)) {
                  await launchUrl(callUri);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                        Text(LocaleKeys.Authentication_cannotMakeCall.tr())),
                  );
                }
              }
            },
          ),
        ),
        const SizedBox(width: 12),

        // Message
        Expanded(
          child: CustomButton(
            text: LocaleKeys.Authentication_message.tr(),
            textColor: Colors.white,
            btnColor: AppColors.amber,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    rideId: widget.tripId.toString(),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),

        // Map (Simulation)
        Expanded(
          child: CustomButton(
            text: LocaleKeys.Authentication_map.tr(),
            textColor: AppColors.amber,
            btnColor: AppColors.white,
            borderColor: AppColors.amber,
            onTap: () {
              if (widget.pickupLocation == null ||
                  widget.dropoffLocation == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        LocaleKeys.Authentication_locationsNotReady.tr()),
                  ),
                );
                return;
              }
              final LatLng driverStart = widget.pickupLocation!;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ClientDriverTrackingMap(
                    tripId: widget.tripId.toString(),
                    clientLocation: widget.pickupLocation!,
                    destination: widget.dropoffLocation!,
                    driverPhone: widget.phone,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
