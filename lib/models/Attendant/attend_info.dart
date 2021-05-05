import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:real_app/widgets/image_banner.dart';
import '../../style.dart';
import 'package:real_app/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AttendInfo extends StatelessWidget {
  final String employeeID;
  final String date;
  DocumentSnapshot snapshot;
  AttendInfo({@required this.employeeID, @required this.date});
  Future<dynamic> getData() async {
    //use a Async-await function to get the data
    var data = (await FirebaseFirestore.instance
        .collection('Attendanted Employee')
        .doc(date.toString())
        .collection(employeeID.toString())
        .doc('Info')
        .get()); //get the data
    return data;
  }

  @override
  Widget build(BuildContext context) {
    getData();
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
        home: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: Text(employeeID),
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.0),
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: DefaultPaddingHorizontal),
                      child: Card(
                        child: ListTile(
                          title: FutureBuilder(
                              future: getData(),
                              builder: (BuildContext context,
                                      AsyncSnapshot snapshot) =>
                                  _info(context, snapshot)),
                        ), //ok no errors.
                      )),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _info(BuildContext context, AsyncSnapshot snapshot) {
    if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
    List datalist = [
      snapshot.data['ID'],
      snapshot.data['Name'],
      snapshot.data['Time']
    ];
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.0),
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: DefaultPaddingHorizontal),
              //child: Card(
              child: ListTile(
                  title: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ImageBanner(
                        imglink: snapshot.data['Image Link'],
                      ),
                    ),
                  ),
                ],
              )),
              //),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0),
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: DefaultPaddingHorizontal),
              child: Card(
                child: ListTile(
                    title: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child:
                            Text(AppLocalizations.of(context).translate('ID')),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(datalist[0]),
                      ),
                    ),
                  ],
                )),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0),
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: DefaultPaddingHorizontal),
              child: Card(
                child: ListTile(
                    title: Row(
                  children: [
                    Expanded(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                              AppLocalizations.of(context).translate('Name'))),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(datalist[1]),
                      ),
                    ),
                  ],
                )),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0),
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: DefaultPaddingHorizontal),
              child: Card(
                child: ListTile(
                    title: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(AppLocalizations.of(context)
                            .translate('Record_Time')),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(datalist[2]),
                      ),
                    ),
                  ],
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
