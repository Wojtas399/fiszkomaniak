import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/buttons/button.dart';
import '../../config/slide_right_route_animation.dart';
import '../../core/auth/auth_bloc.dart';
import '../initial_home/initial_home.dart';

class HomeErrorScreen extends StatelessWidget {
  const HomeErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _Title(),
            SizedBox(height: 12.0),
            _Message(),
            SizedBox(height: 48.0),
            _Button(),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Ups, coś poszło nie tak...  :(',
      style: Theme.of(context).textTheme.headline3?.apply(
            color: Theme.of(context).colorScheme.primary,
            fontWeightDelta: 2,
          ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Niestety wystąpił nieoczekiwany błąd. Spróbuj ponownie później.',
      style: Theme.of(context)
          .textTheme
          .headline5
          ?.apply(color: Theme.of(context).colorScheme.primary),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button();

  @override
  Widget build(BuildContext context) {
    return Button(
      label: 'Wróć do ekranu początkowego',
      onPressed: () {
        context.read<AuthBloc>().add(AuthEventSignOut());
        Navigator.of(context).pushReplacement(
          SlideRightRouteAnimation(page: const InitialHome()),
        );
      },
    );
  }
}
