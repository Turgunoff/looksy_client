import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:looksy_client/core/theme/app_theme.dart';
import 'package:looksy_client/features/profile/bloc/settings_bloc.dart';
import 'package:looksy_client/features/profile/bloc/settings_event.dart';
import 'package:looksy_client/features/profile/bloc/settings_state.dart';
import 'package:looksy_client/features/profile/models/app_settings_model.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key}); 

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    Widget themeCard({
      required String title,
      required IconData icon,
      required AppThemeMode value,
      required AppThemeMode groupValue,
      required VoidCallback onTap,
    }) {
      final bool selected = value == groupValue;
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: BoxDecoration(
            color:
                selected
                    ? AppTheme.primaryColor.withOpacity(0.08)
                    : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppTheme.primaryColor : Colors.grey.shade200,
              width: selected ? 2 : 1,
            ),
            boxShadow: [
              if (selected)
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected ? AppTheme.primaryColor : Colors.grey,
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    color: selected ? AppTheme.primaryColor : Colors.black,
                  ),
                ),
              ),
              if (selected)
                Icon(
                  Icons.check_circle,
                  color: AppTheme.primaryColor,
                  size: 28,
                ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mavzu sozlamalari'), elevation: 0),
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final current = state.settings.themeMode;
          return Column(
            children: [
              const SizedBox(height: 16),
              themeCard(
                title: "Yorug'",
                icon: Iconsax.sun_1,
                value: AppThemeMode.light,
                groupValue: current,
                onTap:
                    () => context.read<SettingsBloc>().add(
                      ChangeThemeMode(AppThemeMode.light),
                    ),
              ),
              themeCard(
                title: "Qorong'i",
                icon: Iconsax.moon5,
                value: AppThemeMode.dark,
                groupValue: current,
                onTap:
                    () => context.read<SettingsBloc>().add(
                      ChangeThemeMode(AppThemeMode.dark),
                    ),
              ),
              themeCard(
                title: "Tizim",
                icon: Icons.phone_android,
                value: AppThemeMode.system,
                groupValue: current,
                onTap:
                    () => context.read<SettingsBloc>().add(
                      ChangeThemeMode(AppThemeMode.system),
                    ),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Mavzu o'zgarishlari dasturni qayta ishga tushirgandan so'ng to'liq kuchga kiradi.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
