import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum ServiceCategory {
  hair,
  massage,
  nails,
  other,
}

class ServiceModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String duration;
  final ServiceCategory category;
  final IconData icon;
  
  const ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.category,
    required this.icon,
  });
  
  @override
  List<Object?> get props => [id, name, description, price, duration, category, icon];
  
  // Factory method to create a ServiceModel from a JSON map
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      duration: json['duration'] as String,
      category: ServiceCategory.values.firstWhere(
        (e) => e.toString() == 'ServiceCategory.${json['category']}',
        orElse: () => ServiceCategory.other,
      ),
      icon: IconData(json['icon_code'] as int, fontFamily: 'MaterialIcons'),
    );
  }
  
  // Method to convert a ServiceModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'category': category.toString().split('.').last,
      'icon_code': icon.codePoint,
    };
  }
}
