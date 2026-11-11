import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget 
{
  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final bool isPasswordField;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    this.label,
    this.hint,
    this.errorMessage,
    this.obscureText = false,
    this.isPasswordField = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> 
{
  late bool _obscure;

  @override
  void initState() 
  {
    super.initState();
    _obscure = widget.isPasswordField ? true : widget.obscureText;
  }

  void _toggleVisibility() {
    setState(() => _obscure = !_obscure);
  }

  @override
  Widget build(BuildContext context) 
  {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderSide: BorderSide(color: colors.outlineVariant),
      borderRadius: BorderRadius.circular(8),
    );

    return TextFormField(
      onChanged: widget.onChanged,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      obscureText: _obscure,
      keyboardType: widget.keyboardType,
      style: TextStyle(fontSize: 16, color: colors.onSurface),
      decoration: InputDecoration(
        floatingLabelStyle: TextStyle(
          color: colors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
        errorBorder: border.copyWith(
          borderSide: BorderSide(color: colors.error),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: BorderSide(color: colors.error, width: 1.5),
        ),
        isDense: true,
        label: widget.label != null ? Text(widget.label!) : null,
        hintText: widget.hint,
        errorText: widget.errorMessage,
        focusColor: colors.primary,
        suffixIcon: widget.isPasswordField ? 
          IconButton(
            icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: _toggleVisibility,
          ) : null,
      ),
    );
  }
}
