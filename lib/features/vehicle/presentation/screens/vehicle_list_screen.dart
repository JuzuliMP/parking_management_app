import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../cubit/vehicle_cubit.dart';
import '../widgets/vehicle_list_item.dart';
import 'vehicle_create_screen.dart';

/// A screen that displays a paginated list of vehicles with smooth scrolling
/// and pull-to-refresh functionality.
class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load initial data
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Loads the initial vehicle data
  void _loadInitialData() {
    context.read<VehicleCubit>().getVehicles(page: 1, refresh: true);
  }

  /// Handles scroll events for pagination
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreVehicles();
    }
  }

  /// Loads more vehicles for pagination
  void _loadMoreVehicles() {
    final state = context.read<VehicleCubit>().state;

    if (state is VehicleLoaded && !state.hasReachedMax && !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });

      _currentPage++;
      context.read<VehicleCubit>().getVehicles(page: _currentPage);
    }
  }

  /// Refreshes the vehicle list
  Future<void> _refresh() async {
    _currentPage = 1;
    _isLoadingMore = false;
    context.read<VehicleCubit>().getVehicles(page: _currentPage, refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.logout),
        //     onPressed: () {
        //       // TODO: Implement logout
        //       context.go(AppRouter.login);
        //     },
        //   ),
        // ],
      ),
      body: BlocListener<VehicleCubit, VehicleState>(
        listener: _vehicleStateListener,
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: BlocBuilder<VehicleCubit, VehicleState>(
            builder: (context, state) {
              return _buildBody(state);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createVehicle,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Handles vehicle state changes and shows appropriate feedback
  void _vehicleStateListener(BuildContext context, VehicleState state) {
    // Reset loading more flag when new data is loaded
    if (state is VehicleLoaded) {
      setState(() {
        _isLoadingMore = false;
      });
    }

    // Handle action states
    if (state is VehicleActionSuccess) {
      _showSuccessSnackBar(context, state.message);
      context.read<VehicleCubit>().resetActionState();
    } else if (state is VehicleActionError) {
      _showErrorSnackBar(context, state.message);
      context.read<VehicleCubit>().resetActionState();
    }
  }

  /// Shows a success snack bar
  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Shows an error snack bar
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Builds the main body based on the current state
  Widget _buildBody(VehicleState state) {
    if (state is VehicleLoading) {
      return const LoadingWidget(message: 'Loading vehicles...');
    } else if (state is VehicleError) {
      return _buildErrorState(state.message);
    } else if (state is VehicleLoaded) {
      return _buildVehicleList(state);
    } else if (state is VehicleLoadingMore) {
      return _buildVehicleListWithLoading(state);
    }

    return const LoadingWidget(message: 'Loading vehicles...');
  }

  /// Builds the error state widget
  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 16),
          Text('Error', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          CustomButton(text: 'Retry', onPressed: _refresh, isOutlined: true),
        ],
      ),
    );
  }

  /// Builds the vehicle list with current data
  Widget _buildVehicleList(VehicleLoaded state) {
    if (state.vehicles.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount:
          state.vehicles.length + (_shouldShowLoadingIndicator(state) ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.vehicles.length) {
          return _buildLoadingIndicator();
        }

        final vehicle = state.vehicles[index];
        return VehicleListItem(
          vehicle: vehicle,
          onEdit: () => _editVehicle(vehicle),
          onDelete: () => _deleteVehicle(vehicle),
        );
      },
    );
  }

  /// Builds the vehicle list with loading state (for initial load with existing data)
  Widget _buildVehicleListWithLoading(VehicleLoadingMore state) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: state.vehicles.length + 1,
      itemBuilder: (context, index) {
        if (index == state.vehicles.length) {
          return _buildLoadingIndicator();
        }

        final vehicle = state.vehicles[index];
        return VehicleListItem(
          vehicle: vehicle,
          onEdit: () => _editVehicle(vehicle),
          onDelete: () => _deleteVehicle(vehicle),
        );
      },
    );
  }

  /// Builds the empty state widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car_outlined,
            size: 64,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No vehicles found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Start by adding your first vehicle',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the loading indicator for pagination
  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text('Loading more vehicles...'),
          ],
        ),
      ),
    );
  }

  /// Determines if the loading indicator should be shown
  bool _shouldShowLoadingIndicator(VehicleLoaded state) {
    return !state.hasReachedMax && _isLoadingMore;
  }

  /// Navigates to vehicle creation screen
  void _createVehicle() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VehicleCreateScreen()),
    );
  }

  /// Navigates to vehicle edit screen
  void _editVehicle(dynamic vehicle) {
    context.push(AppRouter.vehicleUpdate, extra: vehicle.toJson());
  }

  /// Shows delete confirmation dialog
  void _deleteVehicle(dynamic vehicle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Vehicle'),
        content: Text('Are you sure you want to delete ${vehicle.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<VehicleCubit>().deleteVehicle(vehicle.id);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
