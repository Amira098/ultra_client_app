import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ultra_client/features/home_screen/presentation/widgets/search_pages/confirm_address_page.dart';
import 'package:ultra_client/features/home_screen/presentation/widgets/search_pages/driver_info_page.dart';
import 'package:ultra_client/features/home_screen/presentation/widgets/search_pages/select_address_page.dart';
import 'package:ultra_client/features/home_screen/presentation/widgets/search_pages/select_ride_page.dart';
import 'package:ultra_client/features/home_screen/presentation/widgets/search_pages/waiting_for_driver_page.dart';

class SearchBottomSheetContent extends StatefulWidget {
  final TextEditingController fromController;
  final TextEditingController toController;
  final PageController pageController;
  final Future<void> Function(String) onChooseOnMap;
  final LatLng? fromLocation;
  final LatLng? toLocation;
  final LatLng? Function() getFromLocation;
  final LatLng? Function() getToLocation;
  final Future<void> Function(String, String) onAddressSubmitted;

  const SearchBottomSheetContent({
    super.key,
    required this.fromController,
    required this.toController,
    required this.pageController,
    required this.onChooseOnMap,
    this.fromLocation,
    this.toLocation,
    required this.getFromLocation,
    required this.getToLocation,
    required this.onAddressSubmitted,
  });

  @override
  State<SearchBottomSheetContent> createState() =>
      _SearchBottomSheetContentState();
}

class _SearchBottomSheetContentState extends State<SearchBottomSheetContent> {
  int currentPage = 0;

  int? _tripId;
  String? _time;
  double? _destination;
  double? _price;

  int? _selectedCarId;
  String? _selectedDriverName;
  String? _selectedCarMaker;
  String? _selectedCarColor;
  String? _selectedCarImage;
  String? _selectedRatingAverage;
  String? _selectedRatingCount;
  String? _selectedPhone;

  bool _waitingLocked = false; // ✅ مهم جدًا

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(() {
      final newPage = widget.pageController.page?.round() ?? 0;
      if (newPage != currentPage) {
        setState(() {
          currentPage = newPage;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double maxSize;

    switch (currentPage) {
      case 0:
        maxSize = 0.40;
        break;
      case 1:
        maxSize = 0.40;
        break;
      case 2:
        maxSize = 0.55;
        break;
      case 3:
        maxSize = 0.45;
        break;
      case 4:
        maxSize = 0.55;
        break;
      default:
        maxSize = 0.85;
    }

    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: maxSize,
        minChildSize: maxSize,
        maxChildSize: maxSize,
        expand: false,
        builder: (_, scrollController) {
          return NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              if (notification.extent != maxSize) {
                scrollController.jumpTo(0);
              }
              return true;
            },
            child: PageView(
              controller: widget.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SelectAddressPage(
                  controller: scrollController,
                  fromController: widget.fromController,
                  toController: widget.toController,
                  pageController: widget.pageController,
                  onChooseOnMap: widget.onChooseOnMap,
                  onAddressSubmitted: widget.onAddressSubmitted,
                ),

                ConfirmAddressPage(
                  controller: scrollController,
                  fromController: widget.fromController,
                  toController: widget.toController,
                  pageController: widget.pageController,
                  getFromLocation: widget.getFromLocation,
                  getToLocation: widget.getToLocation,
                  onConfirmSuccess: (idTrip, time, destination, price) {
                    setState(() {
                      _tripId = idTrip;
                      _time = time;
                      _destination = destination;
                      _price = price;
                    });
                  },
                ),

                SelectRidePage(
                  controller: scrollController,
                  pageController: widget.pageController,
                  idTrip: _tripId ?? 0,
                  time: _time ?? '',
                  destination: _destination ?? 0.0,
                  onRideSelected: (
                      carId,
                      driverName,
                      carMaker,
                      carColor,
                      carImage,
                      ratingAverage,
                      ratingCount,
                      phone,
                      ) {
                    setState(() {
                      _selectedCarId = carId;
                      _selectedDriverName = driverName;
                      _selectedCarMaker = carMaker;
                      _selectedCarColor = carColor;
                      _selectedCarImage = carImage;
                      _selectedRatingAverage = ratingAverage;
                      _selectedRatingCount = ratingCount;
                      _selectedPhone = phone;
                    });
                  },
                ),

                // ✅ صفحة الانتظار بعد التثبيت
                _tripId == null
                    ? const Center(child: CircularProgressIndicator())
                    : WaitingForDriverPage(
                  key: const PageStorageKey('waiting_page'),
                  controller: scrollController,
                  tripId: _tripId!,
                  onDriverAccepted: () {
                    if (_waitingLocked) return;
                    _waitingLocked = true;

                    debugPrint("🚖 MOVING TO DRIVER INFO PAGE");

                    widget.pageController.animateToPage(
                      4,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                    );
                  },
                ),

                DriverInfoPage(
                  controller: scrollController,
                  driverName: _selectedDriverName,
                  carMaker: _selectedCarMaker,
                  carColor: _selectedCarColor,
                  carImage: _selectedCarImage,
                  time: _time,
                  destination: _destination,
                  price: _price,
                  ratingAverage: _selectedRatingAverage,
                  ratingCount: _selectedRatingCount,
                  phone: _selectedPhone,
                  tripId: _tripId ?? 0,
                  pickupLocation: widget.getFromLocation(),
                  dropoffLocation: widget.getToLocation(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
