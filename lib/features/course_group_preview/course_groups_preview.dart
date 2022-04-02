import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:flutter/material.dart';

class CourseGroupsPreview extends StatelessWidget {
  const CourseGroupsPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWithCloseButton(label: 'Nazwa kursu'),
      body: Center(
        child: Text('Course groups preview page'),
      ),
    );
  }
}
