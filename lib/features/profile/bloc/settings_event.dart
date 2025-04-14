import 'package:equatable/equatable.dart';
import 'package:looksy_client/features/profile/models/app_settings_model.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class ChangeThemeMode extends SettingsEvent {
  final AppThemeMode themeMode;

  const ChangeThemeMode(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

class ChangeLanguage extends SettingsEvent {
  final AppLanguage language;

  const ChangeLanguage(this.language);

  @override
  List<Object?> get props => [language];
}

class ToggleNotifications extends SettingsEvent {
  final bool enabled;

  const ToggleNotifications(this.enabled);

  @override
  List<Object?> get props => [enabled];
}
