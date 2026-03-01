import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_client/core/di/service_locator.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/show_pretty_snack.dart';
import '../../../../generated/locale_keys.g.dart';
import '../view_model/cancell_trip/cancell_trip_cubit.dart';
import '../view_model/cancell_trip/cancell_trip_state.dart';
import '../view_model/cancelling_reasons/cancelling_reasons_cubit.dart';
import '../view_model/cancelling_reasons/cancelling_reasons_state.dart';
class CancelReasonScreen extends StatefulWidget {
  final int tripId; // ✅ اتضاف هنا

  CancelReasonScreen({required this.tripId});

  @override
  _CancelReasonScreenState createState() => _CancelReasonScreenState();
}

class _CancelReasonScreenState extends State<CancelReasonScreen> {
  String? selectedReason;

  final CancellingReasonsCubit cancellingReasonsCubit =
  serviceLocator<CancellingReasonsCubit>();

  final CancellTripCubit cancellTripCubit =
  serviceLocator<CancellTripCubit>();

  @override
  void initState() {
    super.initState();
    cancellingReasonsCubit.getCancellingReasons();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Colors.orange),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: cancellingReasonsCubit),
            BlocProvider.value(value: cancellTripCubit),
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  LocaleKeys.Authentication_cancellationReason.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 24),

                Expanded(
                  child: BlocBuilder<CancellingReasonsCubit, CancellingReasonsState>(
                    builder: (context, state) {
                      if (state is CancellingReasonsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is CancellingReasonsError) {
                        return Center(child: Text(state.message));
                      }
                      if (state is CancellingReasonsSuccess) {
                        final reasons = state.cancellingReasons.data ?? [];

                        return ListView.builder(
                          itemCount: reasons.length,
                          itemBuilder: (context, index) {
                            final reason = reasons[index];
                            return Column(
                              children: [
                                RadioListTile<String>(
                                  value: reason.id.toString(),
                                  groupValue: selectedReason,
                                  onChanged: (value) {
                                    setState(() => selectedReason = value);
                                  },
                                  activeColor: Colors.orange,
                                  title: Text(
                                    reason.reason?.ar ??
                                        reason.reason?.en ??
                                        "",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity: ListTileControlAffinity.leading,
                                ),
                                const Divider(thickness: .5),
                              ],
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),

                BlocConsumer<CancellTripCubit, CancellTripState>(
                  listener: (context, state) {
                    if (state is CancellTripLoading) {
                      showPrettySnack(
                        context,
                        LocaleKeys.Loading.tr(),
                        success: false,
                      );
                    }
                    if (state is CancellTripError) {
                      showPrettySnack(
                        context,
                        state.apiError.message?.toString() ??
                            LocaleKeys.Error_somethingWentWrong.tr(),
                        success: false,
                      );
                    }
                    if (state is CancellTripSuccess) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      showPrettySnack(
                        context,
                        state.cancelTrip.message?.en?.toString() ??
                            state.cancelTrip.message?.ar?.toString() ??
                            state.cancelTrip.message?.it?.toString() ??
                            '',
                      );
                    }

                    if (state is CancellTripError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.apiError.message as String)),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is CancellTripLoading;

                    return CustomButton(
                      isEnabled: selectedReason != null && !isLoading,
                      onTap: isLoading
                          ? null
                          : () {
                                cancellTripCubit.cancellTrip(
                                  tripId: widget.tripId,
                                  cancellingReasonId:
                                      int.parse(selectedReason!),
                                );
                              },
                        text: isLoading
                            ? LocaleKeys.Authentication_processing.tr()
                            : LocaleKeys.Authentication_submit.tr(),
                    );
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
