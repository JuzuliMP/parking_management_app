import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/vehicle/presentation/screens/vehicle_list_screen.dart';
import '../../features/vehicle/presentation/screens/vehicle_create_screen.dart';
import '../../features/vehicle/presentation/screens/vehicle_update_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String vehicleList = '/vehicle-list';
  static const String vehicleCreate = '/vehicle-create';
  static const String vehicleUpdate = '/vehicle-update';

  static GoRouter get router => GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: vehicleList,
        builder: (context, state) => const VehicleListScreen(),
      ),
      GoRoute(
        path: vehicleCreate,
        builder: (context, state) => const VehicleCreateScreen(),
      ),
      GoRoute(
        path: vehicleUpdate,
        builder: (context, state) {
          final vehicle = state.extra as Map<String, dynamic>?;
          return VehicleUpdateScreen(vehicle: vehicle);
        },
      ),
    ],
  );
}
