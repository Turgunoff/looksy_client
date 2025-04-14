import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:looksy_client/features/profile/bloc/settings_bloc.dart';
import 'package:looksy_client/features/profile/bloc/settings_event.dart';
import 'package:looksy_client/features/profile/bloc/settings_state.dart';
import 'package:looksy_client/features/profile/models/app_settings_model.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mavzu sozlamalari'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return ListView(
            children: [
              RadioListTile<AppThemeMode>(
                title: const Text('Yorug\''),
                value: AppThemeMode.light,
                groupValue: state.settings.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsBloc>().add(ChangeThemeMode(value));
                  }
                },
              ),
              RadioListTile<AppThemeMode>(
                title: const Text('Qorong\'i'),
                value: AppThemeMode.dark,
                groupValue: state.settings.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsBloc>().add(ChangeThemeMode(value));
                  }
                },
              ),
              RadioListTile<AppThemeMode>(
                title: const Text('Tizim'),
                subtitle: const Text('Qurilma sozlamalariga mos'),
                value: AppThemeMode.system,
                groupValue: state.settings.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsBloc>().add(ChangeThemeMode(value));
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Mavzu o\'zgarishlari dasturni qayta ishga tushirgandan so\'ng to\'liq kuchga kiradi.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
