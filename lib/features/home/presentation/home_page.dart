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
                          const SizedBox(height: 2),
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
                  const SizedBox(height: 16),
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
                const SizedBox(height: 16),

                // Promotion banner
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF000080), // Navy blue
                        Color(0xFF3333A0), // Lighter navy blue
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF000080).withAlpha(40),
                        blurRadius: 12,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Decorative circles
                      Positioned(
                        top: -20,
                        right: -20,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withAlpha(15),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -40,
                        left: -10,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withAlpha(10),
                          ),
                        ),
                      ),
                      // Image
                      Positioned(
                        right: 0,
                        bottom: 0,
                        top: 0,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: Image.asset(
                            'assets/images/barber_placeholder.jpg',
                            width: 160,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 160,
                                color: const Color(0xFF3333A0),
                                child: const Center(
                                  child: Icon(
                                    Icons.content_cut,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(30),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'MAXSUS TAKLIF',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              '30% CHEGIRMA',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Birinchi tashrif uchun',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Hoziroq band qiling',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF000080),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Services categories
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Xizmatlar',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to all services
                          _navigateToAllServices();
                        },
                        child: const Text(
                          'Barchasi',
                          style: TextStyle(
                            color: Color(0xFF000080),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
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

                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Top Sartaroshlar',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to all top barbers
                        },
                        child: const Text(
                          'Barchasi',
                          style: TextStyle(
                            color: Color(0xFF000080),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Yaqin atrofdagi sartaroshlar',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to all nearby barbers
                        },
                        child: const Text(
                          'Barchasi',
                          style: TextStyle(
                            color: Color(0xFF000080),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      _salons.length > 10
                          ? 10
                          : _salons.length, // Maksimum 10 ta sartarosh
                  itemBuilder: (context, index) {
                    final salon = _salons[index];
                    return _buildSalonListItem(salon);
                  },
                ),

                // Foydali ma'lumotlar bo'limi
                const SizedBox(height: 24),
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Foydali ma\'lumotlar',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to all articles
                        },
                        child: const Text(
                          'Barchasi',
                          style: TextStyle(
                            color: Color(0xFF000080),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildArticlesList(),
                const SizedBox(height: 24),
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
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 2),
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
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 2),
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
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Navigate to salon details
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Salon image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade200,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child:
                        salon.imageUrl.isNotEmpty
                            ? Image.network(
                              salon.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.content_cut,
                                    size: 30,
                                    color: const Color(0xFF000080),
                                  ),
                                );
                              },
                            )
                            : Center(
                              child: Icon(
                                Icons.content_cut,
                                size: 30,
                                color: const Color(0xFF000080),
                              ),
                            ),
                  ),
                  const SizedBox(width: 16),
                  // Salon info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Salon name
                        Text(
                          salon.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Rating
                        Row(
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
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "(${(salon.rating * 20).toInt()})",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6E6F2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                salon.services.first,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF000080),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Address
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                salon.address,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Distance and time
                        Row(
                          children: [
                            Icon(
                              Icons.directions_walk_outlined,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${(salon.rating * 0.5).toStringAsFixed(1)} km • 10 daqiqa',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Arrow icon
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
        ),
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
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000080).withAlpha(15),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: const Color(0xFF000080), size: 28),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF000080),
            ),
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

  // Foydali ma'lumotlar ro'yxatini yaratish
  Widget _buildArticlesList() {
    // Maqolalar uchun ma'lumotlar
    final articles = [
      {
        'title': 'Sochlarni to\'g\'ri parvarish qilish usullari',
        'image': 'https://example.com/hair_care.jpg',
        'category': 'Soch parvarishi',
        'readTime': '5 daqiqa',
      },
      {
        'title': 'Yuz terisi uchun tabiiy niqoblar',
        'image': 'https://example.com/face_masks.jpg',
        'category': 'Yuz parvarishi',
        'readTime': '7 daqiqa',
      },
      {
        'title': 'Erkaklar uchun soqol parvarishi bo\'yicha maslahatlar',
        'image': 'https://example.com/beard_care.jpg',
        'category': 'Soqol parvarishi',
        'readTime': '4 daqiqa',
      },
      {
        'title': 'Sog\'lom sochlar uchun ovqatlanish rejasi',
        'image': 'https://example.com/hair_nutrition.jpg',
        'category': 'Soch parvarishi',
        'readTime': '6 daqiqa',
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return _buildArticleItem(
          title: article['title'] ?? '',
          imageUrl: article['image'] ?? '',
          category: article['category'] ?? '',
          readTime: article['readTime'] ?? '',
        );
      },
    );
  }

  // Maqola elementi
  Widget _buildArticleItem({
    required String title,
    required String imageUrl,
    required String category,
    required String readTime,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Navigate to article details
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Article image
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(color: Colors.grey.shade200),
                  child:
                      imageUrl.isNotEmpty
                          ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.article,
                                  size: 30,
                                  color: const Color(0xFF000080),
                                ),
                              );
                            },
                          )
                          : Center(
                            child: Icon(
                              Icons.article,
                              size: 30,
                              color: const Color(0xFF000080),
                            ),
                          ),
                ),
                // Article info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category and read time
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6E6F2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                category,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF000080),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.access_time,
                              size: 12,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              readTime,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Title
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            height: 1.3,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Read more button
                        Row(
                          children: [
                            Text(
                              'Batafsil',
                              style: TextStyle(
                                color: const Color(0xFF000080),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward,
                              size: 12,
                              color: const Color(0xFF000080),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
