import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  final String id;
  final String name;
  final String color;
  final String vehicleNumber;
  final int modelYear;
  final DateTime createdAt;

  const Vehicle({
    required this.id,
    required this.name,
    required this.color,
    required this.vehicleNumber,
    required this.modelYear,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    color,
    vehicleNumber,
    modelYear,
    createdAt,
  ];

  Vehicle copyWith({
    String? id,
    String? name,
    String? color,
    String? vehicleNumber,
    int? modelYear,
    DateTime? createdAt,
  }) {
    return Vehicle(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      modelYear: modelYear ?? this.modelYear,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
