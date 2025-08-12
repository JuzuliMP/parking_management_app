import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/usecases/get_vehicles_usecase.dart';
import '../../domain/usecases/create_vehicle_usecase.dart';
import '../../domain/usecases/update_vehicle_usecase.dart';
import '../../domain/usecases/delete_vehicle_usecase.dart';
import '../../../../core/errors/failures.dart';

part 'vehicle_state.dart';

class VehicleCubit extends Cubit<VehicleState> {
  final GetVehiclesUseCase getVehiclesUseCase;
  final CreateVehicleUseCase createVehicleUseCase;
  final UpdateVehicleUseCase updateVehicleUseCase;
  final DeleteVehicleUseCase deleteVehicleUseCase;

  VehicleCubit({
    required this.getVehiclesUseCase,
    required this.createVehicleUseCase,
    required this.updateVehicleUseCase,
    required this.deleteVehicleUseCase,
  }) : super(VehicleInitial());

  Future<void> getVehicles({int page = 1, bool refresh = false}) async {
    if (refresh) {
      emit(VehicleLoading());
    } else if (state is VehicleLoaded) {
      final currentState = state as VehicleLoaded;
      emit(VehicleLoadingMore(vehicles: currentState.vehicles));
    } else {
      emit(VehicleLoading());
    }

    final result = await getVehiclesUseCase(
      GetVehiclesParams(page: page, limit: 10),
    );

    result.fold(
      (failure) {
        if (state is VehicleLoadingMore) {
          final currentState = state as VehicleLoadingMore;
          emit(
            VehicleLoaded(
              vehicles: currentState.vehicles,
              hasReachedMax: true,
              error: _getErrorMessage(failure),
            ),
          );
        } else {
          emit(VehicleError(message: _getErrorMessage(failure)));
        }
      },
      (vehicles) {
        if (state is VehicleLoadingMore) {
          final currentState = state as VehicleLoadingMore;
          final allVehicles = [...currentState.vehicles, ...vehicles];
          emit(
            VehicleLoaded(
              vehicles: allVehicles,
              hasReachedMax: vehicles.isEmpty,
            ),
          );
        } else {
          emit(
            VehicleLoaded(vehicles: vehicles, hasReachedMax: vehicles.isEmpty),
          );
        }
      },
    );
  }

  Future<void> createVehicle(Map<String, dynamic> vehicleData) async {
    emit(VehicleActionLoading());

    final result = await createVehicleUseCase(
      CreateVehicleParams(vehicleData: vehicleData),
    );

    result.fold(
      (failure) {
        emit(VehicleActionError(message: _getErrorMessage(failure)));
      },
      (vehicle) {
        emit(VehicleActionSuccess(message: 'Vehicle created successfully'));
        // Refresh the list
        getVehicles(page: 1, refresh: true);
      },
    );
  }

  Future<void> updateVehicle(
    String id,
    Map<String, dynamic> vehicleData,
  ) async {
    emit(VehicleActionLoading());

    final result = await updateVehicleUseCase(
      UpdateVehicleParams(id: id, vehicleData: vehicleData),
    );

    result.fold(
      (failure) {
        emit(VehicleActionError(message: _getErrorMessage(failure)));
      },
      (vehicle) {
        emit(VehicleActionSuccess(message: 'Vehicle updated successfully'));
        // Refresh the list
        getVehicles(page: 1, refresh: true);
      },
    );
  }

  Future<void> deleteVehicle(String id) async {
    emit(VehicleActionLoading());

    final result = await deleteVehicleUseCase(DeleteVehicleParams(id: id));

    result.fold(
      (failure) {
        emit(VehicleActionError(message: _getErrorMessage(failure)));
      },
      (_) {
        emit(VehicleActionSuccess(message: 'Vehicle deleted successfully'));
        // Refresh the list
        getVehicles(page: 1, refresh: true);
      },
    );
  }

  String _getErrorMessage(Failure failure) {
    if (failure is AuthFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return failure.message;
    } else if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is ValidationFailure) {
      return failure.message;
    } else {
      return 'An unexpected error occurred';
    }
  }

  void resetActionState() {
    if (state is VehicleActionSuccess || state is VehicleActionError) {
      if (state is VehicleLoaded) {
        final currentState = state as VehicleLoaded;
        emit(
          VehicleLoaded(
            vehicles: currentState.vehicles,
            hasReachedMax: currentState.hasReachedMax,
          ),
        );
      } else {
        emit(VehicleInitial());
      }
    }
  }
}
