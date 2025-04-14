import 'package:equatable/equatable.dart';

enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled,
}

class BookingModel extends Equatable {
  final String id;
  final String userId;
  final String salonId;
  final String salonName;
  final String serviceId;
  final String serviceName;
  final DateTime dateTime;
  final BookingStatus status;
  final double price;
  
  const BookingModel({
    required this.id,
    required this.userId,
    required this.salonId,
    required this.salonName,
    required this.serviceId,
    required this.serviceName,
    required this.dateTime,
    required this.status,
    required this.price,
  });
  
  @override
  List<Object?> get props => [
    id, 
    userId, 
    salonId, 
    salonName, 
    serviceId, 
    serviceName, 
    dateTime, 
    status, 
    price
  ];
  
  // Factory method to create a BookingModel from a JSON map
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      salonId: json['salon_id'] as String,
      salonName: json['salon_name'] as String,
      serviceId: json['service_id'] as String,
      serviceName: json['service_name'] as String,
      dateTime: DateTime.parse(json['date_time'] as String),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString() == 'BookingStatus.${json['status']}',
        orElse: () => BookingStatus.pending,
      ),
      price: (json['price'] as num).toDouble(),
    );
  }
  
  // Method to convert a BookingModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'salon_id': salonId,
      'salon_name': salonName,
      'service_id': serviceId,
      'service_name': serviceName,
      'date_time': dateTime.toIso8601String(),
      'status': status.toString().split('.').last,
      'price': price,
    };
  }
}
