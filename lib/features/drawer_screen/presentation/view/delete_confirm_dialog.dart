import 'dart:async';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../auth1/presentation/view/splash_screen.dart';
import '../view_model/delete/delete_account_cubit.dart';
import '../view_model/delete/delete_account_state.dart';


class DeleteConfirmDialog extends StatefulWidget {
  const DeleteConfirmDialog({super.key});

  @override
  State<DeleteConfirmDialog> createState() => _DeleteConfirmDialogState();
}

class _DeleteConfirmDialogState extends State<DeleteConfirmDialog> {
  final DeleteCubit _cubit = serviceLocator<DeleteCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: BlocConsumer<DeleteCubit, DeleteState>(
        listener: (context, state) async {
          if (state is DeleteSuccess) {
            if (mounted) Navigator.of(context).pop(); // close confirm dialog
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) =>  SplashScreen()),
                  (route) => false,
            );
          } else if (state is DeleteError) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.apiError!.message.toString()),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          }
        },
        builder: (context, state) {
          final isLoading = state is DeleteLoading;

          return Stack(
            children: [

              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),


              Center(
                child: Dialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          LocaleKeys.Authentication_deleteConfirm.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 22),
                        if (isLoading)
                          const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(),
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<DeleteCubit>().deleteAccount();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.amber,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    LocaleKeys.Authentication_delete.tr(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: AppColors.amber),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    LocaleKeys.ultra_Cancel.tr(),
                                    style: TextStyle(
                                        color: AppColors.amber, fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );

        },
      ),
    );
  }
}

class DeleteSuccessDialog extends StatefulWidget {
  const DeleteSuccessDialog({super.key});

  @override
  State<DeleteSuccessDialog> createState() => _DeleteSuccessDialogState();
}

class _DeleteSuccessDialogState extends State<DeleteSuccessDialog>
    with SingleTickerProviderStateMixin {
  double _scale = 0.0;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 200), () {
      setState(() {
        _scale = 1.0;
        _opacity = 1.0;
      });
    });

    // ✅ Auto close after 2 seconds
    Timer(const Duration(seconds: 2), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: _scale,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              child: CircleAvatar(
                radius: 32,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOut,
              child: Text(
              LocaleKeys.Authentication_deleteSuccess.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
