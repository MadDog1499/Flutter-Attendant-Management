import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:real_app/services/login.dart';

class ProfileDrawer extends StatelessWidget {
  final String username;
  final String photourl;
  final String email;
  ProfileDrawer({this.username, this.photourl, this.email});
  @override
  Widget build(BuildContext context) {
    final GoogleSignIn _ggSingIn = GoogleSignIn();

    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text(email),
            accountName: Text(username),
            currentAccountPicture:
                CircleAvatar(backgroundImage: NetworkImage(photourl)),
          ),
          // new ListTile(
          //   title: Text('Employee List'),
          //   onTap: () {
          //     //Navigator.of(context).pop();
          //     Navigator.push(
          //         context,
          //         new MaterialPageRoute(
          //             builder: (BuildContext context) => new Employeelist()));
          //   },
          // ),
          // Divider(
          //   color: Colors.black,
          //   height: 5,
          // ),
          ListTile(
            title: Text('Contact'),
            onTap: () {
              Fluttertoast.showToast(msg: 'This function is not available yet');
            },
          ),
          Divider(
            color: Colors.black,
            height: 5,
          ),
          ListTile(
            title: Text('Sign Out'),
            onTap: () {
              _ggSingIn.signOut();
              Fluttertoast.showToast(msg: 'Signed Out\nSee you later :)')
                  .then((value) => Navigator.of(context).pop())
                  .then((value) => Navigator.of(context).pop());

              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => GoogleSignApp()));

              // Navigator.push(
              //     context,
              //     new MaterialPageRoute(
              //         builder: (BuildContext context) => new LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
