import 'package:flutter/material.dart';

class MultiLinesTextField extends StatelessWidget {
  final String? hintText;
  final TextAlign? textAlign;
  final TextEditingController? controller;
  final Function(String value)? onChanged;
  final FocusNode? focusNode;

  const MultiLinesTextField({
    super.key,
    this.hintText,
    this.textAlign,
    this.controller,
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textAlign: textAlign ?? TextAlign.start,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        counter: const Offstage(),
      ),
      onChanged: onChanged,
      maxLength: 100,
      focusNode: focusNode,
    );
  }
}
