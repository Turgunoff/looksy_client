import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  // Singleton pattern
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  // Stream controller for location updates
  final _locationController = StreamController<Position>.broadcast();
  Stream<Position> get locationStream => _locationController.stream;

  // Stream controller for location service status
  final _locationStatusController = StreamController<bool>.broadcast();
  Stream<bool> get locationStatusStream => _locationStatusController.stream;

  // Current location status
  bool _isLocationEnabled = false;
  bool get isLocationEnabled => _isLocationEnabled;

  // StreamSubscription for location updates
  StreamSubscription<Position>? _positionStreamSubscription;

  // StreamSubscription for service status updates
  StreamSubscription<ServiceStatus>? _serviceStatusSubscription;

  // Location storage keys
  static const String _locationLatKey = 'location_latitude';
  static const String _locationLongKey = 'location_longitude';
  static const String _locationCityKey = 'location_city';
  static const String _locationStreetKey = 'location_street';
  static const String _locationAddressKey = 'location_address';
  static const String _locationTimestampKey = 'location_timestamp';

  // Initialize location service
  Future<void> initialize() async {
    try {
      print('Initializing location service...');

      // Check current status
      bool serviceEnabled = await _checkLocationServiceStatus();
      print('Location service enabled: $serviceEnabled');

      // Start listening to service status changes
      _listenToServiceStatusChanges();

      // Request permissions explicitly
      LocationPermission permission = await Geolocator.checkPermission();
      print('Initial permission status: $permission');

      if (permission == LocationPermission.denied) {
        print('Requesting location permission...');
        permission = await Geolocator.requestPermission();
        print('Permission after request: $permission');
      }

      // Start location updates if possible
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        print('Starting location updates...');
        await startLocationUpdates(requestPermission: false);
      } else {
        print('Location permission not granted: $permission');
      }
    } catch (e) {
      print('Error initializing location service: $e');
    }
  }

  // Check if location services are enabled
  Future<bool> _checkLocationServiceStatus() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    _isLocationEnabled = serviceEnabled;
    _locationStatusController.add(serviceEnabled);
    return serviceEnabled;
  }

  // Listen to location service status changes
  void _listenToServiceStatusChanges() {
    _serviceStatusSubscription = Geolocator.getServiceStatusStream().listen((
      ServiceStatus status,
    ) {
      bool isEnabled = (status == ServiceStatus.enabled);
      _isLocationEnabled = isEnabled;
      _locationStatusController.add(isEnabled);

      // If location service was just enabled, start updates
      if (isEnabled) {
        startLocationUpdates(requestPermission: false);
      } else {
        // If disabled, cancel the subscription
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }
    });
  }

  // Get the current location
  Future<Position?> getCurrentLocation({bool requestPermission = true}) async {
    try {
      print('Getting current location...');

      // Check if location services are enabled
      bool serviceEnabled = await _checkLocationServiceStatus();
      print('Location service enabled: $serviceEnabled');

      if (!serviceEnabled) {
        print('Location services are disabled');
        return null;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      print('Current permission status: $permission');

      if (permission == LocationPermission.denied && requestPermission) {
        print('Requesting location permission...');
        permission = await Geolocator.requestPermission();
        print('Permission after request: $permission');

        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        return null;
      }

      print('Getting current position with high accuracy...');
      // Get the current position with high accuracy
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 30), // Increased timeout
        );

        print(
          'Successfully got position: ${position.latitude}, ${position.longitude}',
        );
        // Save and broadcast the position
        _locationController.add(position);
        await _saveLocationToPrefs(position);
        return position;
      } catch (e) {
        print('Error getting high accuracy position: $e');
        print('Trying with low accuracy...');

        // If high accuracy fails, try with lower accuracy
        try {
          final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
            timeLimit: const Duration(seconds: 30), // Increased timeout
          );

          print(
            'Successfully got position with low accuracy: ${position.latitude}, ${position.longitude}',
          );
          // Save and broadcast the position
          _locationController.add(position);
          await _saveLocationToPrefs(position);
          return position;
        } catch (e) {
          print('Error getting low accuracy position: $e');
          // Try one last time with lowest accuracy
          try {
            final position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.lowest,
              timeLimit: const Duration(seconds: 30), // Increased timeout
            );
            print(
              'Successfully got position with lowest accuracy: ${position.latitude}, ${position.longitude}',
            );
            _locationController.add(position);
            await _saveLocationToPrefs(position);
            return position;
          } catch (e) {
            print('Error getting lowest accuracy position: $e');
            return null;
          }
        }
      }
    } catch (e) {
      print('Error in getCurrentLocation: $e');
      return null;
    }
  }

  // Start listening to location changes
  Future<void> startLocationUpdates({bool requestPermission = true}) async {
    try {
      print('Starting location updates...');

      // Cancel any existing subscription
      await _positionStreamSubscription?.cancel();
      _positionStreamSubscription = null;

      // Check if location services are enabled
      bool serviceEnabled = await _checkLocationServiceStatus();
      print('Location service enabled: $serviceEnabled');

      if (!serviceEnabled) {
        print('Location services are disabled');
        return;
      }

      // Check permissions first
      LocationPermission permission = await Geolocator.checkPermission();
      print('Current permission status: $permission');

      if (permission == LocationPermission.denied && requestPermission) {
        print('Requesting location permission...');
        permission = await Geolocator.requestPermission();
        print('Permission after request: $permission');

        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return;
        }
      } else if (permission == LocationPermission.denied &&
          !requestPermission) {
        print('Location permissions are denied and not requesting');
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        return;
      }

      print('Starting position stream...');

      // First try to get current position
      try {
        print('Attempting to get initial position...');
        final initialPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 30), // Increased timeout
        );
        print(
          'Got initial position: ${initialPosition.latitude}, ${initialPosition.longitude}',
        );
        _locationController.add(initialPosition);
        await _saveLocationToPrefs(initialPosition);
      } catch (e) {
        print('Error getting initial position: $e');
        // Try with lower accuracy if high accuracy fails
        try {
          final initialPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
            timeLimit: const Duration(seconds: 30),
          );
          print(
            'Got initial position with low accuracy: ${initialPosition.latitude}, ${initialPosition.longitude}',
          );
          _locationController.add(initialPosition);
          await _saveLocationToPrefs(initialPosition);
        } catch (e) {
          print('Error getting initial position with low accuracy: $e');
        }
      }

      // Start listening to location updates
      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10, // Update every 10 meters
          timeLimit: Duration(seconds: 30), // Increased timeout
        ),
      ).listen(
        (Position position) {
          print(
            'Received location update: ${position.latitude}, ${position.longitude}',
          );
          _locationController.add(position);
          _saveLocationToPrefs(position);
        },
        onError: (error) {
          print('Error getting location updates: $error');
          // Try to restart location updates after a delay
          Future.delayed(const Duration(seconds: 5), () {
            print('Attempting to restart location updates...');
            startLocationUpdates(requestPermission: false);
          });
        },
        cancelOnError: false, // Don't cancel on error
      );
      print('Position stream started successfully');
    } catch (e) {
      print('Error starting location updates: $e');
      // Try to restart after a delay
      Future.delayed(const Duration(seconds: 5), () {
        print('Attempting to restart location service after error...');
        startLocationUpdates(requestPermission: false);
      });
    }
  }

  // Get street address from coordinates using geocoding
  Future<Map<String, String>> _getAddressFromCoordinates(
    Position position,
  ) async {
    try {
      print(
        'Getting address for coordinates: ${position.latitude}, ${position.longitude}',
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        print('Got placemark: ${place.toJson()}');

        // Get street name - try multiple fields
        String street = '';

        // First try thoroughfare (main road)
        if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) {
          street = place.thoroughfare!;
        }
        // Then try subLocality (district/neighborhood)
        else if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          street = place.subLocality!;
        }
        // Then try locality (city)
        else if (place.locality != null && place.locality!.isNotEmpty) {
          street = place.locality!;
        }
        // Then try administrativeArea (region/state)
        else if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          street = place.administrativeArea!;
        }
        // Finally try country
        else if (place.country != null && place.country!.isNotEmpty) {
          street = place.country!;
        }

        // If we still don't have a street name, create one from the coordinates
        if (street.isEmpty) {
          street =
              'Location ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
        }

        return {'street': street, 'address': street};
      }
    } catch (e) {
      print('Error getting address from coordinates: $e');
    }

    // Default values if geocoding fails
    return {
      'street':
          'Location ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}',
      'address':
          'Location ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}',
    };
  }

  // Save location to SharedPreferences
  Future<void> _saveLocationToPrefs(Position position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_locationLatKey, position.latitude);
    await prefs.setDouble(_locationLongKey, position.longitude);

    // Save timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt(_locationTimestampKey, timestamp);

    // Get city name from coordinates
    final city = await _getCityFromCoordinates(position);
    await prefs.setString(_locationCityKey, city);

    // Get and save street information
    final addressInfo = await _getAddressFromCoordinates(position);
    await prefs.setString(
      _locationStreetKey,
      addressInfo['street'] ??
          'Location ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}',
    );
    await prefs.setString(
      _locationAddressKey,
      addressInfo['address'] ??
          'Coordinates: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}',
    );
  }

  // Get the last saved location
  Future<Map<String, dynamic>> getLastSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final latitude = prefs.getDouble(_locationLatKey);
    final longitude = prefs.getDouble(_locationLongKey);

    // Format coordinates for display
    final lat = latitude?.toStringAsFixed(4) ?? '0.0000';
    final lng = longitude?.toStringAsFixed(4) ?? '0.0000';

    final city = prefs.getString(_locationCityKey) ?? 'Location $lat, $lng';
    final street = prefs.getString(_locationStreetKey) ?? 'Location $lat, $lng';
    final address =
        prefs.getString(_locationAddressKey) ?? 'Coordinates: $lat, $lng';
    final timestamp = prefs.getInt(_locationTimestampKey) ?? 0;

    // Check if location services are currently enabled
    final isLocationEnabled = await _checkLocationServiceStatus();

    return {
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'street': street,
      'address': address,
      'timestamp': timestamp,
      'isLocationEnabled': isLocationEnabled,
    };
  }

  // Get city name from coordinates
  Future<String> _getCityFromCoordinates(Position position) async {
    try {
      print(
        'Getting city for coordinates: ${position.latitude}, ${position.longitude}',
      );

      // Use geocoding to get the city name
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        print('Got placemark: ${place.toJson()}');

        // Try to get city name from different fields
        String city = '';

        // First try locality (city)
        if (place.locality != null && place.locality!.isNotEmpty) {
          city = place.locality!;
        }
        // Then try subAdministrativeArea (district/region)
        else if (place.subAdministrativeArea != null &&
            place.subAdministrativeArea!.isNotEmpty) {
          city = place.subAdministrativeArea!;
        }
        // Then try administrativeArea (province/region)
        else if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          city = place.administrativeArea!;
        }
        // Then try country
        else if (place.country != null && place.country!.isNotEmpty) {
          city = place.country!;
        }

        if (city.isNotEmpty) {
          print('Returning city: $city');
          return city;
        }
      }
    } catch (e) {
      print('Error getting city from coordinates: $e');
    }

    // Default to coordinates if geocoding fails
    final lat = position.latitude.toStringAsFixed(4);
    final lng = position.longitude.toStringAsFixed(4);
    return 'Location $lat, $lng';
  }

  // Dispose resources
  void dispose() {
    _positionStreamSubscription?.cancel();
    _serviceStatusSubscription?.cancel();
    _locationController.close();
    _locationStatusController.close();
  }
}
