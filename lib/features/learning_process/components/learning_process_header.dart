import 'package:flutter/material.dart';

class LearningProcessHeader extends StatelessWidget {
  const LearningProcessHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, top: 24.0, right: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Język angielski',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(height: 8.0),
          Text(
            'Zwroty grzecznościowe',
            style: Theme.of(context).textTheme.headline6,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
