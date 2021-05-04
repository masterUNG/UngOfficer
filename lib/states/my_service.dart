import 'package:flutter/material.dart';
import 'package:nugofficer/utility/my_constant.dart';
import 'package:nugofficer/widgets/information.dart';
import 'package:nugofficer/widgets/list_job.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyService extends StatefulWidget {
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  List<String> users;
  List<String> titles = ['List Job', 'Information User'];
  List<Widget> widgets = [ListJob(), Information()];
  int index = 0;

  @override
  void initState() {
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      users = preferences.getStringList('user');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: Stack(
          children: [
            buildSignOut(),
            Column(
              children: [
                buildUser(),
                buildMenuListJob(),
                buildMenuInformation(),
              ],
            )
          ],
        ),
      ),
      body: widgets[index],
    );
  }

  ListTile buildMenuListJob() {
    return ListTile(
      leading: Icon(Icons.filter_1),
      title: Text(titles[0]),
      onTap: () {
        setState(() {
          index = 0;
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile buildMenuInformation() {
    return ListTile(
      leading: Icon(Icons.filter_2),
      title: Text(titles[1]),
      onTap: () {
        setState(() {
          index = 1;
        });
        Navigator.pop(context);
      },
    );
  }

  UserAccountsDrawerHeader buildUser() {
    return UserAccountsDrawerHeader(
      accountName: Text(users == null ? 'Name ?' : users[1]),
      accountEmail: Text('Login'),
      currentAccountPicture: Image.asset(MyConstant.authen),
    );
  }

  Column buildSignOut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear();
            Navigator.pushNamedAndRemoveUntil(
                context, '/authen', (route) => false);
          },
          tileColor: Colors.red[700],
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.white,
            size: 36,
          ),
          title: Text(
            'Sign Out',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
