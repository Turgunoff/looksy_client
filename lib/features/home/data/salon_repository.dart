import 'package:looksy_client/features/home/models/salon_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SalonRepository {
  final SupabaseClient _supabaseClient;
  
  SalonRepository({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;
  
  // Get all salons
  Future<List<SalonModel>> getSalons() async {
    try {
      // In a real app, you would fetch data from Supabase
      // final response = await _supabaseClient
      //     .from('salons')
      //     .select()
      //     .order('name');
      
      // For demo purposes, we'll return mock data
      return _getMockSalons();
    } catch (e) {
      throw Exception('Failed to get salons: $e');
    }
  }
  
  // Get a salon by ID
  Future<SalonModel> getSalonById(String id) async {
    try {
      // In a real app, you would fetch data from Supabase
      // final response = await _supabaseClient
      //     .from('salons')
      //     .select()
      //     .eq('id', id)
      //     .single();
      
      // For demo purposes, we'll return mock data
      final salons = _getMockSalons();
      final salon = salons.firstWhere((salon) => salon.id == id);
      return salon;
    } catch (e) {
      throw Exception('Failed to get salon: $e');
    }
  }
  
  // Search salons by name or service
  Future<List<SalonModel>> searchSalons(String query) async {
    try {
      // In a real app, you would search data from Supabase
      // final response = await _supabaseClient
      //     .from('salons')
      //     .select()
      //     .ilike('name', '%$query%')
      //     .order('name');
      
      // For demo purposes, we'll filter mock data
      final salons = _getMockSalons();
      return salons
          .where((salon) => 
              salon.name.toLowerCase().contains(query.toLowerCase()) ||
              salon.services.any((service) => 
                  service.toLowerCase().contains(query.toLowerCase())))
          .toList();
    } catch (e) {
      throw Exception('Failed to search salons: $e');
    }
  }
  
  // Mock data for demo purposes
  List<SalonModel> _getMockSalons() {
    return [
      const SalonModel(
        id: '1',
        name: 'Glamour Salon',
        imageUrl: 'https://example.com/salon1.jpg',
        address: 'Toshkent, Chilonzor tumani, 7-mavze',
        rating: 4.8,
        services: ['Soch kesish', 'Soch bo\'yash', 'Manikur', 'Pedikur'],
        description: 'Zamonaviy uslubda soch kesish va turli xil go\'zallik xizmatlari.',
      ),
      const SalonModel(
        id: '2',
        name: 'Beauty Studio',
        imageUrl: 'https://example.com/salon2.jpg',
        address: 'Toshkent, Yunusobod tumani, 19-mavze',
        rating: 4.5,
        services: ['Makiyaj', 'Soch turmagi', 'Manikur', 'Pedikur'],
        description: 'Har qanday tadbirlar uchun professional makiyaj va soch turmagi.',
      ),
      const SalonModel(
        id: '3',
        name: 'Elite Spa & Salon',
        imageUrl: 'https://example.com/salon3.jpg',
        address: 'Toshkent, Mirzo Ulug\'bek tumani',
        rating: 4.9,
        services: ['Spa', 'Massaj', 'Manikur', 'Pedikur', 'Soch kesish'],
        description: 'Yuqori sifatli spa va go\'zallik xizmatlari.',
      ),
      const SalonModel(
        id: '4',
        name: 'Modern Style',
        imageUrl: 'https://example.com/salon4.jpg',
        address: 'Toshkent, Shayxontohur tumani',
        rating: 4.3,
        services: ['Soch kesish', 'Soqol olish', 'Soch bo\'yash'],
        description: 'Erkaklar uchun zamonaviy soch kesish va soqol olish xizmatlari.',
      ),
      const SalonModel(
        id: '5',
        name: 'Nail Art Studio',
        imageUrl: 'https://example.com/salon5.jpg',
        address: 'Toshkent, Yakkasaroy tumani',
        rating: 4.7,
        services: ['Manikur', 'Pedikur', 'Tirnoq dizayni'],
        description: 'Professional manikur va pedikur xizmatlari.',
      ),
    ];
  }
}
