import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/vehicle.dart';
import '../repositories/vehicle_repository.dart';

class GetVehiclesUseCase implements UseCase<List<Vehicle>, GetVehiclesParams> {
  final VehicleRepository repository;

  GetVehiclesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Vehicle>>> call(GetVehiclesParams params) async {
    return await repository.getVehicles(page: params.page, limit: params.limit);
  }
}

class GetVehiclesParams extends Equatable {
  final int page;
  final int limit;

  const GetVehiclesParams({required this.page, required this.limit});

  @override
  List<Object> get props => [page, limit];
}

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
