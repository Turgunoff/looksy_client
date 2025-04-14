import 'package:looksy_client/features/bookings/models/booking_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingRepository {
  final SupabaseClient _supabaseClient;
  
  BookingRepository({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;
  
  // Get all bookings for a user
  Future<List<BookingModel>> getUserBookings(String userId) async {
    try {
      // In a real app, you would fetch data from Supabase
      // final response = await _supabaseClient
      //     .from('bookings')
      //     .select()
      //     .eq('user_id', userId)
      //     .order('date_time', ascending: false);
      
      // For demo purposes, we'll return mock data
      return _getMockBookings().where((booking) => booking.userId == userId).toList();
    } catch (e) {
      throw Exception('Failed to get bookings: $e');
    }
  }
  
  // Create a new booking
  Future<BookingModel> createBooking(BookingModel booking) async {
    try {
      // In a real app, you would insert data into Supabase
      // final response = await _supabaseClient
      //     .from('bookings')
      //     .insert(booking.toJson())
      //     .select()
      //     .single();
      
      // For demo purposes, we'll just return the booking
      return booking;
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }
  
  // Update a booking status
  Future<BookingModel> updateBookingStatus(String bookingId, BookingStatus status) async {
    try {
      // In a real app, you would update data in Supabase
      // final response = await _supabaseClient
      //     .from('bookings')
      //     .update({'status': status.toString().split('.').last})
      //     .eq('id', bookingId)
      //     .select()
      //     .single();
      
      // For demo purposes, we'll find and update the booking in mock data
      final bookings = _getMockBookings();
      final bookingIndex = bookings.indexWhere((b) => b.id == bookingId);
      
      if (bookingIndex == -1) {
        throw Exception('Booking not found');
      }
      
      final updatedBooking = BookingModel(
        id: bookings[bookingIndex].id,
        userId: bookings[bookingIndex].userId,
        salonId: bookings[bookingIndex].salonId,
        salonName: bookings[bookingIndex].salonName,
        serviceId: bookings[bookingIndex].serviceId,
        serviceName: bookings[bookingIndex].serviceName,
        dateTime: bookings[bookingIndex].dateTime,
        status: status,
        price: bookings[bookingIndex].price,
      );
      
      return updatedBooking;
    } catch (e) {
      throw Exception('Failed to update booking: $e');
    }
  }
  
  // Cancel a booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      // In a real app, you would update data in Supabase
      // await _supabaseClient
      //     .from('bookings')
      //     .update({'status': 'cancelled'})
      //     .eq('id', bookingId);
      
      // For demo purposes, we'll just update the status
      await updateBookingStatus(bookingId, BookingStatus.cancelled);
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }
  
  // Mock data for demo purposes
  List<BookingModel> _getMockBookings() {
    return [
      BookingModel(
        id: '1',
        userId: 'simulated-user-id',
        salonId: '1',
        salonName: 'Glamour Salon',
        serviceId: '101',
        serviceName: 'Soch kesish',
        dateTime: DateTime.now().add(const Duration(days: 2)),
        status: BookingStatus.confirmed,
        price: 50000,
      ),
      BookingModel(
        id: '2',
        userId: 'simulated-user-id',
        salonId: '3',
        salonName: 'Elite Spa & Salon',
        serviceId: '301',
        serviceName: 'Massaj',
        dateTime: DateTime.now().add(const Duration(days: 5)),
        status: BookingStatus.pending,
        price: 150000,
      ),
      BookingModel(
        id: '3',
        userId: 'simulated-user-id',
        salonId: '2',
        salonName: 'Beauty Studio',
        serviceId: '201',
        serviceName: 'Makiyaj',
        dateTime: DateTime.now().subtract(const Duration(days: 3)),
        status: BookingStatus.completed,
        price: 80000,
      ),
      BookingModel(
        id: '4',
        userId: 'guest-user-id',
        salonId: '5',
        salonName: 'Nail Art Studio',
        serviceId: '501',
        serviceName: 'Manikur',
        dateTime: DateTime.now().add(const Duration(days: 1)),
        status: BookingStatus.confirmed,
        price: 60000,
      ),
    ];
  }
}
