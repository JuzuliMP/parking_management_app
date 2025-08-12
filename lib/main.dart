import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_constants.dart';
import 'core/network/dio_client.dart';
import 'core/routing/app_router.dart';
import 'core/storage/storage_service.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/sources/auth_remote_data_source.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/vehicle/data/repositories/vehicle_repository_impl.dart';
import 'features/vehicle/data/sources/vehicle_remote_data_source.dart';
import 'features/vehicle/domain/usecases/create_vehicle_usecase.dart';
import 'features/vehicle/domain/usecases/delete_vehicle_usecase.dart';
import 'features/vehicle/domain/usecases/get_vehicles_usecase.dart';
import 'features/vehicle/domain/usecases/update_vehicle_usecase.dart';
import 'features/vehicle/presentation/cubit/vehicle_cubit.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service
  await StorageService.instance;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StorageService>(
      future: StorageService.instance,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            ),
          );
        }

        final storageService = snapshot.data!;

        return MultiBlocProvider(
          providers: [
            // Auth BLoC
            BlocProvider<AuthCubit>(
              create: (context) => AuthCubit(
                loginUseCase: LoginUseCase(
                  AuthRepositoryImpl(
                    remoteDataSource: AuthRemoteDataSourceImpl(
                      DioClient.instance,
                    ),
                    storageService: storageService,
                  ),
                ),
              ),
            ),

            // Vehicle BLoC
            BlocProvider<VehicleCubit>(
              create: (context) => VehicleCubit(
                getVehiclesUseCase: GetVehiclesUseCase(
                  VehicleRepositoryImpl(
                    remoteDataSource: VehicleRemoteDataSourceImpl(
                      DioClient.instance,
                    ),
                  ),
                ),
                createVehicleUseCase: CreateVehicleUseCase(
                  VehicleRepositoryImpl(
                    remoteDataSource: VehicleRemoteDataSourceImpl(
                      DioClient.instance,
                    ),
                  ),
                ),
                updateVehicleUseCase: UpdateVehicleUseCase(
                  VehicleRepositoryImpl(
                    remoteDataSource: VehicleRemoteDataSourceImpl(
                      DioClient.instance,
                    ),
                  ),
                ),
                deleteVehicleUseCase: DeleteVehicleUseCase(
                  VehicleRepositoryImpl(
                    remoteDataSource: VehicleRemoteDataSourceImpl(
                      DioClient.instance,
                    ),
                  ),
                ),
              ),
            ),
          ],
          child: MaterialApp.router(
            title: AppConstants.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
