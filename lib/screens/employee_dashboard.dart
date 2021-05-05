import 'package:flutter/material.dart';
import 'package:real_app/Object/employee.dart';
import 'package:real_app/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class employee_Dashboard extends StatefulWidget {
  final Employee employee_info;
  employee_Dashboard({@required this.employee_info});
  @override
  _employee_DashboardState createState() => _employee_DashboardState();
}

class _employee_DashboardState extends State<employee_Dashboard> {
  @override
  Widget build(BuildContext context) {
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
            title: Text('Dashboard'),
          ),
          backgroundColor: Colors.deepPurple[200],
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                widget.employee_info.imagelink,
                                scale: 2.5,
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        'ID: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        widget.employee_info.id,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                child: Row(
                                  children: [
                                    Text(
                                      'Name: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      widget.employee_info.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                child: Row(
                                  children: [
                                    Text(
                                      widget.employee_info.gender,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today_outlined),
                                    // Text(
                                    //   'Age: ',
                                    //   style: TextStyle(
                                    //       fontSize: 16,
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    Text(
                                      (DateTime.now().year -
                                              int.parse(widget
                                                  .employee_info.birthday
                                                  .split('-')[2]))
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                child: Row(
                                  children: [
                                    Icon(Icons.phone_android_outlined),
                                    Text(
                                      widget.employee_info.phonenumber,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                child: Row(
                                  children: [
                                    Icon(Icons.email_outlined),
                                    Text(
                                      widget.employee_info.email
                                              .substring(0, 5) +
                                          '..@' +
                                          widget.employee_info.email
                                              .split('@')[1],
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }
}
