import 'package:dartz/dartz.dart';
import '../entities/vehicle.dart';
import '../../../../core/errors/failures.dart';

abstract class VehicleRepository {
  Future<Either<Failure, List<Vehicle>>> getVehicles({
    int page = 1,
    int limit = 10,
  });
  Future<Either<Failure, Vehicle>> createVehicle(
    Map<String, dynamic> vehicleData,
  );
  Future<Either<Failure, Vehicle>> updateVehicle(
    String id,
    Map<String, dynamic> vehicleData,
  );
  Future<Either<Failure, void>> deleteVehicle(String id);
}
