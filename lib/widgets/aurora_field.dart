import 'package:auroria/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AuroraField extends StatelessWidget {
  const AuroraField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.suffix,
    this.onSubmitted,
    this.autofocus = false,
    this.maxLength,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Widget? suffix;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final int? maxLength;

  OutlineInputBorder _border(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscure,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      onFieldSubmitted: onSubmitted,
      autofocus: autofocus,
      maxLength: maxLength,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      cursorColor: AppColors.orange,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.mutedText),
        floatingLabelStyle: const TextStyle(color: AppColors.orange),
        prefixIcon: Icon(icon, color: AppColors.cyan),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0x1FFFFFFF),
        counterText: '',
        errorStyle: const TextStyle(color: Color(0xFFFF8AB8)),
        border: _border(Colors.transparent),
        enabledBorder: _border(AppColors.glassBorder),
        focusedBorder: _border(AppColors.orange, 2),
        errorBorder: _border(AppColors.pink),
        focusedErrorBorder: _border(AppColors.pink, 2),
      ),
    );
  }
}