import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_test/utils/colors/colors.dart';

class CustomTextfieldTwo extends StatelessWidget {
  const CustomTextfieldTwo({
    super.key,
    this.controller,
    this.onSubmit,
    this.color,
    this.validator,
    this.onChanged,
    required this.hintText,
    this.autofocus,
    this.keyboardType,
    this.maxLength,
    this.inputFormatters,
    this.maxLines,
    this.readOnly,
    this.radius,
  });
  final TextEditingController? controller;
  final bool? autofocus;
  final void Function(String)? onSubmit;
  final String hintText;
  final Color? color;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final bool? readOnly;
  final bool? radius;

  final int? maxLength;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      maxLines: maxLines,
      autofocus: autofocus ?? false,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: AppColors.black.withValues(alpha: 0.9),
        fontSize: 12,
        fontFamily: "Inter",
      ),
      onChanged: onChanged,
      onFieldSubmitted: onSubmit,
      keyboardType: keyboardType,
      controller: controller,
      validator: validator,
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        filled: true,
        fillColor: color ?? AppColors.whitecolor,
        enabledBorder: OutlineInputBorder(
          borderRadius:
              radius ?? false
                  ? BorderRadius.circular(5)
                  : BorderRadius.circular(25),
          borderSide: BorderSide(color: AppColors.transparent),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w200,
          color: AppColors.black,
          fontSize: 12,
          fontFamily: "Gilroy",
        ),
        border: OutlineInputBorder(
          borderRadius:
              radius ?? false
                  ? BorderRadius.circular(5)
                  : BorderRadius.circular(25),
          borderSide: BorderSide(color: AppColors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              radius ?? false
                  ? BorderRadius.circular(5)
                  : BorderRadius.circular(25),
          borderSide: BorderSide(color: AppColors.transparent),
        ),
      ),
    );
  }
}
