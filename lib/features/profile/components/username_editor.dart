import 'dart:async';
import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/components/buttons/button.dart';
import 'package:fiszkomaniak/components/on_tap_focus_lose_area.dart';
import 'package:fiszkomaniak/components/textfields/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../core/validators/user_validator.dart';

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
    return !UserValidator.isUsernameCorrect(value ?? '')
        ? UserValidator.incorrectUsernameMessage
        : null;
  }

  void _onTextFieldValueChanged(String value) {
    setState(() {
      _isButtonDisabled = !(value.isNotEmpty &&
          value != initialValue &&
          UserValidator.isUsernameCorrect(value));
    });
  }

  void _onButtonPressed(BuildContext context) {
    Navigator.of(context).pop(_controller.text);
  }
}
