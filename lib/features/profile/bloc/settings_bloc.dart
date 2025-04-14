import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:looksy_client/features/profile/bloc/settings_event.dart';
import 'package:looksy_client/features/profile/bloc/settings_state.dart';
import 'package:looksy_client/features/profile/models/app_settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<ChangeThemeMode>(_onChangeThemeMode);
    on<ChangeLanguage>(_onChangeLanguage);
    on<ToggleNotifications>(_onToggleNotifications);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading(state.settings));
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load theme mode
      final themeModeIndex = prefs.getInt('theme_mode') ?? AppThemeMode.system.index;
      final themeMode = AppThemeMode.values[themeModeIndex];
      
      // Load language
      final languageIndex = prefs.getInt('language') ?? AppLanguage.uzbek.index;
      final language = AppLanguage.values[languageIndex];
      
      // Load notifications setting
      final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      
      final settings = AppSettingsModel(
        themeMode: themeMode,
        language: language,
        notificationsEnabled: notificationsEnabled,
      );
      
      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError(state.settings, e.toString()));
    }
  }

  Future<void> _onChangeThemeMode(
    ChangeThemeMode event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('theme_mode', event.themeMode.index);
      
      final updatedSettings = state.settings.copyWith(themeMode: event.themeMode);
      emit(SettingsLoaded(updatedSettings));
    } catch (e) {
      emit(SettingsError(state.settings, e.toString()));
    }
  }

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('language', event.language.index);
      
      final updatedSettings = state.settings.copyWith(language: event.language);
      emit(SettingsLoaded(updatedSettings));
    } catch (e) {
      emit(SettingsError(state.settings, e.toString()));
    }
  }

  Future<void> _onToggleNotifications(
    ToggleNotifications event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notifications_enabled', event.enabled);
      
      final updatedSettings = state.settings.copyWith(notificationsEnabled: event.enabled);
      emit(SettingsLoaded(updatedSettings));
    } catch (e) {
      emit(SettingsError(state.settings, e.toString()));
    }
  }
}
