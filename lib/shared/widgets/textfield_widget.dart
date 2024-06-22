import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool required;
  final bool obscureText;
  final int? minLines;
  final int? maxLines;
  final Widget? suffixIcon;
  final Color? color;
  const TextFieldWidget(
      {super.key,
      this.controller,
      this.label,
      this.minLines,
      this.maxLines = 1,
      this.validator,
      this.suffixIcon,
      this.color,
      this.obscureText = false,
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
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator ??
              (value) {
                if (value == '' && required) {
                  return 'The ${(label ?? 'input').toLowerCase()} field is required.';
                }
                return null;
              },
          minLines: minLines,
          maxLines: maxLines,
          style: TextStyle(color: color ?? Colors.white, fontSize: 19),
          decoration: InputDecoration(
              isDense: true,
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
