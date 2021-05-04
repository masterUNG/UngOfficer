import 'package:flutter/material.dart';
import 'package:nugofficer/states/authen.dart';
import 'package:nugofficer/states/my_service.dart';
import 'package:nugofficer/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/myService': (BuildContext context) => MyService(),
};

String initialRoute;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  List<String> users = preferences.getStringList('user');
  print('## users ==>> $users');

  if ((users == null) || (users.length == 0)) {
    initialRoute = '/authen';
    runApp(MyApp());
  } else {
    initialRoute = '/myService';
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: map,
      initialRoute: initialRoute,
      theme: ThemeData(primarySwatch: Colors.green),
      title: MyConstant.appName,
    );
  }
}
