import 'package:fiszkomaniak/components/flashcard_multilines_text_field.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FlashcardsEditorItem extends StatefulWidget {
  final String questionInitialValue;
  final String answerInitialValue;
  final String nameForQuestion;
  final String nameForAnswer;
  final bool displayRedBorder;
  final Function(String value)? onQuestionChanged;
  final Function(String value)? onAnswerChanged;
  final VoidCallback? onTapDeleteButton;

  const FlashcardsEditorItem({
    required super.key,
    required this.questionInitialValue,
    required this.answerInitialValue,
    required this.nameForQuestion,
    required this.nameForAnswer,
    this.displayRedBorder = false,
    this.onQuestionChanged,
    this.onAnswerChanged,
    this.onTapDeleteButton,
  });

  @override
  State<FlashcardsEditorItem> createState() => _FlashcardsEditorItemState();
}

class _FlashcardsEditorItemState extends State<FlashcardsEditorItem> {
  late final TextEditingController questionController;
  late final TextEditingController answerController;

  @override
  void initState() {
    questionController = TextEditingController(
      text: widget.questionInitialValue,
    );
    answerController = TextEditingController(text: widget.answerInitialValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24.0),
      decoration: _generateBorders(context),
      child: Stack(
        children: [
          _Flashcard(
            questionController: questionController,
            answerController: answerController,
            nameForQuestion: widget.nameForQuestion,
            nameForAnswer: widget.nameForAnswer,
            onQuestionChanged: widget.onQuestionChanged,
            onAnswerChanged: widget.onAnswerChanged,
          ),
          _DeleteButton(onTap: widget.onTapDeleteButton),
        ],
      ),
    );
  }

  BoxDecoration _generateBorders(BuildContext context) {
    return BoxDecoration(
      border: Border.all(
        color: widget.displayRedBorder
            ? Colors.red
            : Theme.of(context).scaffoldBackgroundColor,
        width: 1.2,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
    );
  }
}

class _Flashcard extends StatelessWidget {
  final TextEditingController questionController;
  final TextEditingController answerController;
  final String nameForQuestion;
  final String nameForAnswer;
  final Function(String value)? onQuestionChanged;
  final Function(String value)? onAnswerChanged;

  const _Flashcard({
    required this.questionController,
    required this.answerController,
    required this.nameForQuestion,
    required this.nameForAnswer,
    required this.onQuestionChanged,
    required this.onAnswerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MultiLinesTextField(
              controller: questionController,
              hintText: 'Pytanie ($nameForQuestion)',
              onChanged: onQuestionChanged,
            ),
            const Divider(thickness: 1),
            MultiLinesTextField(
              controller: answerController,
              hintText: 'Odpowiedź ($nameForAnswer)',
              onChanged: onAnswerChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _DeleteButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 6.0,
      right: 6.0,
      child: GestureDetector(
        onTap: onTap,
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
