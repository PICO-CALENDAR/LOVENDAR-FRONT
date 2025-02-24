import 'package:flutter/material.dart';

class FormStepDescription extends StatelessWidget {
  const FormStepDescription({
    super.key,
    required this.stepTitle,
    required this.stepDescription,
  });

  final String stepTitle;
  final String stepDescription;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stepTitle,
          style: TextStyle(
            fontFamily: "Kyobo",
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          stepDescription,
          style: TextStyle(
            fontFamily: "Kyobo",
            color: const Color.fromARGB(255, 223, 236, 205),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
