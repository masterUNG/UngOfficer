import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nugofficer/models/job_model.dart';
import 'package:nugofficer/utility/my_constant.dart';
import 'package:nugofficer/widgets/show_progress.dart';
import 'package:nugofficer/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_indicator/steps_indicator.dart';

class ListJob extends StatefulWidget {
  @override
  _ListJobState createState() => _ListJobState();
}

class _ListJobState extends State<ListJob> {
  List<String> users;
  bool load = true;
  bool haveData;
  List<JobModel> jobModels = [];
  String status;
  bool statusProcess = false;

  @override
  void initState() {
    super.initState();
    readDataJob();
  }

  Future<Null> readDataJob() async {
    if (jobModels.length != 0) {
      jobModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    users = preferences.getStringList('user');

    String api =
        '${MyConstant.domain}/nug/getJobWhereId.php?isAdd=true&idUser=${users[0]}';

    print('########## api onlistjob ==>  $api');

    await Dio().get(api).then((value) {
      // print('value ==>> $value');

      if (value.toString() == 'null') {
        setState(() {
          haveData = false;
          load = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          JobModel model = JobModel.fromMap(item);
          setState(() {
            jobModels.add(model);
            statusProcess = false;
            haveData = true;
            load = false;
          });
        }
      }
    });
  }

  String cutWord(String string) {
    String result = string;
    if (result.length > 50) {
      result = result.substring(0, 50);
      result = '$result ...';
    }
    return result;
  }

  Future<Null> confirmDialog(JobModel jobModel) async {
    status = jobModel.status;
    List<String> titles = MyConstant.listStatus;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SimpleDialog(
          title: ListTile(
            leading: Image.asset(MyConstant.authen),
            title: ShowTitle(title: jobModel.nameJob, indexStyle: 1),
            subtitle: ShowTitle(title: 'Detail :', indexStyle: 2),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShowTitle(title: jobModel.detailJob, indexStyle: 2),
            ),
            RadioListTile(
              value: '0',
              groupValue: status,
              onChanged: (value) {
                setState(() {
                  status = value;
                });
              },
              title: Text(titles[0]),
            ),
            RadioListTile(
              value: '1',
              groupValue: status,
              onChanged: (value) {
                setState(() {
                  status = value;
                });
              },
              title: Text(titles[1]),
            ),
            RadioListTile(
              value: '2',
              groupValue: status,
              onChanged: (value) {
                setState(() {
                  status = value;
                });
              },
              title: Text(titles[2]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    processEdit(jobModel, status);
                    Navigator.pop(context);
                  },
                  child: Text('Update'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? ShowProgress()
          : haveData
              ? Stack(
                  children: [
                    buildListView(),
                    statusProcess ? ShowProgress() : SizedBox(),
                  ],
                )
              : Center(
                  child: Text('No Job'),
                ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      itemCount: jobModels.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => confirmDialog(jobModels[index]),
        child: Card(
          color: index % 2 == 0 ? Colors.grey[300] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShowTitle(
                  title: jobModels[index].nameJob,
                  indexStyle: 1,
                ),
                SizedBox(
                  height: 16,
                ),
                StepsIndicator(
                  lineLength: 100,
                  nbSteps: 3,
                  selectedStep: findStatus(jobModels[index].status),
                ),
                buildTitleStatus(),
                SizedBox(
                  height: 16,
                ),
                ShowTitle(
                    title: cutWord(jobModels[index].detailJob), indexStyle: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTitleStatus() {
    List<String> titles = MyConstant.listStatus;
    List<Widget> widgets = [];

    for (var item in titles) {
      widgets.add(Text(item));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 350,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widgets,
          ),
        ),
      ],
    );
  }

  int findStatus(String status) {
    String result = status.trim();
    int select = int.parse(result);
    return select;
  }

  Future<Null> processEdit(JobModel jobModel, String status) async {
    setState(() {
      statusProcess = true;
    });

    String api =
        '${MyConstant.domain}/nug/editStatusWhereId.php?isAdd=true&id=${jobModel.id}&status=$status';
    await Dio().get(api).then((value) => readDataJob());
  }
}
