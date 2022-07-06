import 'package:flutter/material.dart';
import '../../../components/flashcard_multilines_text_field.dart';

class FlashcardWithTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final TextEditingController controller;
  final Function(String value)? onChanged;
  final FocusNode? focusNode;
  final VoidCallback? onTap;

  const FlashcardWithTitle({
    super.key,
    required this.title,
    required this.subtitle,
    required this.controller,
    this.onChanged,
    this.focusNode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Title(title: title, subtitle: subtitle),
        const SizedBox(height: 8),
        _Flashcard(
          controller: controller,
          onChanged: onChanged,
          focusNode: focusNode,
          onTap: onTap,
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final String title;
  final String subtitle;

  const _Title({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.subtitle1),
        const SizedBox(width: 4.0),
        Text('($subtitle)', style: Theme.of(context).textTheme.caption),
      ],
    );
  }
}

class _Flashcard extends StatelessWidget {
  final TextEditingController controller;
  final Function(String value)? onChanged;
  final VoidCallback? onTap;
  final FocusNode? focusNode;

  const _Flashcard({
    required this.controller,
    required this.onChanged,
    this.onTap,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        height: 180,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: MultiLinesTextField(
                textAlign: TextAlign.center,
                controller: controller,
                onChanged: onChanged,
                focusNode: focusNode,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
