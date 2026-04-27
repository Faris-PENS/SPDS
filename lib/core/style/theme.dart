import 'package:flutter/material.dart';
import 'package:spds/core/gen/fonts.gen.dart';
import 'package:spds/core/style/colors.dart';
// import 'package:kp_spds/presentation/common/custom_slider_shape.dart';
// import 'package:kp_spds/core/common/custom_slider_shape.dart';
// import 'package:kp_spds/presentation/common/custom_track_shape.dart';

class AppThemeData {
  AppThemeData._();

  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.blue,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF141414),
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0.0,
      centerTitle: false,
      titleSpacing: 0,
      backgroundColor: Color(0xFF141414),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.24,
      ),
      shape: Border(
        bottom: BorderSide(
          color: AppColors.grey500,
          width: 0.5,
        ),
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.blue,
      secondary: AppColors.green400,
      surface: Color(0xFF121212),
      onSurface: Colors.white,
      onSurfaceVariant: AppColors.grey200,
      surfaceContainerLowest: AppColors.grey900,
      surfaceContainerLow: Color(0xFF202020),
      surfaceContainer: Color(0xFF2E2E2E),
      surfaceContainerHigh: AppColors.grey600,
      surfaceContainerHighest: AppColors.grey500,
      error: AppColors.error500,
      outline: AppColors.grey300,
      tertiary: AppColors.grey400,
      onTertiary: Colors.white,
    ),
    dividerColor: AppColors.grey500,
    disabledColor: AppColors.grey200,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.black,
        textStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        fixedSize: const Size(double.infinity, 48),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          color: Colors.white,
          width: 1,
          style: BorderStyle.solid,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        fixedSize: const Size(double.infinity, 48),
      ),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w400,
        color: Colors.white,
        letterSpacing: 0.36,
      ),
      titleLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 20,
        letterSpacing: 0.35,
      ),
      titleMedium: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        letterSpacing: -0.24,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.white,
        letterSpacing: -0.24,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        color: AppColors.grey200,
        letterSpacing: -0.24,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        color: AppColors.grey200,
        letterSpacing: -0.24,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        color: Colors.white,
        letterSpacing: -0.08,
      ),
    ),
    fontFamily: FontFamily.sFProDisplay,
    cardTheme: const CardThemeData(
      color: Color(0xFF202020),
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.grey800,
      surfaceTintColor: AppColors.grey800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    // sliderTheme: const SliderThemeData(
    //   trackShape: CustomSliderTrackShape(),
    //   thumbShape: CustomSliderThumbShape(enabledThumbRadius: 13),
    //   overlayShape: CustomSliderOverlayShape(),
    //   trackHeight: 8,
    //   thumbColor: Colors.white,
    // ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.grey700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 6,
      closeIconColor: Colors.white,
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
    ),
    tabBarTheme: const TabBarThemeData(
      labelStyle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Color(0xFF4A4A4A),
      unselectedLabelStyle: TextStyle(
        fontSize: 17,
        color: AppColors.grey300,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color(0xFF2E2E2E),
      filled: true,
      enabledBorder: _getInputBorder(),
      focusedBorder: _getInputBorder(),
      disabledBorder: _getInputBorder(),
      errorBorder: _getInputBorder(color: AppColors.error500),
      focusedErrorBorder: _getInputBorder(color: AppColors.error500),
      hintStyle: const TextStyle(
        color: AppColors.grey200,
        letterSpacing: -0.32,
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: const Color(0xFF2E2E2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      position: PopupMenuPosition.under,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(13),
        ),
      ),
      backgroundColor: AppColors.grey800,
      dragHandleColor: AppColors.grey300,
      dragHandleSize: Size(40, 4),
    ),
  );

  static OutlineInputBorder _getInputBorder({
    Color color = Colors.transparent,
  }) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: color,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(6),
      ),
    );
  }
}
