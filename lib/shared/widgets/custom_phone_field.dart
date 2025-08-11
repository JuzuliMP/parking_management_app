// Main phone field widget with fixed color theming
import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../theme/app_typography.dart';

enum Variant { filled, outlined }

class CustomLabel extends StatelessWidget {
  final String label;
  final Color labelColor;
  final TextStyle? labelStyle;

  const CustomLabel(
      {super.key,
        required this.label,
        this.labelColor = AppTypography.primaryTextColor,
        this.labelStyle});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: labelStyle ??
          Theme.of(context).textTheme.titleMedium!.copyWith(color: labelColor),
    );
  }
}

class CustomPhoneField extends StatefulWidget {
  final bool focus;
  final Color labelColor;
  final Color inputColor;
  final Color fillColor;
  final Color borderColor;
  final String? initialphoneNumber;
  final PhoneController? controller;
  final Variant variant;
  final String? Function(PhoneNumber?)? validator;
  final FocusNode? focusNode;
  final AutovalidateMode autovalidateMode;
  final TextInputAction? textInputAction;
  final Function(PhoneNumber?)? onChanged;
  final Function(String)? onSubmitted;
  final bool enabled;
  final bool? filled;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final String? label;
  final String? hintText;

  const CustomPhoneField({
    Key? key,
    this.focus = false,
    this.onSubmitted,
    this.controller,
    this.validator,
    this.initialphoneNumber,
    this.labelColor = AppTypography.primaryTextColor,
    this.inputColor = AppTypography.primaryTextColor,
    // Fixed: Use proper background color for fill
    this.fillColor = const Color(0xFFF5F5F5), // Light gray background
    // Fixed: Use proper border color
    this.borderColor = const Color(0xFFE0E0E0), // Light gray border
    this.textInputAction,
    this.autovalidateMode = AutovalidateMode.disabled,
    required this.variant,
    this.onChanged,
    this.focusNode,
    this.enabled = true,
    this.filled,
    this.hintStyle,
    this.style,
    this.label = 'Phone no.',
    this.hintText,
  }) : super(key: key);

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  PhoneController? _phoneController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _phoneController = widget.controller ?? PhoneController();
    _initializeCountry();
  }

  Future<void> _initializeCountry() async {
    if (widget.initialphoneNumber == null ||
        widget.initialphoneNumber!.isEmpty) {
      _phoneController?.value = PhoneNumber(
        isoCode: IsoCode.IN,
        nsn: '',
      );
    } else {
      String phoneNumber = widget.initialphoneNumber!;

      try {
        // Parse the number with country code
        final parsedNumber = PhoneNumber.parse(phoneNumber);
        if (parsedNumber != null) {
          _phoneController?.value = parsedNumber;
        }
      } catch (e) {
        debugPrint('Error parsing phone number with country code: $e');
        _phoneController?.value = PhoneNumber(
          isoCode: IsoCode.IN,
          nsn: phoneNumber,
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            CustomLabel(
              label: widget.label!,
              labelColor: widget.labelColor,
            ),
            SizedBox(height: 8),
          ],
          SizedBox(
            height: 48,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      );
    }

    // Fixed: Calculate proper colors based on theme and state
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors based on enabled state
    final effectiveBorderColor = widget.enabled
        ? widget.borderColor
        : widget.borderColor.withValues(alpha: 0.5);

    final effectiveFillColor = widget.enabled
        ? widget.fillColor
        : widget.fillColor.withValues(alpha: 0.5);

    final effectiveInputColor = widget.enabled
        ? widget.inputColor
        : widget.inputColor.withValues(alpha: 0.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          CustomLabel(
            label: widget.label!,
            labelColor: widget.labelColor,
          ),
          SizedBox(height: 8),
        ],
        Container(
          constraints: BoxConstraints(
            minHeight: 48,
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: PhoneFormField(
              focusNode: widget.focusNode,
              onSubmitted: widget.onSubmitted,
              key: const Key('phone-field'),
              controller: _phoneController,
              countryButtonStyle: CountryButtonStyle(
                showFlag: false,
                flagSize: 16,
                textStyle: TextStyle(
                  color: effectiveInputColor,
                  decoration: TextDecoration.none,
                  fontSize: 16,
                ),
              ),
              style: widget.style ??
                  TextStyle(
                    color: effectiveInputColor,
                    decoration: TextDecoration.none,
                    fontSize: 16,
                  ),
              cursorColor: colorScheme.primary,
              cursorWidth: 1.0,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                errorStyle: theme.textTheme.bodySmall!.copyWith(
                  color: colorScheme.error,
                ),
                filled: widget.filled ?? widget.variant == Variant.filled,
                fillColor: effectiveFillColor,
                border: const OutlineInputBorder(),
                // Fixed: Proper enabled border color logic
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: widget.variant == Variant.filled
                      ? BorderSide.none
                      : BorderSide(
                    width: 1,
                    color: effectiveBorderColor,
                  ),
                ),
                // Fixed: Use custom border color or fall back to theme primary
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 2, // Slightly thicker for focus state
                    color: colorScheme.primary.withValues(alpha: 0.4),
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 1,
                    color: colorScheme.error,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 2,
                    color: colorScheme.error,
                  ),
                ),
                // Fixed: Proper disabled border
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: widget.variant == Variant.filled
                      ? BorderSide.none
                      : BorderSide(
                    width: 1,
                    color: effectiveBorderColor,
                  ),
                ),
                hintText: widget.hintText,
                hintStyle: widget.hintStyle ??
                    theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w300,
                      color: effectiveInputColor.withValues(alpha: 0.6),
                    ),
              ),
              validator: widget.validator,
              countrySelectorNavigator: const CountrySelectorNavigator.page(),
              autofillHints: const [AutofillHints.telephoneNumber],
              enabled: widget.enabled,
              autofocus: widget.focus,
              textInputAction: widget.textInputAction,
              autovalidateMode: widget.autovalidateMode,
              onChanged: widget.onChanged,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _phoneController?.dispose();
    }
    super.dispose();
  }
}