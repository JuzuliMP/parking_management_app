import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../cubit/vehicle_cubit.dart';

class VehicleCreateScreen extends StatefulWidget {
  const VehicleCreateScreen({super.key});

  @override
  State<VehicleCreateScreen> createState() => _VehicleCreateScreenState();
}

class _VehicleCreateScreenState extends State<VehicleCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _modelYearController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    _vehicleNumberController.dispose();
    _modelYearController.dispose();
    super.dispose();
  }

  void _createVehicle() {
    if (_formKey.currentState!.validate()) {
      final vehicleData = {
        'name': _nameController.text.trim(),
        'color': _colorController.text.trim(),
        'vehicle_number': _vehicleNumberController.text.trim(),
        'model_year': int.parse(_modelYearController.text.trim()),
      };

      context.read<VehicleCubit>().createVehicle(vehicleData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Vehicle')),
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
                      text: 'Create Vehicle',
                      onPressed: state is VehicleActionLoading
                          ? null
                          : _createVehicle,
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
