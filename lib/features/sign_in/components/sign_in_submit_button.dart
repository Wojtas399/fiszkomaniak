import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/buttons/button.dart';

class SignInSubmitButton extends StatelessWidget {
  const SignInSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = context.select(
      (SignInBloc bloc) => bloc.state.isButtonDisabled,
    );
    return Center(
      child: Button(
        label: 'Zaloguj',
        onPressed: isButtonDisabled
            ? null
            : () => context.read<SignInBloc>().add(SignInEventSubmit()),
      ),
    );
  }
}
