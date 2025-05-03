import 'dart:async';
import 'package:flutter/foundation.dart';
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

  // Coordinates of Uzbekistan's bounding box (approximate)
  final Map<String, double> _uzbekistanBounds = {
    'minLat': 37.1821, // Southernmost point
    'maxLat': 45.5886, // Northernmost point
    'minLng': 55.9966, // Westernmost point
    'maxLng': 73.1322, // Easternmost point
  };

  // Initialize location service
  Future<void> initialize() async {
    // Check current status
    _checkLocationServiceStatus();

    // Start listening to service status changes
    _listenToServiceStatusChanges();

    // Start location updates if possible
    await startLocationUpdates(requestPermission: false);
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
    // Check if location services are enabled
    bool serviceEnabled = await _checkLocationServiceStatus();
    if (!serviceEnabled) {
      return null;
    }

    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied && requestPermission) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    } else if (permission == LocationPermission.denied && !requestPermission) {
      return null;
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    // Get the current position with high accuracy
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );

      // Save and broadcast the position
      _locationController.add(position);
      await _saveLocationToPrefs(position);
      return position;
    } catch (e) {
      // If high accuracy fails or times out, try with lower accuracy
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        );

        // Save and broadcast the position
        _locationController.add(position);
        await _saveLocationToPrefs(position);
        return position;
      } catch (e) {
        // Silently handle error
        return null;
      }
    }
  }

  // Start listening to location changes
  Future<void> startLocationUpdates({bool requestPermission = true}) async {
    // Cancel any existing subscription
    await _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;

    // Check if location services are enabled
    bool serviceEnabled = await _checkLocationServiceStatus();
    if (!serviceEnabled) {
      return;
    }

    // Check permissions first
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied && requestPermission) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    } else if (permission == LocationPermission.denied && !requestPermission) {
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Listen to location changes with medium accuracy
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 100, // Update every 100m
        timeLimit: Duration(seconds: 30), // Timeout for getting location
      ),
    ).listen(
      (Position position) {
        _locationController.add(position);
        _saveLocationToPrefs(position);
      },
      onError: (error) {
        // If there's an error, try with lower accuracy
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
            distanceFilter: 200, // Update every 200m
          ),
        ).listen((Position position) {
          _locationController.add(position);
          _saveLocationToPrefs(position);
        });
      },
    );
  }

  // Get street address from coordinates using geocoding
  Future<Map<String, String>> _getAddressFromCoordinates(
    Position position,
  ) async {
    try {
      // Check if position is within Uzbekistan bounds
      if (position.latitude >= _uzbekistanBounds['minLat']! &&
          position.latitude <= _uzbekistanBounds['maxLat']! &&
          position.longitude >= _uzbekistanBounds['minLng']! &&
          position.longitude <= _uzbekistanBounds['maxLng']!) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;

          // Get street name - try multiple fields
          String street = '';

          // First try street
          if (place.street != null && place.street!.isNotEmpty) {
            street = place.street!;
          }
          // Then try thoroughfare (main road)
          else if (place.thoroughfare != null &&
              place.thoroughfare!.isNotEmpty) {
            street = place.thoroughfare!;
          }
          // Then try subThoroughfare (street number)
          else if (place.subThoroughfare != null &&
              place.subThoroughfare!.isNotEmpty) {
            street = place.subThoroughfare!;
          }

          // If we still don't have a street name, create one from the coordinates
          if (street.isEmpty) {
            // Format coordinates to 4 decimal places for readability
            final lat = position.latitude.toStringAsFixed(4);
            final lng = position.longitude.toStringAsFixed(4);
            street = 'Точка $lat, $lng';
          }

          // Get full address
          String address = '';

          // Build a comprehensive address
          List<String> addressParts = [];

          if (place.name != null && place.name!.isNotEmpty) {
            addressParts.add(place.name!);
          }
          if (place.street != null && place.street!.isNotEmpty) {
            addressParts.add(place.street!);
          }
          if (place.subLocality != null && place.subLocality!.isNotEmpty) {
            addressParts.add(place.subLocality!);
          }
          if (place.locality != null && place.locality!.isNotEmpty) {
            addressParts.add(place.locality!);
          }
          if (place.subAdministrativeArea != null &&
              place.subAdministrativeArea!.isNotEmpty) {
            addressParts.add(place.subAdministrativeArea!);
          }
          if (place.administrativeArea != null &&
              place.administrativeArea!.isNotEmpty) {
            addressParts.add(place.administrativeArea!);
          }

          // Join all parts with commas
          address = addressParts.join(', ');

          // If address is still empty, use the street name
          if (address.isEmpty) {
            address = street;
          }

          return {'street': street, 'address': address};
        }
      }
    } catch (e) {
      // Handle error silently and return default values
    }

    // Default values if geocoding fails or position is outside Uzbekistan
    return {'street': 'улица Навои', 'address': 'Ташкент, Узбекистан'};
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
      addressInfo['street'] ?? 'улица Навои',
    );
    await prefs.setString(
      _locationAddressKey,
      addressInfo['address'] ?? 'Ташкент, Узбекистан',
    );
  }

  // Get the last saved location
  Future<Map<String, dynamic>> getLastSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final latitude = prefs.getDouble(_locationLatKey);
    final longitude = prefs.getDouble(_locationLongKey);
    final city = prefs.getString(_locationCityKey) ?? 'Ташкент';
    final street = prefs.getString(_locationStreetKey) ?? 'улица Навои';
    final address =
        prefs.getString(_locationAddressKey) ?? 'Ташкент, Узбекистан';
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
      // Check if position is within Uzbekistan bounds
      if (position.latitude >= _uzbekistanBounds['minLat']! &&
          position.latitude <= _uzbekistanBounds['maxLat']! &&
          position.longitude >= _uzbekistanBounds['minLng']! &&
          position.longitude <= _uzbekistanBounds['maxLng']!) {
        // Use geocoding to get the city name
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;

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

          if (city.isNotEmpty) {
            return city;
          }
        }
      }
    } catch (e) {
      // Handle error silently
    }

    // Default to Tashkent if geocoding fails or position is outside Uzbekistan
    return 'Ташкент';
  }

  // Dispose resources
  void dispose() {
    _positionStreamSubscription?.cancel();
    _serviceStatusSubscription?.cancel();
    _locationController.close();
    _locationStatusController.close();
  }
}
