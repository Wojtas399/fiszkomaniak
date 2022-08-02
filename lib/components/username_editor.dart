import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../validators/username_validator.dart';
import 'buttons/button.dart';
import 'textfields/custom_textfield.dart';
import 'on_tap_focus_lose_area.dart';
import 'app_bar_with_close_button.dart';

class UsernameEditor extends StatefulWidget {
  final String currentUsername;

  const UsernameEditor({
    super.key,
    required this.currentUsername,
  });

  @override
  State<UsernameEditor> createState() => _UsernameEditor();
}

class _UsernameEditor extends State<UsernameEditor> {
  late final String? initialValue;
  final TextEditingController _controller = TextEditingController();
  final UsernameValidator _usernameValidator = UsernameValidator();
  StreamSubscription? textFieldStatus;
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    final String textFieldValue = widget.currentUsername;
    initialValue = textFieldValue;
    _controller.text = textFieldValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        leadingIcon: MdiIcons.close,
        label: 'Nowa nazwa użytkownika',
      ),
      body: SafeArea(
        child: OnTapFocusLoseArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextField(
                  icon: MdiIcons.accountOutline,
                  label: 'Nazwa użytkownika',
                  isRequired: true,
                  controller: _controller,
                  placeholder: 'Np. Jan Nowak',
                  validator: _validateUsername,
                  onChanged: _onTextFieldValueChanged,
                ),
                Button(
                  label: 'Zapisz',
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

  String? _validateUsername(String? value) {
    return !_usernameValidator.isValid(value ?? '')
        ? UsernameValidator.message
        : null;
  }

  void _onTextFieldValueChanged(String value) {
    setState(() {
      _isButtonDisabled = !(value.isNotEmpty &&
          value != initialValue &&
          _usernameValidator.isValid(value));
    });
  }

  void _onButtonPressed(BuildContext context) {
    Navigator.of(context).pop(_controller.text);
  }
}
