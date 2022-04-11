import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FlashcardsEditorItem extends StatelessWidget {
  final TextEditingController questionController;
  final TextEditingController answerController;
  final String nameForQuestion;
  final String nameForAnswer;
  final Function(String value)? onQuestionChanged;
  final Function(String value)? onAnswerChanged;

  const FlashcardsEditorItem({
    Key? key,
    required this.questionController,
    required this.answerController,
    required this.nameForQuestion,
    required this.nameForAnswer,
    this.onQuestionChanged,
    this.onAnswerChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _MultiLinesTextField(
                    controller: questionController,
                    hintText: 'Pytanie ($nameForQuestion)',
                    onChanged: onQuestionChanged,
                  ),
                  const Divider(thickness: 1),
                  _MultiLinesTextField(
                    controller: answerController,
                    hintText: 'Odpowiedź ($nameForAnswer)',
                    onChanged: onAnswerChanged,
                  ),
                ],
              ),
            ),
          ),
          const _DeleteButton(),
        ],
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 4.0,
      right: 4.0,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: Colors.transparent,
          ),
          child: const Icon(
            MdiIcons.closeCircle,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _MultiLinesTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function(String value)? onChanged;

  const _MultiLinesTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
      ),
      onChanged: onChanged,
    );
  }
}
