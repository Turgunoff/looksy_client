class GreetingUtility {
  // Get greeting based on current time
  static String getTimeBasedGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Доброе утро';
    } else if (hour >= 12 && hour < 17) {
      return 'Добрый день';
    } else if (hour >= 17 && hour < 21) {
      return 'Добрый вечер';
    } else {
      return 'Спокойной ночи';
    }
  }

  // Get personalized greeting with name if logged in
  static String getPersonalizedGreeting({
    required bool isLoggedIn,
    String? userName,
  }) {
    final greeting = getTimeBasedGreeting();

    if (isLoggedIn && userName != null && userName.isNotEmpty) {
      return '$greeting, $userName';
    } else {
      return greeting;
    }
  }
}
