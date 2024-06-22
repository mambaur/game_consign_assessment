import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String? title;
  const EmptyWidget({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300)),
      child: Text(title ?? 'Your data is still empty'),
    );
  }
}
