import 'package:equatable/equatable.dart';
import 'package:looksy_client/features/profile/models/app_settings_model.dart';

abstract class SettingsState extends Equatable {
  final AppSettingsModel settings;
  
  const SettingsState(this.settings);
  
  @override
  List<Object?> get props => [settings];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial() : super(const AppSettingsModel());
}

class SettingsLoaded extends SettingsState {
  const SettingsLoaded(AppSettingsModel settings) : super(settings);
}

class SettingsLoading extends SettingsState {
  const SettingsLoading(AppSettingsModel settings) : super(settings);
}

class SettingsError extends SettingsState {
  final String message;
  
  const SettingsError(AppSettingsModel settings, this.message) : super(settings);
  
  @override
  List<Object?> get props => [settings, message];
}
