import 'package:flutter/material.dart';
import 'package:real_app/services/login.dart';
import 'employee_list.dart';
import 'at_Date_list.dart';
import '../screens1/home_page.dart';
import 'info.dart';
import 'package:real_app/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class HomeScreen extends StatefulWidget {
  final UserDetails userDetails;
  HomeScreen({Key key, @required this.userDetails}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current_index = 0;
  dynamic _background;
  Widget _currentWidget = HomePage();
  Widget _profile;
  List<Widget> _currenSearchAppBar = [];
  String _title;
  @override
  Widget build(BuildContext context) {
    String _title = AppLocalizations.of(context).translate('bot_nav_home');
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
              print(supportedLocale.countryCode);
              print(supportedLocale.languageCode);
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(_title),
              automaticallyImplyLeading: false,
              backgroundColor: _background,
              actions: _currenSearchAppBar,
            ),
            //Main Funciton
            body: _currentWidget,
            //Side Profile
            endDrawer: _profile,
            //Bottom menu
            bottomNavigationBar: Builder(builder: (BuildContext context) {
              return BottomNavigationBar(
                currentIndex: _current_index,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: _background,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label:
                        AppLocalizations.of(context).translate('bot_nav_home'),
                    backgroundColor: _background,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.group_sharp),
                    label: AppLocalizations.of(context).translate('bot_nav_em'),
                    backgroundColor: _background,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.business_sharp),
                    label: AppLocalizations.of(context).translate('bot_nav_at'),
                    backgroundColor: _background,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_box_sharp),
                    label: AppLocalizations.of(context)
                        .translate('bot_nav_profile'),
                    backgroundColor: _background,
                  ),
                ],
                //ontap action
                onTap: (index) {
                  setState(() {
                    _current_index = index;
                  });
                  switch (index) {
                    case 0:
                      _title = AppLocalizations.of(context)
                          .translate('bot_nav_home');
                      _background = Colors.blue;
                      _currentWidget = HomePage(
                        userimage: widget.userDetails.photoUrl,
                        username: widget.userDetails.userName,
                      );
                      _currenSearchAppBar = [];
                      _profile = ProfileDrawer();
                      break;
                    case 1:
                      _title = AppLocalizations.of(context)
                          .translate('bot_nav_em')
                          .toString();
                      _background = Colors.green;
                      _currentWidget = Employeelist();
                      _currenSearchAppBar = [EmList_AppBar()];
                      break;
                    case 2:
                      _title =
                          AppLocalizations.of(context).translate('bot_nav_at');
                      _background = Colors.amber;
                      _currentWidget = AttendantList();
                      _currenSearchAppBar = [AtDate_AppBar()];
                      break;
                    case 3:
                      _title = AppLocalizations.of(context)
                          .translate('bot_nav_profile');
                      _background = Colors.cyan;
                      _profile = ProfileDrawer(
                        username: widget.userDetails.userName,
                        photourl: widget.userDetails.photoUrl,
                        email: widget.userDetails.userEmail,
                      );
                      Scaffold.of(context).openEndDrawer();
                      break;
                    default:
                  }
                },
              );
            })));
  }
}

class AddItemWidget extends StatefulWidget {
  @override
  _AddItemWidgetState createState() => _AddItemWidgetState();
}

class _AddItemWidgetState extends State<AddItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
