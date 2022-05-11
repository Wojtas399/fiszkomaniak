import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/components/buttons/button.dart';
import 'package:fiszkomaniak/components/on_tap_focus_lose_area.dart';
import 'package:fiszkomaniak/components/textfields/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SingleInputDialog extends StatefulWidget {
  final String title;
  final IconData textFieldIcon;
  final String textFieldLabel;
  final String buttonLabel;
  final String? value;
  final String? placeholder;
  final String? Function(String? value)? validator;

  const SingleInputDialog({
    Key? key,
    required this.title,
    required this.textFieldIcon,
    required this.textFieldLabel,
    required this.buttonLabel,
    this.value,
    this.placeholder,
    this.validator,
  }) : super(key: key);

  @override
  _SingleInputDialogState createState() => _SingleInputDialogState();
}

class _SingleInputDialogState extends State<SingleInputDialog> {
  late final String? initialValue;
  final TextEditingController _controller = TextEditingController();
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    final String? textFieldValue = widget.value;
    initialValue = textFieldValue;
    if (textFieldValue != null) {
      _controller.text = textFieldValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leadingIcon: MdiIcons.close,
        label: widget.title,
      ),
      body: SafeArea(
        child: OnTapFocusLoseArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextField(
                  icon: widget.textFieldIcon,
                  label: widget.textFieldLabel,
                  controller: _controller,
                  placeholder: widget.placeholder,
                  validator: widget.validator,
                  onChanged: _onTextFieldValueChanged,
                ),
                Button(
                  label: widget.buttonLabel,
                  onPressed: _isButtonDisabled
                      ? null
                      : () => _onButtonPressed(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTextFieldValueChanged(String value) {
    setState(() {
      _isButtonDisabled = !(value.isNotEmpty && value != initialValue);
    });
  }

  void _onButtonPressed(BuildContext context) {
    Navigator.of(context).pop(_controller.text);
  }
}
