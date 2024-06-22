import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<T> data;
  final T? initialValue;
  final String? label;
  final Color? color;
  final Function(T? value)? onChanged;
  final String? Function(T? value)? validator;
  final String? Function(T value)? itemValue;
  final bool? autoFocus;
  const CustomDropdown(
      {super.key,
      required this.data,
      this.initialValue,
      this.validator,
      this.color,
      this.onChanged,
      this.autoFocus,
      this.label,
      this.itemValue});

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  late T? initialValue;

  @override
  void initState() {
    initialValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    InputBorder? inputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: widget.color ?? Colors.white, width: 1),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Container(
              margin: const EdgeInsets.only(bottom: 6),
              child: Text(
                widget.label ?? '',
                style: TextStyle(color: widget.color ?? Colors.white),
              )),
        DropdownButtonFormField<T>(
          validator: widget.validator,
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              isDense: true,
              focusedBorder: inputBorder,
              errorBorder: inputBorder,
              focusedErrorBorder: inputBorder,
              enabledBorder: inputBorder),
          dropdownColor: Colors.grey,
          value: initialValue,
          autofocus: widget.autoFocus ?? false,
          isExpanded: true,
          icon: Icon(Icons.expand_more, color: widget.color ?? Colors.white),
          iconSize: 24,
          elevation: 1,
          style: TextStyle(
            color: widget.color ?? Colors.white,
            fontSize: 18,
          ),
          // underline: const SizedBox(),
          onChanged: (T? newValue) {
            setState(() {
              initialValue = newValue;
              if (widget.onChanged != null) {
                widget.onChanged!(initialValue);
              }
            });
          },
          items: widget.data.map((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Text(
                widget.itemValue != null
                    ? widget.itemValue!(value) ?? ''
                    : value.toString(),
                // style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
