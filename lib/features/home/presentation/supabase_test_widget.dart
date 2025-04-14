import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseTestWidget extends StatefulWidget {
  const SupabaseTestWidget({super.key});

  @override
  State<SupabaseTestWidget> createState() => _SupabaseTestWidgetState();
}

class _SupabaseTestWidgetState extends State<SupabaseTestWidget> {
  bool _isLoading = false;
  String _testResult = 'Supabase ulanishini tekshirish uchun tugmani bosing';
  final _supabase = Supabase.instance.client;

  Future<void> _testSupabaseConnection() async {
    setState(() {
      _isLoading = true;
      _testResult = 'Tekshirilmoqda...';
    });

    try {
      // Check if we can get the current user (even if null)
      final session = _supabase.auth.currentSession;
      final user = _supabase.auth.currentUser;

      // Try to get health check
      final response = await _supabase.from('health_check').select().limit(1);
      // If we get here, it means Supabase is working

      setState(() {
        _isLoading = false;
        _testResult =
            'Supabase ulanishi muvaffaqiyatli!\n\n'
            'Session: ${session != null ? "Mavjud" : "Mavjud emas"}\n'
            'User: ${user != null ? user.email : "Mavjud emas"}\n'
            'Response: $response';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _testResult = 'Xatolik yuz berdi: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Supabase Test',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(_testResult),
            const SizedBox(height: 16),
            Center(
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: _testSupabaseConnection,
                        child: const Text('Supabase ulanishini tekshirish'),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
