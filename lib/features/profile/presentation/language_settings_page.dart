import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:looksy_client/features/profile/bloc/settings_bloc.dart';
import 'package:looksy_client/features/profile/bloc/settings_event.dart';
import 'package:looksy_client/features/profile/bloc/settings_state.dart';
import 'package:looksy_client/features/profile/models/app_settings_model.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Til sozlamalari'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return ListView(
            children: [
              RadioListTile<AppLanguage>(
                title: const Text('O\'zbek tili'),
                value: AppLanguage.uzbek,
                groupValue: state.settings.language,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsBloc>().add(ChangeLanguage(value));
                  }
                },
              ),
              RadioListTile<AppLanguage>(
                title: const Text('Русский язык'),
                value: AppLanguage.russian,
                groupValue: state.settings.language,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsBloc>().add(ChangeLanguage(value));
                  }
                },
              ),
              RadioListTile<AppLanguage>(
                title: const Text('English'),
                value: AppLanguage.english,
                groupValue: state.settings.language,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsBloc>().add(ChangeLanguage(value));
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Til o\'zgarishlari dasturni qayta ishga tushirgandan so\'ng to\'liq kuchga kiradi.',
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
