import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../cubit/auth_cubit.dart';

/// A screen that allows users to sign in to their account.
///
/// This screen provides a clean and accessible login interface with:
/// - Mobile number and password input fields
/// - Form validation with user-friendly error messages
/// - Loading states and error handling
/// - Responsive design that works on different screen sizes
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: _authStateListener,
        child: const SafeArea(child: _LoginContent()),
      ),
    );
  }

  /// Handles authentication state changes and navigates accordingly
  void _authStateListener(BuildContext context, AuthState state) {
    if (state is AuthSuccess) {
      context.go(AppRouter.vehicleList);
    } else if (state is AuthError) {
      _showErrorSnackBar(context, state.message);
    }
  }

  /// Displays an error message in a snack bar
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
}

/// The main content widget for the login screen
class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _LoginHeader(),
            SizedBox(height: 48),
            _LoginForm(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Header section containing the app logo and title
class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // App Logo
        Icon(Icons.local_parking, size: 80, color: theme.colorScheme.primary),
        const SizedBox(height: 24),

        // App Title
        Text(
          AppConstants.appName,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          'Sign in to your account',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Form section containing the login inputs and submit button
class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    _mobileFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  /// Validates and submits the login form
  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
        _mobileController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  /// Toggles password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _MobileNumberField(
            controller: _mobileController,
            focusNode: _mobileFocusNode,
            onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
          ),
          const SizedBox(height: 20),
          _PasswordField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            obscureText: _obscurePassword,
            onToggleVisibility: _togglePasswordVisibility,
            onFieldSubmitted: (_) => _handleLogin(),
          ),
          const SizedBox(height: 32),
          _LoginButton(onLogin: _handleLogin),
        ],
      ),
    );
  }
}

/// Mobile number input field with validation
class _MobileNumberField extends StatelessWidget {
  const _MobileNumberField({
    required this.controller,
    required this.focusNode,
    required this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String) onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      labelText: 'Mobile Number',
      hintText: 'Enter your mobile number',
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.phone,
      prefixIcon: const Icon(Icons.phone),
      onSubmitted: onFieldSubmitted,
      validator: _validateMobileNumber,
      autofocus: true,
    );
  }

  /// Validates the mobile number input
  String? _validateMobileNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }

    final trimmedValue = value.trim();
    if (trimmedValue.length < 10) {
      return 'Mobile number must be at least 10 digits';
    }

    // Basic phone number validation (allows digits, spaces, dashes, and parentheses)
    final phoneRegex = RegExp(r'^[\d\s\-\(\)]+$');
    if (!phoneRegex.hasMatch(trimmedValue)) {
      return 'Please enter a valid mobile number';
    }

    return null;
  }
}

/// Password input field with visibility toggle
class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.focusNode,
    required this.obscureText,
    required this.onToggleVisibility,
    required this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final void Function(String) onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      labelText: 'Password',
      hintText: 'Enter your password',
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      prefixIcon: const Icon(Icons.lock),
      suffixIcon: IconButton(
        icon: Icon(
          obscureText ? Icons.visibility : Icons.visibility_off,
          semanticLabel: obscureText ? 'Show password' : 'Hide password',
        ),
        onPressed: onToggleVisibility,
      ),
      onSubmitted: onFieldSubmitted,
      validator: _validatePassword,
    );
  }

  /// Validates the password input
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }
}

/// Login button with loading state
class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return CustomButton(
          text: 'Sign In',
          onPressed: isLoading ? null : onLogin,
          isLoading: isLoading,
          width: double.infinity,
        );
      },
    );
  }
}
