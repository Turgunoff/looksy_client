import 'package:equatable/equatable.dart';

class SalonModel extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final String address;
  final double rating;
  final List<String> services;
  final String description;
  
  const SalonModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.address,
    required this.rating,
    required this.services,
    required this.description,
  });
  
  @override
  List<Object?> get props => [id, name, imageUrl, address, rating, services, description];
  
  // Factory method to create a SalonModel from a JSON map
  factory SalonModel.fromJson(Map<String, dynamic> json) {
    return SalonModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String,
      address: json['address'] as String,
      rating: (json['rating'] as num).toDouble(),
      services: List<String>.from(json['services'] as List),
      description: json['description'] as String,
    );
  }
  
  // Method to convert a SalonModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'address': address,
      'rating': rating,
      'services': services,
      'description': description,
    };
  }
}
