import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:looksy_client/features/home/data/salon_repository.dart';
import 'package:looksy_client/features/home/models/salon_model.dart';
import 'package:looksy_client/features/location/services/location_service.dart';
import 'package:looksy_client/features/profile/services/user_profile_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final SalonRepository _salonRepository;
  late final UserProfileService _userProfileService;
  late final LocationService _locationService;

  List<SalonModel> _salons = [];
  bool _isLoading = true;
  String _greeting = 'Доброе утро';
  String? _userName;
  bool _isLoggedIn = false;
  String _currentStreet = 'улица Навои';
  bool _isLocationEnabled = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initialize repositories and services
    final supabaseClient = Supabase.instance.client;
    _salonRepository = SalonRepository(supabaseClient: supabaseClient);
    _userProfileService = UserProfileService(supabaseClient: supabaseClient);
    _locationService = LocationService();

    // Load data
    _loadUserInfo();
    _loadSalons();
    _initializeLocation();
    _updateGreeting();

    // Listen to location status changes
    _locationService.locationStatusStream.listen((isEnabled) {
      setState(() {
        _isLocationEnabled = isEnabled;
      });

      // If location was just enabled, update the location display
      if (isEnabled) {
        _updateLocationDisplay();
      }
    });

    // Listen to location updates
    _locationService.locationStream.listen((position) {
      _updateLocationDisplay();
    });

    // Ensure proper status bar visibility with white background
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  // Load user information if logged in
  Future<void> _loadUserInfo() async {
    _isLoggedIn = _userProfileService.isUserLoggedIn();
    if (_isLoggedIn) {
      _userName = _userProfileService.getUserName();
    }
    setState(() {});
  }

  // Initialize location service and get current location
  Future<void> _initializeLocation() async {
    // First try to get the last saved location
    final savedLocation = await _locationService.getLastSavedLocation();
    setState(() {
      _currentStreet = savedLocation['street'] as String;
      _isLocationEnabled = savedLocation['isLocationEnabled'] as bool;
    });

    // Initialize location service (starts listening in background)
    await _locationService.initialize();

    // Force immediate location update if location is enabled
    if (_isLocationEnabled) {
      // Get current location with high accuracy
      final position = await _locationService.getCurrentLocation(
        requestPermission: true,
      );
      if (position != null) {
        // Update UI immediately
        _updateLocationDisplay();
      }
    }
  }

  // Update location display based on latest data
  Future<void> _updateLocationDisplay() async {
    final savedLocation = await _locationService.getLastSavedLocation();

    // Only update if we have valid data
    if (savedLocation['street'] != null) {
      setState(() {
        _currentStreet = savedLocation['street'] as String;
        _isLocationEnabled = savedLocation['isLocationEnabled'] as bool;
      });

      // Debug info would go here in development
      // We would use a proper logging framework in production
    }
  }

  // Update greeting based on time of day
  void _updateGreeting() {
    final hour = DateTime.now().hour;

    String greeting;
    if (hour >= 5 && hour < 12) {
      greeting = 'Доброе утро';
    } else if (hour >= 12 && hour < 17) {
      greeting = 'Добрый день';
    } else if (hour >= 17 && hour < 21) {
      greeting = 'Добрый вечер';
    } else {
      greeting = 'Спокойной ночи';
    }

    setState(() {
      _greeting = greeting;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // Note: We don't dispose LocationService here because it's a singleton
    // and should continue running in the background
    super.dispose();
  }

  Future<void> _loadSalons() async {
    try {
      final salons = await _salonRepository.getSalons();
      setState(() {
        _salons = salons;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Xatolik yuz berdi: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildCustomScrollView(),
    );
  }

  Widget _buildCustomScrollView() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          elevation: 0,
          backgroundColor: Colors.white,
          expandedHeight: 160,
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isLoggedIn && _userName != null
                                ? '$_greeting, $_userName'
                                : _greeting,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Stack(
                                children: [
                                  Icon(
                                    Iconsax.location,
                                    size: 16,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  if (!_isLocationEnabled)
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.close,
                                            size: 6,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _currentStreet,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Iconsax.notification, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Find barbers, stylists, or services',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Iconsax.search_normal,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Promotion banner
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    color: const Color(0xFF1D2951),
                    child: Stack(
                      children: [
                        Positioned(
                          right: 0,
                          bottom: 0,
                          top: 0,
                          child: Image.network(
                            'https://i.ibb.co/DpLx5F9/barber.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '30% OFF',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'First Visit',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const Text(
                  'Eng mashhur salonlar',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _salons.length,
                    itemBuilder: (context, index) {
                      final salon = _salons[index];
                      return _buildSalonCard(salon);
                    },
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Mashhur xizmatlar',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildPopularServices(),
                const SizedBox(height: 24),
                const Text(
                  'Yaqin atrofdagi salonlar',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _salons.length,
                  itemBuilder: (context, index) {
                    final salon = _salons[index];
                    return _buildSalonListItem(salon);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSalonCard(SalonModel salon) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(51), // 0.2 * 255 = 51
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: Colors.grey.shade300,
                width: double.infinity,
                child: const Center(
                  child: Icon(Icons.spa, size: 40, color: Colors.pink),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salon.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(salon.rating.toString()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalonListItem(SalonModel salon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(Icons.spa, size: 30, color: Colors.pink),
          ),
        ),
        title: Text(
          salon.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(salon.address),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text('${salon.rating} • ${salon.services.first}'),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to salon details
        },
      ),
    );
  }

  Widget _buildPopularServices() {
    final services = [
      {'name': 'Soch kesish', 'icon': Icons.content_cut},
      {'name': 'Manikur', 'icon': Icons.spa},
      {'name': 'Makiyaj', 'icon': Icons.face},
      {'name': 'Massaj', 'icon': Icons.airline_seat_flat},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.pink.shade100,
                  child: Icon(service['icon'] as IconData, color: Colors.pink),
                ),
                const SizedBox(height: 8),
                Text(
                  service['name'] as String,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
