import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

class DateFieldWidget extends StatelessWidget {
  final String? label;
  final String? Function(DateTime?)? validator;
  final bool required;
  final Widget? suffixIcon;
  final Color? color;
  final DateTime? initialValue;
  final Function(DateTime?)? onChanged;
  const DateFieldWidget(
      {super.key,
      this.label,
      this.validator,
      this.suffixIcon,
      this.onChanged,
      this.initialValue,
      this.color,
      this.required = false});

  @override
  Widget build(BuildContext context) {
    InputBorder? inputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: color ?? Colors.white, width: 1),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Container(
              margin: const EdgeInsets.only(bottom: 6),
              child: Text(
                label ?? '',
                style: TextStyle(color: color ?? Colors.white),
              )),
        DateTimeFormField(
          initialValue: initialValue,
          validator: validator ??
              (value) {
                if (value == null && required) {
                  return 'The ${(label ?? 'input').toLowerCase()} field is required.';
                }
                return null;
              },
          mode: DateTimeFieldPickerMode.time,
          onChanged: onChanged,
          style: TextStyle(color: color ?? Colors.white, fontSize: 18),
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              isDense: true,
              suffixIconColor: color ?? Colors.white,
              suffixIcon: suffixIcon,
              focusedBorder: inputBorder,
              errorBorder: inputBorder,
              focusedErrorBorder: inputBorder,
              enabledBorder: inputBorder),
        ),
      ],
    );
  }
}
