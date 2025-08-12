import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/vehicle_repository.dart';

class DeleteVehicleUseCase implements UseCase<void, DeleteVehicleParams> {
  final VehicleRepository repository;

  DeleteVehicleUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteVehicleParams params) async {
    return await repository.deleteVehicle(params.id);
  }
}

class DeleteVehicleParams extends Equatable {
  final String id;

  const DeleteVehicleParams({required this.id});

  @override
  List<Object> get props => [id];
}

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
