import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/utils/custom_button.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../view_model/avalible_cars/avalible_cars_cubit.dart';
import '../../view_model/avalible_cars/avalible_cars_state.dart';
import '../../view_model/select_car/select_car_cubit.dart';
import '../../view_model/select_car/select_car_state.dart';

class SelectRidePage extends StatefulWidget {
  final ScrollController controller;
  final PageController pageController;
  final int idTrip;
  final String time;
  final double destination;

  /// callback علشان نبعت بيانات العربية والسواق لـ SearchBottomSheetContent
  final void Function(
      int? carId,
      String? driverName,
      String? carMaker,
      String? carColor,
      String? carImage,
      String? ratingAverage,
      String? ratingCount,
      String? phone,
      )? onRideSelected;

  const SelectRidePage({
    Key? key,
    required this.controller,
    required this.pageController,
    required this.idTrip,
    required this.time,
    required this.destination,
    this.onRideSelected,
  }) : super(key: key);

  @override
  _SelectRidePageState createState() => _SelectRidePageState();
}

class _SelectRidePageState extends State<SelectRidePage> {
  int? selectedRideIndex;
  int? selectedCarId;

  final AvalibleCarsCubit avalibleCarsCubit =
  serviceLocator<AvalibleCarsCubit>();
  final SelectCarCubit selectCarCubit = serviceLocator<SelectCarCubit>();

  @override
  void initState() {
    super.initState();
    avalibleCarsCubit.getAvalibleCars();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: avalibleCarsCubit),
        BlocProvider.value(value: selectCarCubit),
      ],
      child: SingleChildScrollView(
        controller: widget.controller,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.Authentication_selectRide.tr(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 20),

            BlocBuilder<AvalibleCarsCubit, AvalibleCarsState>(
              builder: (_, state) {
                if (state is AvalibleCarsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AvalibleCarsError) {
                  return Center(
                    child: Text(state.apiError?.message.toString()??''),
                  );
                }


                if (state is AvalibleCarsSuccess) {
                  final cars = state.data.data;

                  if (cars == null || cars.isEmpty) {
                    return Center(
                        child: Text(
                            LocaleKeys.Authentication_noAvailableCars.tr()));
                  }

                  return SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: cars.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, index) {
                        final car = cars[index];
                        final isSelected = selectedRideIndex == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedRideIndex = index;
                              selectedCarId = car.id;
                            });

                            widget.onRideSelected?.call(
                              car.id,
                              car.driver?.name,
                              car.carMaker,
                              car.color,
                              car.image,
                              car.driverRatingAverage?.toString(),
                              car.driverRatingCount?.toString(),
                              car.driver?.phone,
                            );
                          },
                          child: Container(
                            width: 140,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.amber.withOpacity(0.1)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.amber
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: (car.image != null &&
                                      car.image!.startsWith("http"))
                                      ? Image.network(
                                    car.image!,
                                    fit: BoxFit.contain,
                                  )
                                      : Image.asset(
                                    "assets/images/car.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  car.carMaker ?? "",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  car.color ?? "",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  car.driver?.name ?? '',
                                  style: const TextStyle(fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                return Center(
                    child: Text(LocaleKeys.Authentication_noData.tr()));
              },
            ),

            const SizedBox(height: 30),

            Text(
              LocaleKeys.Authentication_estimatedTripTime.tr(),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.time.isEmpty
                      ? LocaleKeys.Authentication_na.tr()
                      : "${widget.time} ",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${widget.destination} km",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            BlocConsumer<SelectCarCubit, SelectCarState>(
              listener: (context, state) {
                if (state is SelectCarSuccess) {
                  widget.pageController.animateToPage(
                    3, // انتقل إلى صفحة الانتظار
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                  );
                }
              },
              builder: (context, state) {
                return CustomButton(
                  text: state is SelectCarLoading
                      ? LocaleKeys.Loading.tr()
                      : LocaleKeys.Authentication_bookRide.tr(),
                  onTap: selectedCarId == null
                      ? null
                      : () {
                    // هنا selectCarCubit مستني int عادي فبنستخدم !
                    selectCarCubit.selectCar(
                      tripId: widget.idTrip,
                      carId: selectedCarId!, // ✅ int (مش nullable)
                    );
                  },
                  isEnabled: selectedCarId != null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
