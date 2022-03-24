import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:flutter/material.dart';

class CourseCreator extends StatelessWidget {
  const CourseCreator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWithCloseButton(label: 'Nowy kurs'),
      body: Center(
        child: Text('Nowy kurs'),
      ),
    );
  }
}
