import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../cubit/vehicle_cubit.dart';

class VehicleUpdateScreen extends StatefulWidget {
  final Map<String, dynamic>? vehicle;

  const VehicleUpdateScreen({super.key, this.vehicle});

  @override
  State<VehicleUpdateScreen> createState() => _VehicleUpdateScreenState();
}

class _VehicleUpdateScreenState extends State<VehicleUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _modelYearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.vehicle != null) {
      _nameController.text = widget.vehicle!['name'] ?? '';
      _colorController.text = widget.vehicle!['color'] ?? '';
      _vehicleNumberController.text = widget.vehicle!['vehicle_number'] ?? '';
      _modelYearController.text =
          widget.vehicle!['model_year']?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    _vehicleNumberController.dispose();
    _modelYearController.dispose();
    super.dispose();
  }

  void _updateVehicle() {
    if (_formKey.currentState!.validate()) {
      final vehicleData = {
        'name': _nameController.text.trim(),
        'color': _colorController.text.trim(),
        'vehicle_number': _vehicleNumberController.text.trim(),
        'model_year': int.parse(_modelYearController.text.trim()),
      };

      final vehicleId = widget.vehicle?['id'];
      if (vehicleId != null) {
        context.read<VehicleCubit>().updateVehicle(
          vehicleId.toString(),
          vehicleData,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Vehicle')),
      body: BlocListener<VehicleCubit, VehicleState>(
        listener: (context, state) {
          if (state is VehicleActionSuccess) {
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  labelText: 'Vehicle Name',
                  hintText: 'Enter vehicle name',
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vehicle name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  labelText: 'Color',
                  hintText: 'Enter vehicle color',
                  controller: _colorController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Color is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  labelText: 'Vehicle Number',
                  hintText: 'Enter vehicle number',
                  controller: _vehicleNumberController,
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vehicle number is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  labelText: 'Model Year',
                  hintText: 'Enter model year',
                  controller: _modelYearController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Model year is required';
                    }
                    final year = int.tryParse(value);
                    if (year == null) {
                      return 'Please enter a valid year';
                    }
                    if (year < 1900 || year > DateTime.now().year + 1) {
                      return 'Please enter a valid year between 1900 and ${DateTime.now().year + 1}';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                BlocBuilder<VehicleCubit, VehicleState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: 'Update Vehicle',
                      onPressed: state is VehicleActionLoading
                          ? null
                          : _updateVehicle,
                      isLoading: state is VehicleActionLoading,
                      width: double.infinity,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
