import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileService {
  final SupabaseClient _supabaseClient;
  
  UserProfileService({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;
  
  // Check if user is logged in
  bool isUserLoggedIn() {
    final session = _supabaseClient.auth.currentSession;
    return session != null;
  }
  
  // Get current user's ID
  String? getCurrentUserId() {
    final user = _supabaseClient.auth.currentUser;
    return user?.id;
  }
  
  // Get user's name from metadata
  String? getUserName() {
    final user = _supabaseClient.auth.currentUser;
    if (user == null) return null;
    
    // Try to get name from user metadata
    final userData = user.userMetadata;
    if (userData != null && userData.containsKey('full_name')) {
      return userData['full_name'] as String;
    }
    
    // If no name in metadata, use email or a default
    return user.email?.split('@').first ?? 'User';
  }
  
  // Get user's profile data
  Future<Map<String, dynamic>?> getUserProfile() async {
    final userId = getCurrentUserId();
    if (userId == null) return null;
    
    try {
      // In a real app, you would fetch from a profiles table
      // final response = await _supabaseClient
      //     .from('profiles')
      //     .select()
      //     .eq('id', userId)
      //     .single();
      
      // For demo purposes, return mock data
      return {
        'id': userId,
        'full_name': getUserName(),
        'email': _supabaseClient.auth.currentUser?.email,
        'phone_number': '+998 XX XXX XX XX',
        'address': 'Tashkent, Uzbekistan',
      };
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }
}
