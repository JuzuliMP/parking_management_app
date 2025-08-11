import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_management_app/features/vehicle/presentation/cubit/vehicle_cubit.dart';
import 'package:parking_management_app/shared/theme/app_theme.dart';

import 'core/routing/app_router.dart';
import 'core/storage/storage_service.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service
  await StorageService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<VehicleCubit>(create: (context) => VehicleCubit()),
      ],
      child: MaterialApp.router(
        title: 'Parking Management App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
