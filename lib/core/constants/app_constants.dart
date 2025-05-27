import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // API URLs - loaded from .env file
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Route Names
  static const String homeRoute = '/';
  static const String searchRoute = '/search';
  static const String bookingsRoute = '/bookings';
  static const String chatRoute = '/chat';
  static const String profileRoute = '/profile';
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';

  // Bottom Navigation Bar Items
  static const int homeTabIndex = 0;
  static const int searchTabIndex = 1;
  static const int bookingsTabIndex = 2;
  static const int chatTabIndex = 3;
  static const int profileTabIndex = 4;
}
