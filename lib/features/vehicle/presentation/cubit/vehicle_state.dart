part of 'vehicle_cubit.dart';

abstract class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleLoadingMore extends VehicleState {
  final List<Vehicle> vehicles;

  const VehicleLoadingMore({required this.vehicles});

  @override
  List<Object?> get props => [vehicles];
}

class VehicleLoaded extends VehicleState {
  final List<Vehicle> vehicles;
  final bool hasReachedMax;
  final String? error;

  const VehicleLoaded({
    required this.vehicles,
    required this.hasReachedMax,
    this.error,
  });

  @override
  List<Object?> get props => [vehicles, hasReachedMax, error];
}

class VehicleError extends VehicleState {
  final String message;

  const VehicleError({required this.message});

  @override
  List<Object?> get props => [message];
}

class VehicleActionLoading extends VehicleState {}

class VehicleActionSuccess extends VehicleState {
  final String message;

  const VehicleActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class VehicleActionError extends VehicleState {
  final String message;

  const VehicleActionError({required this.message});

  @override
  List<Object?> get props => [message];
}
