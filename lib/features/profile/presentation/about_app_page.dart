import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:looksy_client/core/theme/app_theme.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color mainColor = AppTheme.primaryColor;

    Widget pillCard({
      required IconData icon,
      required String title,
      required String subtitle,
      Color? iconColor,
    }) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? mainColor, size: 26),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Ilova haqida'), elevation: 0),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Logo va nom
            Column(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.spa, size: 50, color: mainColor),
                ),
                const SizedBox(height: 16),
                Text(
                  'Looksy',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Versiya 1.0.0',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
              ],
            ),
            // Ilova haqida
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                "Looksy — bu go'zallik salonlari uchun zamonaviy bron qilish ilovasi. Siz yaqin atrofdagi salonlarni topishingiz, xizmatlar bilan tanishishingiz va qulay vaqtda bron qilishingiz mumkin.",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 28),
            // Kontaktlar
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Bog'lanish",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: mainColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            pillCard(
              icon: Iconsax.message_2_outline,
              title: 'Email',
              subtitle: 'support@looksy.uz',
            ),
            pillCard(
              icon: Iconsax.call_bold,
              title: 'Telefon',
              subtitle: '+998 94 643 37 33',
            ),
            pillCard(
              icon: Iconsax.global_bold,
              title: 'Veb-sayt',
              subtitle: 'www.looksy.uz',
            ),
            const SizedBox(height: 28),
            // Ijtimoiy tarmoqlar
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Ijtimoiy tarmoqlar",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: mainColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            pillCard(
              icon: BoxIcons.bxl_telegram,
              title: 'Telegram',
              subtitle: '@looksy_uz',
              iconColor: Colors.blue,
            ),
            pillCard(
              icon: BoxIcons.bxl_facebook,
              title: 'Facebook',
              subtitle: 'Looksy O\'zbekiston',
              iconColor: Colors.blue[800],
            ),
            pillCard(
              icon: BoxIcons.bxl_instagram,
              title: 'Instagram',
              subtitle: '@looksy_uz',
              iconColor: Colors.purple,
            ),
            const SizedBox(height: 32),
            const Text(
              '© 2025 Looksy. Barcha huquqlar himoyalangan.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
