import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';

class LiveTimer extends StatelessWidget {
  final DateTime startedAt;
  final String Function(Duration) formatDuration;

  const LiveTimer({
    required this.startedAt,
    required this.formatDuration,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream:
      Stream.periodic(const Duration(seconds: 1), (x) => x),
      builder: (context, _) {
        final now = DateTime.now();
        final duration = now.difference(startedAt);
        final text = LocaleKeys.Authentication_tripTime
            .tr(args: [formatDuration(duration)]);

        return Positioned(
          top: 120,
          right: 16,
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.amber,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer,
                    color: Colors.white, size: 16),
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
      },
    );
  }
}