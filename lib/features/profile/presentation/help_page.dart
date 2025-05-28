import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:looksy_client/core/theme/app_theme.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  int? expandedIndex;

  final faqs = [
    {
      'q': "Looksy ilovasidan qanday foydalanaman?",
      'a':
          "Looksy ilovasidan foydalanish juda oson. Bosh sahifada mashhur salonlarni ko'rishingiz, qidiruv sahifasida o'zingizga kerakli salonni topishingiz va xizmatlarni bron qilishingiz mumkin. Bron qilish uchun avval ro'yxatdan o'ting.",
    },
    {
      'q': "Bron qilish uchun to'lov qilishim kerakmi?",
      'a':
          "Yo'q, Looksy ilovasida bron qilish bepul. Siz faqat salon xizmatlari uchun to'lov qilasiz, u ham to'g'ridan-to'g'ri salonda.",
    },
    {
      'q': "Bronni qanday bekor qilaman?",
      'a':
          "Bronni bekor qilish uchun \"Bronlar\" bo'limiga o'ting, bekor qilmoqchi bo'lgan bronni tanlang va \"Bekor qilish\" tugmasini bosing. Bronni xizmat ko'rsatish vaqtidan kamida 2 soat oldin bekor qilishingiz kerak.",
    },
    {
      'q': "Salon bilan qanday bog'lanaman?",
      'a':
          "Salon bilan bog'lanish uchun \"Chat\" bo'limidan foydalanishingiz yoki salon sahifasidagi telefon raqamiga qo'ng'iroq qilishingiz mumkin.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yordam'), elevation: 0),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ko'p so'raladigan savollar",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...List.generate(faqs.length, (i) {
              final isOpen = expandedIndex == i;
              return Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      setState(() {
                        expandedIndex = isOpen ? null : i;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 4,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              faqs[i]['q']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          AnimatedRotation(
                            duration: const Duration(milliseconds: 200),
                            turns: isOpen ? 0.5 : 0,
                            child: Icon(
                              isOpen ? Iconsax.minus : Iconsax.add,
                              color: AppTheme.primaryColor,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        left: 2,
                        right: 2,
                        bottom: 12,
                      ),
                      child: Text(
                        faqs[i]['a']!,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    crossFadeState:
                        isOpen
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 200),
                  ),
                  Divider(color: Colors.grey.shade300, thickness: 1, height: 0),
                ],
              );
            }),
            const SizedBox(height: 28),
            const Text(
              "Qo'llab-quvvatlash xizmati",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bizga murojaat qiling:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Iconsax.sms,
                          color: AppTheme.primaryColor,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        const Text('support@looksy.uz'),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Iconsax.call,
                          color: AppTheme.primaryColor,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        const Text('+998 XX XXX XX XX'),
                      ],
                    ),
                    const SizedBox(height: 14),
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
            const SizedBox(height: 28),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    // Support chat or form logic
                  },
                  icon: const Icon(Iconsax.message, color: Colors.white),
                  label: const Text(
                    'Xabar yuborish',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
