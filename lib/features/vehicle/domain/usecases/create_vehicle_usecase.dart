import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/vehicle.dart';
import '../repositories/vehicle_repository.dart';

class CreateVehicleUseCase implements UseCase<Vehicle, CreateVehicleParams> {
  final VehicleRepository repository;

  CreateVehicleUseCase(this.repository);

  @override
  Future<Either<Failure, Vehicle>> call(CreateVehicleParams params) async {
    return await repository.createVehicle(params.vehicleData);
  }
}

class CreateVehicleParams extends Equatable {
  final Map<String, dynamic> vehicleData;

  const CreateVehicleParams({required this.vehicleData});

  @override
  List<Object> get props => [vehicleData];
}

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
