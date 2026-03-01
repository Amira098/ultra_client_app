import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_client/core/di/service_locator.dart';
import 'package:ultra_client/core/constants/app_colors.dart';
import 'package:ultra_client/core/utils/custom_text.dart';
import 'package:ultra_client/core/utils/utils/custom_icon_button.dart';
import 'package:ultra_client/features/drawer_screen/presentation/view_model/history/history_cubit.dart';
import 'package:ultra_client/generated/locale_keys.g.dart';
import '../view_model/history/history_state.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool showCompleted = true;
  final HistoryCubit historyCubit = serviceLocator<HistoryCubit>();

  @override
  void initState() {
    super.initState();
    historyCubit.history(status: 'completed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: CustomText(
          LocaleKeys.Authentication_history.tr(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: CustomIconButton(
            btnColor: Colors.transparent,
            onTap: () => Navigator.pop(context),
            icon: Icons.arrow_back_ios,
            iconColor: Colors.black,
          ),
        ),
      ),
      body: BlocProvider(
        create: (_) => historyCubit,
        child: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.amber),
              );
            } else if (state is HistorySuccess) {
              final trips = state.historyData.data ?? [];

              return Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _buildToggleTabs(),
                    const SizedBox(height: 16),
                    Expanded(
                      child: trips.isEmpty
                          ? Center(
                              child: CustomText(
                                  LocaleKeys.Authentication_noTripsFound.tr()))
                          : ListView.builder(
                        itemCount: trips.length,
                        itemBuilder: (context, index) {
                          final trip = trips[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.primary),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Left side: Start & End Address
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 28),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          trip.startAddress ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        CustomText(
                                          trip.endAddress ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.grey600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),
                                CustomText(
                                  showCompleted
                                      ? LocaleKeys.Authentication_done.tr()
                                      : LocaleKeys.Authentication_canceled.tr(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: showCompleted
                                        ? AppColors.amber
                                        : AppColors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is HistoryError) {
              return Center(child: CustomText(state.message));
            }
            return Center(
                child: CustomText(LocaleKeys.Error_somethingWentWrong.tr()));
          },
        ),
      ),
    );
  }

  Widget _buildToggleTabs() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.amber.withOpacity(0.1),
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _buildToggleButton(LocaleKeys.Authentication_completed.tr(), true),
          _buildToggleButton(LocaleKeys.Authentication_canceled.tr(), false),
        ],
      ),
    );
  }

  Expanded _buildToggleButton(String label, bool isCompleted) {
    final isActive = showCompleted == isCompleted;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => showCompleted = isCompleted);
          historyCubit.history(status: isCompleted ? 'completed' : 'canceled');
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? AppColors.amber : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: CustomText(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
