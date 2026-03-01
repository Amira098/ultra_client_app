import 'package:flutter/material.dart';

/// Centralized color palette for the entire app.
/// Organized and structured for scalability and easy theme management.
abstract class AppColors {
  // ------------------ 🌈 Base Constants ------------------
  static const int base = 1000;
  static const int c10 = 10;
  static const int c20 = 20;
  static const int c30 = 30;
  static const int c40 = 40;
  static const int c50 = 50;
  static const int c60 = 60;
  static const int c70 = 70;
  static const int c80 = 80;
  static const int c90 = 90;
  static const int c100 = 100;

  // ------------------ ⚪️ Neutrals ------------------
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Colors.transparent;
  static const Color black = Color(0xFF000000);
  static const Color gray = Color(0xFF5D5D5D);
  static const Color lightGray = Color(0xFFEAEAEA);
  static const Color darkGray = Color(0xFF5A5A5A);
  static const Color grey900 = Color(0xFF212121);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey50  = Color(0xFFFAFAFA);

  // ------------------ 🔵 Cool Colors ------------------
  static const Color lightBlue = Color(0xFFEDEFF3);
  static const Color paleBlue = Color(0xFFDFE7F7);

  // ------------------ 🟢 Greens ------------------
  static const Color green = Color(0xFF00A550);
  static const Color lightGreen = Color(0xFFCAF9CC);

  // ------------------ 🔴 Reds ------------------
  static const Color red = Color(0xFFD50000);
  static const Color darkRed = Color(0xFFD32F2F);
  static const Color lightRed = Color(0xFFF8D2D2);


  static const Color Yellow = Color(0xFFFFD700);
  static const Color blue = Color(0xFF5694F2);


  static const MaterialColor primary = MaterialColor(0xFF00798C, {
    base: Color(0xFF00798C),
    10: Color(0xFF198A9B),
    20: Color(0xFF339CAD),
    30: Color(0xFF4CAEBE),
    40: Color(0xFF66C0D0),
    50: Color(0xFF80D2E1),
    60: Color(0xFF66A1AD),
    70: Color(0xFF4D7F8C),
    80: Color(0xFF335C66),
    90: Color(0xFF1A3A40),
    100: Color(0xFF0D1E22),
  });

  static const MaterialColor amber = MaterialColor(0xFFEDAD49, {
    base: Color(0xFFEDAD49),
    10: Color(0xFFF1BB62),
    20: Color(0xFFF5C97B),
    30: Color(0xFFF9D794),
    40: Color(0xFFFDE5AD),
    50: Color(0xFFFFF3C6),
    60: Color(0xFFD1943E),
    70: Color(0xFFA37233),
    80: Color(0xFF755128),
    90: Color(0xFF473F1D),
    100: Color(0xFF2A2711),
  });

  static const MaterialColor peach = MaterialColor(0xFFFFDBA4, {
    base: Color(0xFFFFDBA4),
    10: Color(0xFFFFE0B2),
    20: Color(0xFFFFE5C1),
    30: Color(0xFFFFEAD0),
    40: Color(0xFFFFEEDF),
    50: Color(0xFFFFF3EE),
    60: Color(0xFFE0C28E),
    70: Color(0xFFB2946E),
    80: Color(0xFF84664E),
    90: Color(0xFF56482E),
    100: Color(0xFF2D2616),
  });


}
