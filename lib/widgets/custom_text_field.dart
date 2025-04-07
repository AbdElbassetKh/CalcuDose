import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool numbersOnly;
  final bool allowDecimal;
  final String? suffix;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.numbersOnly = false,
    this.allowDecimal = false,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
      ),
      keyboardType: numbersOnly
          ? TextInputType.numberWithOptions(decimal: allowDecimal)
          : TextInputType.text,
      inputFormatters: numbersOnly
          ? [
              allowDecimal
                  ? FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                  : FilteringTextInputFormatter.digitsOnly,
            ]
          : null,
    );
  }
}
