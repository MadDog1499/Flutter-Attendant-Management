import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:real_app/models/Attendant/attend_info.dart';
import '../../widgets/EmInAt_search_delegate.dart';
import 'package:real_app/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:real_app/models/Employee/employee_info.dart';

class EmployeeAttendant extends StatelessWidget {
  final String ontap;

  EmployeeAttendant({@required this.ontap});

  @override
  Widget build(BuildContext context) {
    List<String> searchdata = [];
    return MaterialApp(
        supportedLocales: [
          Locale('vi', 'VN'),
          Locale('en', 'US'),
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        home: Hero(
            tag: 'dash',
            child: Scaffold(
              body: FutureBuilder(
                future: _getData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return new Text('Loading...');
                    default:
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      else
                        return createFutureList(context, snapshot, searchdata);
                  }
                },
              ),
              appBar: AppBar(
                centerTitle: true,
                title: Text(ontap),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      print(searchdata.toSet().toList());
                      showSearch(
                          context: context,
                          delegate: Search(
                              searchdata.toSet().toList(),
                              ontap,
                              AppLocalizations.of(context)
                                  .translate('Search_ID')));
                    },
                    icon: Icon(Icons.search_outlined),
                  )
                ],
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            )));
  }

  Widget createFutureList(
      BuildContext context, AsyncSnapshot snapshot, List<String> searchdata) {
    List<String> values = snapshot.data;
    String extract_val = values[0];
    extract_val = extract_val.replaceAll('(', '');
    extract_val = extract_val.replaceAll('_)', '');
    List<String> employeelist = extract_val.split('_');
    searchdata.addAll(employeelist);
    List<FutureBuilder<dynamic>> extractlist = List();
    // for (var item in employee_list) {
    //   dynamic data = getData(ontap, item);
    //   extractlist.add(FutureBuilder(
    //       future: data,
    //       builder: (BuildContext context, AsyncSnapshot snapshot) =>
    //           _info(context, snapshot)));
    //   extractlist.add(data);
    // }
    // for (var employee_id in employee_list) {
    //   dynamic data = getData(ontap, employee_id);

    //   return FutureBuilder(
    //       future: data,
    //       builder: (BuildContext context, AsyncSnapshot snapshot) =>
    //           _info(context, snapshot));
    // }
    // return FutureBuilder(
    //     builder: (BuildContext context, AsyncSnapshot snapshot) => Column(
    //           children: returnWidget,
    //         ));

    return new ListView.builder(
      itemCount: employeelist.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
              title: Row(
                children: [
                  Expanded(
                      child: Align(
                    alignment: Alignment.center,
                    child: Text(employeelist[index].toString(),
                        style: Theme.of(context).textTheme.headline6),
                  )),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AttendInfo(
                              employeeID: employeelist[index],
                              date: ontap,
                            )));
              }),
        );
      },
    );
  }

  Future<List<String>> _getData() async {
    var values = new List<String>();
    FirebaseFirestore.instance
        .collection('Attendanted Employee')
        .doc(ontap.toString())
        .snapshots()
        .forEach((DocumentSnapshot doc) {
      var doc2 = doc.data().values.toString();
      return values.add(doc2);
    });
    return values;
  }

  Future<dynamic> getData(String ontap, String id) async {
    //use a Async-await function to get the data
    var data = (await FirebaseFirestore.instance
        .collection('Attendanted Employee')
        .doc(ontap)
        .collection(id)
        .doc('Info')
        .get()); //get the data
    return data;
  }

  Widget _info(BuildContext context, AsyncSnapshot snapshot) {
    if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
    List data_list = [
      snapshot.data['ID'],
      snapshot.data['Name'],
      snapshot.data['Time']
    ];
    return Card(
      semanticContainer: true,
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Container(
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                  child: Image.network(
                    snapshot.data['Image Link'],
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
                child: Align(
              alignment: Alignment.center,
              child: Text(
                  snapshot.data['Name'] + '\n' * 2 + snapshot.data['Time']),
            )),
          ],
        ),
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => Employee_Info(ontap: document)));
        },
      ),
    );
  }
}
