import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:looksy_client/core/theme/app_theme.dart';
import 'package:looksy_client/features/auth/bloc/auth_bloc_fixed.dart';
import 'package:looksy_client/features/auth/bloc/auth_event.dart';
import 'package:looksy_client/features/auth/bloc/auth_state.dart';
import 'package:looksy_client/features/profile/presentation/about_app_page.dart';
import 'package:looksy_client/features/profile/presentation/help_page.dart';
import 'package:looksy_client/features/profile/presentation/language_settings_page.dart';
import 'package:looksy_client/features/profile/presentation/notification_settings_page.dart';
import 'package:looksy_client/features/profile/presentation/theme_settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return _buildAuthenticatedContent(context);
        } else {
          return _buildUnauthenticatedContent(context);
        }
      },
    );
  }

  Widget _buildAuthenticatedContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Looksy - Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const LogoutRequested());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile header
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.pink,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Foydalanuvchi',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'user@example.com',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Personal information section
              const Text(
                'Shaxsiy ma\'lumotlar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'To\'liq ism',
                value: 'Foydalanuvchi Ismi',
                icon: Icons.person_outline,
                onTap: () {},
              ),
              _buildInfoCard(
                title: 'Telefon raqam',
                value: '+998 XX XXX XX XX',
                icon: Icons.phone_outlined,
                onTap: () {},
              ),
              _buildInfoCard(
                title: 'Manzil',
                value: 'Toshkent, O\'zbekiston',
                icon: Icons.location_on_outlined,
                onTap: () {},
              ),

              const SizedBox(height: 24),

              // App settings section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.settings, color: AppTheme.primaryColor),
                        const SizedBox(width: 12),
                        const Text(
                          'Ilova sozlamalari',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSettingsTile(
                      title: 'Bildirishnomalar',
                      subtitle: 'Bildirishnomalarni boshqarish',
                      icon: Icons.notifications_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const NotificationSettingsPage(),
                          ),
                        );
                      },
                    ),
                    _buildSettingsTile(
                      title: 'Til',
                      subtitle: 'Tilni o\'zgartirish',
                      icon: Icons.language_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LanguageSettingsPage(),
                          ),
                        );
                      },
                    ),
                    _buildSettingsTile(
                      title: 'Mavzu',
                      subtitle: 'Ilova mavzusini o\'zgartirish',
                      icon: Icons.color_lens_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ThemeSettingsPage(),
                          ),
                        );
                      },
                    ),
                    _buildSettingsTile(
                      title: 'Yordam',
                      subtitle: 'Ko\'p so\'raladigan savollar',
                      icon: Icons.help_outline,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HelpPage(),
                          ),
                        );
                      },
                    ),
                    _buildSettingsTile(
                      title: 'Ilova haqida',
                      subtitle: 'Versiya va litsenziya',
                      icon: Icons.info_outline,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutAppPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Logout button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.read<AuthBloc>().add(const LogoutRequested());
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Chiqish'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.pink),
        title: Text(title),
        subtitle: Text(value),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnauthenticatedContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Looksy - Profil')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Login section
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Shaxsiy ma\'lumotlarni ko\'rish uchun tizimga kiring',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to login page
                        context.push('/login');
                      },
                      child: const Text('Kirish'),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                  ],
                ),
              ),

              // App settings section
              const SizedBox(height: 24),
              const Text(
                'Ilova sozlamalari',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildSettingsTile(
                title: 'Mavzu',
                subtitle: 'Ilova mavzusini o\'zgartirish',
                icon: Icons.color_lens_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ThemeSettingsPage(),
                    ),
                  );
                },
              ),
              _buildSettingsTile(
                title: 'Til',
                subtitle: 'Tilni o\'zgartirish',
                icon: Icons.language_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LanguageSettingsPage(),
                    ),
                  );
                },
              ),
              _buildSettingsTile(
                title: 'Bildirishnomalar',
                subtitle: 'Bildirishnomalarni boshqarish',
                icon: Icons.notifications_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationSettingsPage(),
                    ),
                  );
                },
              ),
              _buildSettingsTile(
                title: 'Yordam',
                subtitle: 'Ko\'p so\'raladigan savollar',
                icon: Icons.help_outline,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HelpPage()),
                  );
                },
              ),
              _buildSettingsTile(
                title: 'Ilova haqida',
                subtitle: 'Versiya va litsenziya',
                icon: Icons.info_outline,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutAppPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
