import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class LearningProcessButtons extends StatelessWidget {
  const LearningProcessButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Button(
            text: 'Nie udało się',
            color: HexColor('#FF6961'),
            onPressed: () {
              //TODO
            },
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: _Button(
            text: 'Udało się',
            color: HexColor('#63B76C'),
            onPressed: () {
              //TODO
            },
          ),
        ),
      ],
    );
  }
}

class _Button extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _Button({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
        ),
      ),
    );
  }
}
