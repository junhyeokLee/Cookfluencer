import 'package:flutter/material.dart';

Widget buildMultilineText(BuildContext context, String text, TextStyle? style) {
  // 문자열을 \n을 기준으로 분리하여 Text 위젯 리스트로 변환
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: text.split('/n').map((line) {
      return Text(
        line,
        style: style,
      );
    }).toList(),
  );
}