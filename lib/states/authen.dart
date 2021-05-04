import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nugofficer/models/user_model.dart';
import 'package:nugofficer/utility/dialog.dart';
import 'package:nugofficer/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  double size;
  bool statusVisible = true;
  String user, password;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size.width;
    print('size = $size');
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(
            colors: [Colors.white, Colors.green[900]],
            center: Alignment(0, -0.3),
            radius: 0.8,
          )),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildImage(),
                  buildUser(),
                  buildPassword(),
                  buildLogin(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildLogin() {
    return Container(
      width: size * 0.6,
      child: ElevatedButton(
        onPressed: () {
          if ((user?.isEmpty ?? true) || (password?.isEmpty ?? true)) {
            normalDialog(context, 'Have Space ? ', 'Please Fill Every Blank');
          } else {
            checkAuthen();
          }
        },
        child: Text('Login'),
      ),
    );
  }

  Future<Null> checkAuthen() async {
    String api =
        '${MyConstant.domain}/nug/getUserWhereUser.php?isAdd=true&user=$user';

    print('api = $api');
    await Dio().get(api).then((value) async {
      print('###=========== value = $value');
      if (value.toString() == 'null') {
        normalDialog(context, 'User False !!!', 'No $user in my Database');
      } else {
        for (var item in json.decode(value.data)) {
          UserModel model = UserModel.fromMap(item);
          if (password == model.password) {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences
                .setStringList('user', [model.id, model.name, model.user]);
            Navigator.pushNamedAndRemoveUntil(
                context, '/myService', (route) => false);
          } else {
            normalDialog(context, 'Password False', 'Try Again Password False');
          }
        }
      }
    }).catchError(
        (onError) => normalDialog(context, 'AUTHEN FALSE', onError.toString()));
  }

  Container buildUser() {
    return Container(
      decoration: BoxDecoration(color: Colors.white30),
      width: size * 0.6,
      child: TextField(
        onChanged: (value) => user = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.perm_identity),
          labelText: 'User :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      decoration: BoxDecoration(color: Colors.white30),
      margin: EdgeInsets.symmetric(vertical: 16),
      width: size * 0.6,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        obscureText: statusVisible,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              icon: statusVisible
                  ? Icon(Icons.visibility)
                  : Icon(Icons.visibility_outlined),
              onPressed: () {
                setState(() {
                  statusVisible = !statusVisible;
                });
              }),
          prefixIcon: Icon(Icons.lock_outline),
          labelText: 'Password :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildImage() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: size * 0.8,
      child: Image.asset(MyConstant.authen),
    );
  }
}
