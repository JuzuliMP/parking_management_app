import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'vehicle_state.dart';

class VehicleCubit extends Cubit<VehicleState> {
  VehicleCubit() : super(VehicleInitial());
}
