import 'package:flutter/cupertino.dart';

Widget StudentDetailWiget(String title, String value){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title.trim(),
        style: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.left,
      ),
      const SizedBox(height: 20),
      Text(
        value.trim(),
        style: const TextStyle(
          fontSize: 16.0,
        ),
        textAlign: TextAlign.left,
      ),
      const SizedBox(height: 20),
    ],
  );
}