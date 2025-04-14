# Looksy - Go'zallik saloni bron qilish ilovasi

Looksy - bu go'zallik salonlari uchun bron qilish ilovasi.

Bu ilova orqali foydalanuvchilar:

- O'zlariga yaqin joylashgan salonlarni topishi
- Salonlarning xizmatlari bilan tanishishi
- O'zlariga qulay vaqtda xizmatlarni bron qilishi mumkin

## Texnologiyalar

- **Flutter**: Kross-platforma UI framework
- **BLoC**: State management
- **Go Router**: Navigatsiya
- **Supabase**: Backend as a Service
- **Flutter DotEnv**: Environment variables
- **Shared Preferences**: Local storage

## Xususiyatlar

- Salonlarni qidirish va ko'rish
- Xizmatlarni bron qilish
- Foydalanuvchi profili
- Mavzu va til sozlamalari
- Bildirishnomalar
- Chat

## O'rnatish

1. Loyihani klonlash:

   ```bash
   git clone https://github.com/Turgunoff/looksy_client.git
   cd looksy_client
   ```

2. `.env` faylini yaratish:

   ```
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

3. Paketlarni o'rnatish:

   ```bash
   flutter pub get
   ```

4. Ilovani ishga tushirish:
   ```bash
   flutter run
   ```

## Loyiha strukturasi

```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── auth/
│   ├── bookings/
│   ├── chat/
│   ├── home/
│   ├── profile/
│   └── search/
├── router/
└── main.dart
```

## Kontributorlar

- [Eldor Turgunov](https://github.com/Turgunoff)

## Litsenziya

Bu loyiha MIT litsenziyasi ostida tarqatiladi. Batafsil ma'lumot uchun [LICENSE](LICENSE) faylini ko'ring.
