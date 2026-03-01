import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_fonts_family.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        splashColor: AppColors.amber[10],
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.amber[50]),
    scaffoldBackgroundColor: AppColors.white,
    primaryColor: AppColors.amber[50],
    secondaryHeaderColor: AppColors.black,
    fontFamily: AppFontsFamily.inter,
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: AppColors.white,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
          color: AppColors.primary ,fontWeight: FontWeight.w700, fontSize: 32,),
      titleMedium: TextStyle(
          color: AppColors.primary, fontWeight: FontWeight.w500, fontSize: 20),
      titleSmall: TextStyle(
          color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 20),
      labelLarge: TextStyle(
          color: AppColors.primary, fontWeight: FontWeight.w500, fontSize: 24),
      labelMedium: TextStyle(
          color: AppColors.amber, fontWeight: FontWeight.w500, fontSize: 12),
      labelSmall: TextStyle(
          color: AppColors.black, fontWeight: FontWeight.w700, fontSize: 12),
      bodyLarge: TextStyle(
          color: AppColors.darkRed, fontWeight: FontWeight.w500, fontSize: 18),
      bodyMedium: TextStyle(
          color: AppColors.amber ,fontWeight: FontWeight.w700, fontSize: 25),
      bodySmall: TextStyle(
          color: AppColors.gray, fontWeight: FontWeight.w400, fontSize: 14),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.amber[50],
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.all(AppColors.amber[50]),
        foregroundColor: WidgetStateProperty.all(AppColors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10000),
          ),
        ),
        elevation: WidgetStateProperty.all(0),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.white,
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.all(14),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: const TextStyle(color: AppColors.red, fontSize: 12),
      contentPadding: const EdgeInsets.all(16),
      iconColor: AppColors.amber,
      hintStyle: TextStyle(
        color: AppColors.black,
        fontSize: 14,
      ),
      prefixIconColor: AppColors.black,
      suffixIconColor: AppColors.black,
      labelStyle: TextStyle(
        fontSize: 12,
        color: AppColors.black,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(
          width: 1,
          color: AppColors.black,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(
          width: 1,
          color: AppColors.black,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(
          width: 1,
          color: AppColors.black,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(
          width: 1,
          color: AppColors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(
          width: 1,
          color: AppColors.red,
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.black,
      surfaceTintColor: AppColors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        foregroundColor:
            WidgetStateProperty.all(AppColors.amber[50]),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: AppColors.white,
          ),
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
                color: AppColors.amber[50],
                fontWeight: FontWeight.w600);
          }
          return TextStyle(
              color: AppColors.black, fontWeight: FontWeight.w500);
        },
      ),
      elevation: 0,
      backgroundColor: AppColors.amber [10],
      surfaceTintColor: AppColors.amber,
      iconTheme: WidgetStateProperty.all(
        const IconThemeData(color: AppColors.amber),
      ),
      indicatorColor: AppColors.amber[10],
    ),
    radioTheme: RadioThemeData(
        fillColor:
            WidgetStatePropertyAll((AppColors.amber[30])),
        overlayColor:
            WidgetStatePropertyAll(AppColors.amber[30])),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0,
      selectedItemColor: AppColors.amber[30],
      showSelectedLabels: true,
      showUnselectedLabels: true,
      unselectedItemColor: AppColors.gray,
      selectedLabelStyle: TextStyle(
        fontSize: 14,
        color: AppColors.amber[30],
        fontWeight: FontWeight.bold,
        fontFamily: AppFontsFamily.inter,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 14,
        color: AppColors.gray,
        fontFamily: AppFontsFamily.inter,
      ),
    ),
    tabBarTheme: TabBarThemeData(
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: AppColors.amber[30],
      unselectedLabelColor: AppColors.white,
      dividerColor: Colors.transparent,
      labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      unselectedLabelStyle:
          TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
      indicator: UnderlineTabIndicator(
        insets: EdgeInsets.zero,
        borderSide:
            BorderSide(width: 3, color: AppColors.amber[10]!),
      ),
      labelPadding: const EdgeInsets.only(right: 24),
      tabAlignment: TabAlignment.start,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      backgroundColor: AppColors.white,
      dragHandleSize: Size(80, 4),
      dragHandleColor: AppColors.black,
      showDragHandle: true,
      elevation: 0,
    ),
  );
}

// isScrollable: true,
//
//       unselectedLabelStyle: Theme.of(context).textTheme.titleSmall!,
//       dividerColor: Colors.transparent,
