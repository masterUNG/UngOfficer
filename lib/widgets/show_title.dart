import 'package:flutter/material.dart';

class ShowTitle extends StatelessWidget {
  String title;
  int indexStyle;

  TextStyle textStyleH1() => TextStyle(
        fontSize: 24,
        color: Colors.blue[700],
        fontWeight: FontWeight.bold,
      );

  TextStyle textStyleH2() => TextStyle(
        fontSize: 16,
        color: Colors.blue[900],
        fontWeight: FontWeight.w700,
      );

  TextStyle textStyleH3() => TextStyle(
        fontSize: 14,
        color: Colors.blue[900],
        fontWeight: FontWeight.w500,
      );

  ShowTitle({@required this.title, @required this.indexStyle});

  @override
  Widget build(BuildContext context) {
    List<TextStyle> textStyles = [
      textStyleH1(),
      textStyleH2(),
      textStyleH3(),
    ];
    return Text(title, style: textStyles[indexStyle],);
  }
}
