part of 'vehicle_cubit.dart';

sealed class VehicleState extends Equatable {
  const VehicleState();
}

final class VehicleInitial extends VehicleState {
  @override
  List<Object> get props => [];
}
