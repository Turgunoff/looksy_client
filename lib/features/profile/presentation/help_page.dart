import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yordam'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ko\'p so\'raladigan savollar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFaqItem(
              question: 'Looksy ilovasidan qanday foydalanaman?',
              answer:
                  'Looksy ilovasidan foydalanish juda oson. Bosh sahifada mashhur salonlarni ko\'rishingiz, qidiruv sahifasida o\'zingizga kerakli salonni topishingiz va xizmatlarni bron qilishingiz mumkin. Bron qilish uchun avval ro\'yxatdan o\'tishingiz kerak.',
            ),
            _buildFaqItem(
              question: 'Bron qilish uchun to\'lov qilishim kerakmi?',
              answer:
                  'Yo\'q, Looksy ilovasida bron qilish bepul. Siz faqat salon xizmatlari uchun to\'lov qilasiz, u ham to\'g\'ridan-to\'g\'ri salonda.',
            ),
            _buildFaqItem(
              question: 'Bronni qanday bekor qilaman?',
              answer:
                  'Bronni bekor qilish uchun "Bronlar" bo\'limiga o\'ting, bekor qilmoqchi bo\'lgan bronni tanlang va "Bekor qilish" tugmasini bosing. Bronni xizmat ko\'rsatish vaqtidan kamida 2 soat oldin bekor qilishingiz kerak.',
            ),
            _buildFaqItem(
              question: 'Salon bilan qanday bog\'lanaman?',
              answer:
                  'Salon bilan bog\'lanish uchun "Chat" bo\'limidan foydalanishingiz yoki salon sahifasidagi telefon raqamiga qo\'ng\'iroq qilishingiz mumkin.',
            ),
            const SizedBox(height: 24),
            const Text(
              'Qo\'llab-quvvatlash xizmati',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bizga murojaat qiling:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.email, color: Colors.pink, size: 20),
                        const SizedBox(width: 8),
                        const Text('support@looksy.uz'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.pink, size: 20),
                        const SizedBox(width: 8),
                        const Text('+998 XX XXX XX XX'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Ish vaqti: Dushanba-Juma, 9:00 - 18:00',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // In a real app, this would open a form or chat with support
                },
                icon: const Icon(Icons.message),
                label: const Text('Xabar yuborish'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem({
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(answer),
        ),
      ],
    );
  }
}
