import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:looksy_client/features/home/data/salon_repository.dart';
import 'package:looksy_client/features/home/models/salon_model.dart';
import 'package:looksy_client/features/location/services/location_service.dart';
import 'package:looksy_client/features/profile/services/user_profile_service.dart';
import 'package:looksy_client/features/services/presentation/all_services_page.dart';
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
                                    color: const Color(0xFF000080), // Navy blue
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
                                  color: Color(0xFF000080), // Navy blue
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Iconsax.notification,
                          color: const Color(0xFF000080),
                        ),
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
                          color: const Color(0xFF000080),
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
                    color: const Color(0xFF000080), // Navy blue
                    child: Stack(
                      children: [
                        Positioned(
                          right: 0,
                          bottom: 0,
                          top: 0,
                          child: Image.asset(
                            'assets/images/barber_placeholder.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 120,
                                color: Colors.grey.shade300,
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '30% CHEGIRMA',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Birinchi tashrif uchun',
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
                // Services categories
                const Text(
                  'Servislar',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildServiceCategory('Soch', Icons.content_cut, () {
                        // Navigate to hair services
                      }),
                      _buildServiceCategory('Massaj', Icons.spa, () {
                        // Navigate to massage services
                      }),
                      _buildServiceCategory('Tirnoq', Icons.brush, () {
                        // Navigate to nail services
                      }),
                      _buildServiceCategory('Boshqa', Icons.more_horiz, () {
                        // Navigate to all services screen
                        _navigateToAllServices();
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Top Rated Salons',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 320, // Balandlikni yanada oshiramiz
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ), // Vertical padding qo'shamiz
                    itemCount: _salons.length,
                    itemBuilder: (context, index) {
                      final salon = _salons[index];
                      return _buildModernSalonCard(salon);
                    },
                  ),
                ),
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

  Widget _buildModernSalonCard(SalonModel salon) {
    return GestureDetector(
      onTap: () {
        // Navigate to salon details
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 20, bottom: 10, top: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25), // Soyani kuchaytirdik
              spreadRadius: 0,
              blurRadius: 3,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with rounded corners only at the top
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: SizedBox(
                    height: 160,
                    width: double.infinity,
                    child:
                        salon.imageUrl.isNotEmpty
                            ? Image.network(
                              salon.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: Center(
                                    child: Icon(
                                      Icons.spa,
                                      size: 40,
                                      color: const Color(0xFF000080),
                                    ),
                                  ),
                                );
                              },
                            )
                            : Container(
                              color: Colors.grey.shade200,
                              child: Center(
                                child: Icon(
                                  Icons.spa,
                                  size: 40,
                                  color: const Color(0xFF000080),
                                ),
                              ),
                            ),
                  ),
                ),
                // Add a favorite button overlay
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26), // 0.1 * 255 = ~26
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      size: 18,
                      color: const Color(0xFF000080),
                    ),
                  ),
                ),
                // Rating badge
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26), // 0.1 * 255 = ~26
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Color(0xFFFFD700),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          salon.rating.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Salon name
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 2),
              child: Text(
                salon.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: -0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Services tags
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: SizedBox(
                height: 24, // Aniq balandlik beramiz
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                      salon.services.take(2).map((service) {
                        return Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6E6F2), // Light navy blue
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            service,
                            style: const TextStyle(
                              color: Color(0xFF000080), // Navy blue
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),

            // Location with icon
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: const Color(0xFF000080),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      salon.address.split(',').first,
                      style: TextStyle(
                        color: const Color(0xFF000080),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
            child: Icon(Icons.spa, size: 30, color: Color(0xFF000080)),
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
                const Icon(Icons.star, size: 16, color: Color(0xFF000080)),
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

  Widget _buildServiceCategory(String name, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFE6E6F2), // Light navy blue
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF000080), size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _navigateToAllServices() {
    // Navigate to the AllServicesPage
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AllServicesPage()));
  }
}
