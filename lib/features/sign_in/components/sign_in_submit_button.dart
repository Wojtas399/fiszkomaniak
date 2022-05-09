import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/button.dart';
import '../bloc/sign_in_event.dart';
import '../bloc/sign_in_state.dart';

class SignInSubmitButton extends StatelessWidget {
  const SignInSubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return Center(
          child: Button(
            label: 'Zaloguj',
            onPressed: state.isButtonDisabled
                ? null
                : () => context.read<SignInBloc>().add(
                      SignInEventSubmit(
                        email: state.email,
                        password: state.password,
                      ),
                    ),
          ),
        );
      },
    );
  }
}
