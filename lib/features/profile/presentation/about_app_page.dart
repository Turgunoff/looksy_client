import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ilova haqida'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.pink.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.spa,
                      size: 60,
                      color: Colors.pink,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Looksy',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Versiya 1.0.0'),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            const Text(
              'Ilova haqida',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Looksy - bu go\'zallik salonlari uchun bron qilish ilovasi. Bu ilova orqali siz o\'zingizga yaqin joylashgan salonlarni topishingiz, ularning xizmatlari bilan tanishishingiz va o\'zingizga qulay vaqtda bron qilishingiz mumkin.',
            ),
            const SizedBox(height: 24),
            const Text(
              'Bog\'lanish',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildContactItem(
              icon: Icons.email_outlined,
              title: 'Email',
              subtitle: 'support@looksy.uz',
            ),
            _buildContactItem(
              icon: Icons.phone_outlined,
              title: 'Telefon',
              subtitle: '+998 XX XXX XX XX',
            ),
            _buildContactItem(
              icon: Icons.language_outlined,
              title: 'Veb-sayt',
              subtitle: 'www.looksy.uz',
            ),
            const SizedBox(height: 24),
            const Text(
              'Ijtimoiy tarmoqlar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildContactItem(
              icon: Icons.telegram,
              title: 'Telegram',
              subtitle: '@looksy_uz',
            ),
            _buildContactItem(
              icon: Icons.facebook,
              title: 'Facebook',
              subtitle: 'Looksy O\'zbekiston',
            ),
            _buildContactItem(
              icon: Icons.camera_alt_outlined,
              title: 'Instagram',
              subtitle: '@looksy_uz',
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                '© 2023 Looksy. Barcha huquqlar himoyalangan.',
                style: TextStyle(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.pink),
      title: Text(title),
      subtitle: Text(subtitle),
      contentPadding: EdgeInsets.zero,
    );
  }
}
