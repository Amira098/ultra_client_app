
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../generated/locale_keys.g.dart';

class EmptyBox extends StatelessWidget {
  final VoidCallback onRetry;
  const EmptyBox({required this.onRetry});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("LocaleKeys.sanad_NoData.tr()"),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: onRetry,
            child: Text("LocaleKeys.sanad_Reload.tr()"),
          ),
        ],
      ),
    );
  }
}