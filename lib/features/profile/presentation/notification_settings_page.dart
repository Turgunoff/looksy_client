import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:looksy_client/features/profile/bloc/settings_bloc.dart';
import 'package:looksy_client/features/profile/bloc/settings_event.dart';
import 'package:looksy_client/features/profile/bloc/settings_state.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirishnoma sozlamalari'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Barcha bildirishnomalar'),
                subtitle: const Text('Barcha bildirishnomalarni yoqish yoki o\'chirish'),
                value: state.settings.notificationsEnabled,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(ToggleNotifications(value));
                },
              ),
              const Divider(),
              SwitchListTile(
                title: const Text('Bron eslatmalari'),
                subtitle: const Text('Bron qilish vaqti yaqinlashganda eslatma olish'),
                value: state.settings.notificationsEnabled,
                onChanged: state.settings.notificationsEnabled
                    ? (value) {
                        // In a real app, you would handle specific notification types
                      }
                    : null,
              ),
              SwitchListTile(
                title: const Text('Yangiliklar'),
                subtitle: const Text('Yangi xizmatlar va aksiyalar haqida xabar olish'),
                value: state.settings.notificationsEnabled,
                onChanged: state.settings.notificationsEnabled
                    ? (value) {
                        // In a real app, you would handle specific notification types
                      }
                    : null,
              ),
              SwitchListTile(
                title: const Text('Xabarlar'),
                subtitle: const Text('Yangi xabarlar kelganda bildirishnoma olish'),
                value: state.settings.notificationsEnabled,
                onChanged: state.settings.notificationsEnabled
                    ? (value) {
                        // In a real app, you would handle specific notification types
                      }
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
