import 'package:easy_localization/easy_localization.dart';

DateTime? parse(String? iso) {
  if (iso == null || iso.trim().isEmpty) return null;
  try {
    return DateTime.parse(iso).toLocal();
  } catch (_) {
    return null;
  }
}

String formatCurrency(num value) {
  final n = NumberFormat.decimalPattern();
  return '${n.format(value)}';
}