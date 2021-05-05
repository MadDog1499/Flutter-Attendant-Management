import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:real_app/Object/employee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:real_app/screens/employee_dashboard.dart';

CollectionReference employee_list =
    FirebaseFirestore.instance.collection('Employee List');

Future<void> sign_in(User_SignIn sign_in_info, BuildContext context) async {
  List invalid_char = [
    '`',
    '~',
    '!',
    '@',
    '#',
    '\$',
    '%',
    '^',
    '&',
    '*',
    '(',
    ')',
    '_',
    '-',
    '+',
    '=',
    '[',
    ']',
    '{',
    '}',
    '\\',
    '|',
    ';',
    ':',
    '\'',
    '"',
    ',',
    '<',
    '.',
    '>',
    '/',
    '?',
    ' '
  ];
  //
  //Username
  //
  // if (sign_in_info.username.length == 0) {
  //   Fluttertoast.showToast(msg: "Username can not be empty !");
  // } else {
  //   for (var char in invalid_char) {
  //     if (sign_in_info.username.contains(char)) {
  //       Fluttertoast.showToast(msg: "Username contain invalid character !");
  //       break;
  //     }
  //   }
  // }
  //
  //Password
  //
  // if (sign_in_info.password.length == 0) {
  //   Fluttertoast.showToast(msg: "Password can not be empty !");
  // } else {
  //   for (var char in invalid_char) {
  //     if (sign_in_info.password.contains(char)) {
  //       Fluttertoast.showToast(msg: "Password contain invalid character !");
  //       break;
  //     }
  //   }
  // }
  //
  // Verified
  //
  final DocumentSnapshot result = await employee_list.doc('1711062293').get();
  Map<String, dynamic> receive_data = result.data();
  Employee employee_info = new Employee(
      receive_data['ID'],
      receive_data['Name'],
      receive_data['Gender'],
      receive_data['Birthday'],
      receive_data['Phone Number'],
      receive_data['Email'],
      receive_data['Image Link']);
  Navigator.push(
    context,
    new MaterialPageRoute(
      builder: (context) =>
          new employee_Dashboard(employee_info: employee_info),
    ),
  );
}
