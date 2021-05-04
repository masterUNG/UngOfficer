import 'package:flutter/material.dart';
import 'package:nugofficer/utility/my_constant.dart';

Future<Null> normalDialog(
    BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      backgroundColor: Colors.orange,
      title: ListTile(
        leading: Image.asset(MyConstant.authen),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          message,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
      ),
      children: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))
      ],
    ),
  );
}
