import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/vehicle.dart';
import '../repositories/vehicle_repository.dart';

class UpdateVehicleUseCase implements UseCase<Vehicle, UpdateVehicleParams> {
  final VehicleRepository repository;

  UpdateVehicleUseCase(this.repository);

  @override
  Future<Either<Failure, Vehicle>> call(UpdateVehicleParams params) async {
    return await repository.updateVehicle(params.id, params.vehicleData);
  }
}

class UpdateVehicleParams extends Equatable {
  final String id;
  final Map<String, dynamic> vehicleData;

  const UpdateVehicleParams({required this.id, required this.vehicleData});

  @override
  List<Object> get props => [id, vehicleData];
}

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
