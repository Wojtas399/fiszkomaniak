import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FlashcardsEditorItem extends StatefulWidget {
  final String questionInitialValue;
  final String answerInitialValue;
  final String nameForQuestion;
  final String nameForAnswer;
  final Function(String value)? onQuestionChanged;
  final Function(String value)? onAnswerChanged;
  final VoidCallback? onTapDeleteButton;

  const FlashcardsEditorItem({
    required Key key,
    required this.questionInitialValue,
    required this.answerInitialValue,
    required this.nameForQuestion,
    required this.nameForAnswer,
    this.onQuestionChanged,
    this.onAnswerChanged,
    this.onTapDeleteButton,
  }) : super(key: key);

  @override
  _FlashcardsEditorItemState createState() => _FlashcardsEditorItemState();
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
                    hintText: 'Pytanie (${widget.nameForQuestion})',
                    onChanged: widget.onQuestionChanged,
                  ),
                  const Divider(thickness: 1),
                  _MultiLinesTextField(
                    controller: answerController,
                    hintText: 'Odpowiedź (${widget.nameForAnswer})',
                    onChanged: widget.onAnswerChanged,
                  ),
                ],
              ),
            ),
          ),
          _DeleteButton(onTap: widget.onTapDeleteButton),
        ],
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _DeleteButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 4.0,
      right: 4.0,
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
        counter: const Offstage(),
      ),
      onChanged: onChanged,
      maxLength: 100,
    );
  }
}
