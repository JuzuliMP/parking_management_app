import '../../domain/entities/vehicle.dart';

class VehicleModel extends Vehicle {
  const VehicleModel({
    required super.id,
    required super.name,
    required super.color,
    required super.vehicleNumber,
    required super.modelYear,
    required super.createdAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    // Handle the actual API response structure
    if (json.containsKey('_id') && json.containsKey('_name')) {
      // New API response format
      return VehicleModel(
        id: json['_id']?.toString() ?? '',
        name: json['_name'] ?? '',
        color: json['_color'] ?? '',
        vehicleNumber: json['_number'] ?? '',
        modelYear: int.tryParse(json['_model']?.toString() ?? '') ?? 0,
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['_createdAt'] ?? 0),
      );
    } else {
      // Fallback to old format
      return VehicleModel(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? '',
        color: json['color'] ?? '',
        vehicleNumber: json['vehicle_number'] ?? '',
        modelYear: int.tryParse(json['model_year']?.toString() ?? '') ?? 0,
        createdAt:
            DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'vehicle_number': vehicleNumber,
      'model_year': modelYear,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory VehicleModel.fromEntity(Vehicle vehicle) {
    return VehicleModel(
      id: vehicle.id,
      name: vehicle.name,
      color: vehicle.color,
      vehicleNumber: vehicle.vehicleNumber,
      modelYear: vehicle.modelYear,
      createdAt: vehicle.createdAt,
    );
  }
}
