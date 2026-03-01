import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:ultra_client/features/home_screen/presentation/widgets/search_pages/places_service.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/custom_button.dart';
import '../../../../../core/utils/utils/customTextField.dart';
import '../../../../../generated/locale_keys.g.dart';


class SelectAddressPage extends StatefulWidget {
  final ScrollController controller;
  final TextEditingController fromController;
  final TextEditingController toController;
  final PageController pageController;
  final Future<void> Function(String) onChooseOnMap;
  final Future<void> Function(String, String) onAddressSubmitted;

  const SelectAddressPage({
    Key? key,
    required this.controller,
    required this.fromController,
    required this.toController,
    required this.pageController,
    required this.onChooseOnMap,
    required this.onAddressSubmitted,
  }) : super(key: key);

  @override
  State<SelectAddressPage> createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage> {
  final PlacesService _placesService = PlacesService(); 

  List<Prediction> fromPredictions = [];
  List<Prediction> toPredictions = [];

  bool isFromFocused = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.controller,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  LocaleKeys.Authentication_selectAddress.tr(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CommonTextFormField(
                  controller: widget.fromController,
                  hint: LocaleKeys.Authentication_from.tr(),
                  fillColor: AppColors.white,
                  borderColor: AppColors.grey500,
                  focusedBorderColor: AppColors.amber,
                  prefixIcon: Icon(Icons.my_location,
                      size: 18, color: AppColors.amber),
                  onChanged: (value) async {
                    isFromFocused = true;
                    if (value.isNotEmpty) {
                      final result =
                      await _placesService.search(value);
                      setState(() => fromPredictions = result);
                    } else {
                      setState(() => fromPredictions = []);
                    }
                  },
                  onFieldSubmitted: (value) =>
                      widget.onAddressSubmitted(value, 'from'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.map_outlined, color: AppColors.amber),
                onPressed: () async {
                  await widget.onChooseOnMap('from');
                  setState(() {});
                },
              ),
            ],
          ),
          if (fromPredictions.isNotEmpty && isFromFocused)
            _buildPredictionsList(
                fromPredictions, widget.fromController, "from"),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: CommonTextFormField(
                  controller: widget.toController,
                  hint: LocaleKeys.Authentication_to.tr(),
                  fillColor: AppColors.white,
                  borderColor: AppColors.grey500,
                  focusedBorderColor: AppColors.amber,
                  prefixIcon: Icon(Icons.location_on,
                      size: 18, color: AppColors.amber),
                  onChanged: (value) async {
                    isFromFocused = false;
                    if (value.isNotEmpty) {
                      final result =
                      await _placesService.search(value);
                      setState(() => toPredictions = result);
                    } else {
                      setState(() => toPredictions = []);
                    }
                  },
                  onFieldSubmitted: (value) =>
                      widget.onAddressSubmitted(value, 'to'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.map_outlined, color: AppColors.amber),
                onPressed: () async {
                  await widget.onChooseOnMap('to');
                  setState(() {});
                },
              ),
            ],
          ),

          if (toPredictions.isNotEmpty && !isFromFocused)
            _buildPredictionsList(
                toPredictions, widget.toController, "to"),

          const SizedBox(height: 30),

          if (widget.fromController.text.trim().isNotEmpty &&
              widget.toController.text.trim().isNotEmpty)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: CustomButton(
                text: LocaleKeys.Authentication_confirmSelection.tr(),
                onTap: () {
                  widget.pageController.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPredictionsList(
      List<Prediction> list,
      TextEditingController controller,
      String type,
      ) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = list[index];
          return ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(item.description ?? ""),
            onTap: () async {
              await _placesService.getDetails(item.placeId!);

              controller.text = item.description!;

              await widget.onAddressSubmitted(
                item.description!,
                type,
              );

              setState(() {
                fromPredictions.clear();
                toPredictions.clear();
              });
            },
          );
        },
      ),
    );
  }
}
