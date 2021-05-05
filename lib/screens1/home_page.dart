import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:real_app/app_localizations.dart';

class HomePage extends StatelessWidget {
  String username;
  String userimage;
  HomePage({this.username, this.userimage});
  static const double _padLR = 5.0;
  final String app_des = '';

  @override
  Widget build(BuildContext context) {
    if (userimage == null) {
      userimage = '';
    }
    if (username == null) {
      username = '';
    }
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //ImageBanner(imglink: userimage),
            Container(
                padding: const EdgeInsets.fromLTRB(_padLR, 10.0, _padLR, 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                          AppLocalizations.of(context).translate('bot_nav_at'),
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    // Center(
                    //   child: Text(username,
                    //       style: Theme.of(context).textTheme.bodyText1),
                    // ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
