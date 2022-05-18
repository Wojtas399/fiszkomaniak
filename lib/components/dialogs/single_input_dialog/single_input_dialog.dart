import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/components/buttons/button.dart';
import 'package:fiszkomaniak/components/dialogs/single_input_dialog/single_input_dialog_cubit.dart';
import 'package:fiszkomaniak/components/on_tap_focus_lose_area.dart';
import 'package:fiszkomaniak/components/textfields/custom_textfield.dart';
import 'package:fiszkomaniak/components/textfields/password_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SingleInputDialog extends StatelessWidget {
  final String appBarTitle;
  final IconData textFieldIcon;
  final TextFieldType textFieldType;
  final String? title;
  final String? message;
  final String? textFieldLabel;
  final String? textFieldPlaceholder;
  final String? textFieldValue;
  final String? submitButtonLabel;

  const SingleInputDialog({
    super.key,
    required this.appBarTitle,
    required this.textFieldIcon,
    required this.textFieldType,
    this.title,
    this.message,
    this.textFieldLabel,
    this.textFieldPlaceholder,
    this.textFieldValue,
    this.submitButtonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leadingIcon: MdiIcons.close,
        label: appBarTitle,
      ),
      body: SafeArea(
        child: OnTapFocusLoseArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _CubitProvider(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        title ?? '',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        message ?? '',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      const SizedBox(height: 16.0),
                      _TextField(
                        icon: textFieldIcon,
                        textFieldType: textFieldType,
                        label: textFieldLabel,
                        placeholder: textFieldPlaceholder,
                      ),
                    ],
                  ),
                  _SubmitButton(
                    label: submitButtonLabel ?? 'Wyślij',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CubitProvider extends StatelessWidget {
  final Widget child;

  const _CubitProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SingleInputDialogCubit(),
      child: child,
    );
  }
}

class _TextField extends StatelessWidget {
  final IconData icon;
  final TextFieldType textFieldType;
  final String? label;
  final String? placeholder;

  const _TextField({
    required this.icon,
    required this.textFieldType,
    this.label,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    switch (textFieldType) {
      case TextFieldType.normal:
        return CustomTextField(
          icon: icon,
          label: label ?? '',
          placeholder: placeholder,
          onChanged: (String value) => _onChanged(context, value),
        );
      case TextFieldType.password:
        return PasswordTextField(
          label: label ?? '',
          onChanged: (String value) => _onChanged(context, value),
        );
    }
  }

  void _onChanged(BuildContext context, String value) {
    context.read<SingleInputDialogCubit>().onValueChanged(value);
  }
}

class _SubmitButton extends StatelessWidget {
  final String label;

  const _SubmitButton({required this.label});

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (SingleInputDialogCubit cubit) => cubit.isButtonDisabled,
    );
    return Button(
      label: label,
      onPressed: isDisabled ? null : () => _submit(context),
    );
  }

  void _submit(BuildContext context) {
    context.read<SingleInputDialogCubit>().onSubmit(context);
  }
}

enum TextFieldType {
  normal,
  password,
}
