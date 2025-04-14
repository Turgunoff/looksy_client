import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:looksy_client/features/auth/bloc/auth_bloc_fixed.dart';
import 'package:looksy_client/features/auth/bloc/auth_state.dart';
import 'package:looksy_client/features/bookings/data/booking_repository.dart';
import 'package:looksy_client/features/bookings/models/booking_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late BookingRepository _bookingRepository;
  List<BookingModel> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _bookingRepository = BookingRepository(
      supabaseClient: Supabase.instance.client,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings(String userId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final bookings = await _bookingRepository.getUserBookings(userId);
      setState(() {
        _bookings = bookings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bronlarni yuklashda xatolik: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          // Load bookings when authenticated
          if (_isLoading && _bookings.isEmpty) {
            _loadBookings(state.model.userId!);
          }
          return _buildAuthenticatedContent();
        } else {
          return _buildUnauthenticatedContent(context);
        }
      },
    );
  }

  Widget _buildAuthenticatedContent() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Looksy - Bronlar'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Faol'), Tab(text: 'O\'tgan')],
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                controller: _tabController,
                children: [
                  _buildBookingsList(_getActiveBookings()),
                  _buildBookingsList(_getPastBookings()),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create booking page
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildUnauthenticatedContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Looksy - Bronlar')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Bu sahifani ko\'rish uchun tizimga kiring',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to login page
                context.go('/login');
              },
              child: const Text('Kirish'),
            ),
          ],
        ),
      ),
    );
  }

  List<BookingModel> _getActiveBookings() {
    final now = DateTime.now();
    return _bookings.where((booking) {
      return booking.dateTime.isAfter(now) &&
          (booking.status == BookingStatus.confirmed ||
              booking.status == BookingStatus.pending);
    }).toList();
  }

  List<BookingModel> _getPastBookings() {
    final now = DateTime.now();
    return _bookings.where((booking) {
      return booking.dateTime.isBefore(now) ||
          booking.status == BookingStatus.completed ||
          booking.status == BookingStatus.cancelled;
    }).toList();
  }

  Widget _buildBookingsList(List<BookingModel> bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.event_busy, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Hozircha bronlar yo\'q',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      booking.salonName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    _buildStatusChip(booking.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(booking.serviceName, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 8),
                    Text(DateFormat('dd.MM.yyyy').format(booking.dateTime)),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 8),
                    Text(DateFormat('HH:mm').format(booking.dateTime)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.payments_outlined, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '${booking.price.toStringAsFixed(0)} so\'m',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (booking.status == BookingStatus.pending ||
                    booking.status == BookingStatus.confirmed)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            _showCancelConfirmationDialog(booking);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text('Bekor qilish'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(BookingStatus status) {
    Color color;
    String label;

    switch (status) {
      case BookingStatus.pending:
        color = Colors.orange;
        label = 'Kutilmoqda';
        break;
      case BookingStatus.confirmed:
        color = Colors.green;
        label = 'Tasdiqlangan';
        break;
      case BookingStatus.completed:
        color = Colors.blue;
        label = 'Yakunlangan';
        break;
      case BookingStatus.cancelled:
        color = Colors.red;
        label = 'Bekor qilingan';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12)),
    );
  }

  Future<void> _showCancelConfirmationDialog(BookingModel booking) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bronni bekor qilish'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text('Haqiqatan ham bu bronni bekor qilmoqchimisiz?'),
                SizedBox(height: 8),
                Text(
                  'Bu amalni qaytarib bo\'lmaydi.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yo\'q'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Ha, bekor qilish',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await _bookingRepository.cancelBooking(booking.id);
                  // Reload bookings after cancellation
                  final state = context.read<AuthBloc>().state;
                  if (state is Authenticated) {
                    _loadBookings(state.model.userId!);
                  }
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Bron muvaffaqiyatli bekor qilindi'),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Xatolik yuz berdi: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
