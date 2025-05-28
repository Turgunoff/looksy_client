import 'package:flutter/material.dart';

class AppTheme {
  // Asosiy rang - Green (#18a137)
  static const Color primaryColor = Color(0xFF18a137);
  static const Color primaryLightColor = Color(
    0xFF4CAF50,
  ); // Green rangining ochroq varianti
  static const Color primaryDarkColor = Color(
    0xFF0D5C1A,
  ); // Green rangining to'qroq varianti

  // Qo'shimcha ranglar
  static const Color lightNavyBlue = Color(0xFFE8F5E9); // Juda och yashil

  // Zamonaviy UI uchun qo'shimcha ranglar
  static const Color surfaceColor = Color(
    0xFFF5F5F5,
  ); // Light theme uchun surface rang
  static const Color onSurfaceColor = Color(
    0xFF424242,
  ); // Light theme uchun text/icon rang

  // Dark theme uchun ranglar
  static const Color darkSurfaceColor = Color(
    0xFF0A0A29,
  ); // Dark theme uchun surface rang (to'q navy blue)
  static const Color darkBackgroundColor = Color(
    0xFF050520,
  ); // Dark theme uchun background rang (juda to'q navy blue)
  static const Color darkCardColor = Color(
    0xFF101042,
  ); // Dark theme uchun card rang (o'rtacha to'q navy blue)
  static const Color onDarkSurfaceColor = Color(
    0xFFE6E6F2,
  ); // Dark theme uchun text/icon rang (och ko'k)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Raleway',
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: primaryLightColor,
        onSecondary: Colors.white,
        tertiary: primaryDarkColor,
        onTertiary: Colors.white,
        error: Colors.red.shade700,
        onError: Colors.white,
        surface: surfaceColor,
        onSurface: onSurfaceColor,
        surfaceTint: primaryColor.withAlpha(13), // 0.05 * 255 = ~13
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          minimumSize: const Size(double.infinity, 50),
          side: BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        floatingLabelStyle: TextStyle(color: primaryColor),
        prefixIconColor: onSurfaceColor,
        suffixIconColor: onSurfaceColor,
        iconColor: onSurfaceColor,
        hintStyle: TextStyle(
          color: onSurfaceColor.withAlpha(153),
        ), // 0.6 * 255 = ~153
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryColor),
      ),
      iconTheme: IconThemeData(color: onSurfaceColor),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primaryColor),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: onSurfaceColor,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: onSurfaceColor,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: onSurfaceColor,
          letterSpacing: -0.5,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: onSurfaceColor,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onSurfaceColor,
          letterSpacing: -0.5,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onSurfaceColor,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: onSurfaceColor,
          letterSpacing: -0.5,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: onSurfaceColor,
          letterSpacing: -0.5,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: onSurfaceColor,
          letterSpacing: -0.5,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: onSurfaceColor,
          letterSpacing: 0.15,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: onSurfaceColor,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: onSurfaceColor,
          letterSpacing: 0.4,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: onSurfaceColor,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: onSurfaceColor,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: onSurfaceColor,
          letterSpacing: 0.5,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return Colors.white;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(color: onSurfaceColor, fontSize: 16),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.white,
        contentTextStyle: TextStyle(color: onSurfaceColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: DividerThemeData(color: Colors.grey.shade200, thickness: 1),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.white,
        textColor: onSurfaceColor,
        iconColor: primaryColor,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return Colors.grey.shade400;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withAlpha(128); // 0.5 * 255 = ~128
          }
          return Colors.grey.shade300;
        }),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: Colors.grey.shade600,
        indicatorColor: primaryColor,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightNavyBlue,
        disabledColor: Colors.grey.shade200,
        selectedColor: primaryColor,
        secondarySelectedColor: primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: TextStyle(color: primaryColor),
        secondaryLabelStyle: TextStyle(color: Colors.white),
        brightness: Brightness.light,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackgroundColor,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: primaryLightColor,
        onPrimary: Colors.white,
        secondary: primaryColor,
        onSecondary: Colors.white,
        tertiary: primaryDarkColor,
        onTertiary: Colors.white,
        error: Colors.red.shade300,
        onError: Colors.white,
        surface: darkBackgroundColor,
        onSurface: onDarkSurfaceColor,
        surfaceTint: primaryLightColor.withAlpha(13), // 0.05 * 255 = ~13
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: darkSurfaceColor,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLightColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryLightColor,
          minimumSize: const Size(double.infinity, 50),
          side: BorderSide(color: primaryLightColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryLightColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        floatingLabelStyle: TextStyle(color: primaryLightColor),
        prefixIconColor: onDarkSurfaceColor,
        suffixIconColor: onDarkSurfaceColor,
        iconColor: onDarkSurfaceColor,
        hintStyle: TextStyle(
          color: onDarkSurfaceColor.withAlpha(153),
        ), // 0.6 * 255 = ~153
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryLightColor,
        unselectedItemColor: onDarkSurfaceColor.withAlpha(
          153,
        ), // 0.6 * 255 = ~153
        type: BottomNavigationBarType.fixed,
        backgroundColor: darkSurfaceColor,
        elevation: 8,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryLightColor,
        foregroundColor: Colors.white,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryLightColor),
      ),
      iconTheme: IconThemeData(color: onDarkSurfaceColor),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryLightColor,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: darkCardColor,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: onDarkSurfaceColor,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: onDarkSurfaceColor,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: onDarkSurfaceColor,
          letterSpacing: -0.5,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: onDarkSurfaceColor,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onDarkSurfaceColor,
          letterSpacing: -0.5,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onDarkSurfaceColor,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: onDarkSurfaceColor,
          letterSpacing: -0.5,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: onDarkSurfaceColor,
          letterSpacing: -0.5,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: onDarkSurfaceColor,
          letterSpacing: -0.5,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: onDarkSurfaceColor,
          letterSpacing: 0.15,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: onDarkSurfaceColor,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: onDarkSurfaceColor,
          letterSpacing: 0.4,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: onDarkSurfaceColor,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: onDarkSurfaceColor,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: onDarkSurfaceColor,
          letterSpacing: 0.5,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryLightColor;
          }
          return darkCardColor;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: darkCardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(color: onDarkSurfaceColor, fontSize: 16),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkCardColor,
        contentTextStyle: TextStyle(color: onDarkSurfaceColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: DividerThemeData(
        color: onDarkSurfaceColor.withAlpha(26), // 0.1 * 255 = ~26
        thickness: 1,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: darkCardColor,
        textColor: onDarkSurfaceColor,
        iconColor: primaryLightColor,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryLightColor;
          }
          return onDarkSurfaceColor.withAlpha(153); // 0.6 * 255 = ~153
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryLightColor.withAlpha(128); // 0.5 * 255 = ~128
          }
          return darkCardColor;
        }),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: primaryLightColor,
        unselectedLabelColor: onDarkSurfaceColor.withAlpha(153),
        indicatorColor: primaryLightColor,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkCardColor,
        disabledColor: darkCardColor.withAlpha(128), // 0.5 * 255 = ~128
        selectedColor: primaryLightColor,
        secondarySelectedColor: primaryLightColor,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: TextStyle(color: onDarkSurfaceColor),
        secondaryLabelStyle: TextStyle(color: Colors.white),
        brightness: Brightness.dark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
