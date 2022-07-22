import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:fiszkomaniak/features/sign_up/components/sign_up_inputs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/buttons/button.dart';
import '../../utils/utils.dart';
import 'bloc/sign_up_event.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpBloc(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Header(),
          SizedBox(height: 24),
          SignUpInputs(),
          SizedBox(height: 16),
          _SubmitButton(),
          SizedBox(height: 16),
          _AlternativeOption(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Zarejestruj się',
      style: TextStyle(
        color: Colors.black,
        fontSize: 34,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (SignUpBloc bloc) => bloc.state.isDisabledButton,
    );
    return Center(
      child: Button(
        label: 'Zarejestruj',
        onPressed: isDisabled ? null : () => _submit(context),
      ),
    );
  }

  void _submit(BuildContext context) {
    context.read<SignUpBloc>().add(SignUpEventSubmit());
  }
}

class _AlternativeOption extends StatelessWidget {
  const _AlternativeOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: GestureDetector(
          onTap: () => _onPressed(context),
          child: const Text(
            'Masz już konto? Zaloguj się!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    // context.read<InitialHomeModeProvider>().changeMode(InitialHomeMode.login);
    Utils.unfocusElements();
    context.read<SignUpBloc>().add(SignUpEventReset());
  }
}
