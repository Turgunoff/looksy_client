import 'package:equatable/equatable.dart';

enum AppThemeMode {
  light,
  dark,
  system,
}

enum AppLanguage {
  uzbek,
  russian,
  english,
}

class AppSettingsModel extends Equatable {
  final AppThemeMode themeMode;
  final AppLanguage language;
  final bool notificationsEnabled;

  const AppSettingsModel({
    this.themeMode = AppThemeMode.system,
    this.language = AppLanguage.uzbek,
    this.notificationsEnabled = true,
  });

  AppSettingsModel copyWith({
    AppThemeMode? themeMode,
    AppLanguage? language,
    bool? notificationsEnabled,
  }) {
    return AppSettingsModel(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  List<Object?> get props => [themeMode, language, notificationsEnabled];
}
