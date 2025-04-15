import 'package:flutter/material.dart';

class AppTheme {
  // Asosiy rang - Teal (#008080)
  static const Color primaryColor = Color(0xFF008080);
  static const Color primaryLightColor = Color(
    0xFF4FB3B3,
  ); // Teal rangining ochroq varianti
  static const Color primaryDarkColor = Color(
    0xFF006666,
  ); // Teal rangining to'qroq varianti

  // Zamonaviy UI uchun qo'shimcha ranglar
  static const Color surfaceColor = Color(
    0xFFF5F5F5,
  ); // Light theme uchun surface rang
  static const Color onSurfaceColor = Color(
    0xFF424242,
  ); // Light theme uchun text/icon rang
  static const Color darkSurfaceColor = Color(
    0xFF121212,
  ); // Dark theme uchun surface rang
  static const Color onDarkSurfaceColor = Color(
    0xFFE0E0E0,
  ); // Dark theme uchun text/icon rang
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: primaryLightColor,
        tertiary: primaryDarkColor,
        surface: surfaceColor,
        onSurface: onSurfaceColor,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: Color.fromARGB(204, 66, 66, 66)),
        actionsIconTheme: IconThemeData(color: primaryColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        floatingLabelStyle: TextStyle(color: primaryColor),
        prefixIconColor: Color.fromARGB(204, 66, 66, 66),
        suffixIconColor: Color.fromARGB(204, 66, 66, 66),
        iconColor: Color.fromARGB(204, 66, 66, 66),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryColor),
      ),
      iconTheme: IconThemeData(
        color: Color.fromARGB(204, 66, 66, 66),
      ), // 80% opacity
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primaryColor),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary:
            primaryLightColor, // Qorong'i temada ochroq rang yaxshiroq ko'rinadi
        secondary: primaryColor,
        tertiary: primaryDarkColor,
        surface: darkSurfaceColor,
        onSurface: onDarkSurfaceColor,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Color.fromARGB(230, 224, 224, 224)),
        actionsIconTheme: IconThemeData(color: primaryLightColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLightColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryLightColor, width: 2),
        ),
        floatingLabelStyle: TextStyle(color: primaryLightColor),
        prefixIconColor: Color.fromARGB(230, 224, 224, 224),
        suffixIconColor: Color.fromARGB(230, 224, 224, 224),
        iconColor: Color.fromARGB(230, 224, 224, 224),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryLightColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryLightColor),
      ),
      iconTheme: IconThemeData(
        color: Color.fromARGB(230, 224, 224, 224),
      ), // 90% opacity
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryLightColor,
      ),
    );
  }
}
