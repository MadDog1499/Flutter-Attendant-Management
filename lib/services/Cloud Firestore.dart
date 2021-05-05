import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fluttertoast/fluttertoast.dart';

CollectionReference employee_list =
    FirebaseFirestore.instance.collection('Employee List');

Future<void> updateUserInfo(
    Map<String, String> update_data, String document_ID) {
  ////
  String update_BD, update_gender, update_IL, update_Name, update_PN;

  update_data.forEach((key, value) {
    if (key == 'Birthday') {
      update_BD = update_data[key];
    }
    if (key == 'Gender') {
      update_gender = update_data[key];
    }
    if (key == 'Name') {
      update_Name = update_data[key];
    }
    if (key == 'PhoneNumber') {
      update_PN = update_data[key];
    }
    if (key == 'ImageLink') {
      update_IL = update_data[key];
    }
  });
  //print(update_IL);
  //
  return employee_list
      .doc(document_ID)
      .update({
        'Birthday': update_BD,
        'Gender': update_gender,
        'Phone Number': update_PN,
        'Name': update_Name,
      })
      .then((value) => Fluttertoast.showToast(msg: 'Update Complete'))
      .catchError((error) =>
          Fluttertoast.showToast(msg: '"Failed to update user: $error"'));
}

Future<void> updateUserImageLink(String document_ID, String imagelink) {
  ////
  return employee_list
      .doc(document_ID)
      .update({
        'Image Link': imagelink,
      })
      .then((value) => print('Update Image Link Complete'))
      .catchError((error) => print("Failed to update user: $error"));
}

Future<dynamic> getIDList() async {
  List<String> id_list = [];
  final QuerySnapshot result = await employee_list.get();
  final List<DocumentSnapshot> documents = result.docs;
  documents.forEach((element) {
    id_list.add(element.id);
  });
  return id_list;
}

Future<void> addUser(Map<String, String> add_data) {
  ////

  String name = add_data['Name'].replaceAll(' ', '%20');
  String id = add_data['ID'];
  String update_IL =
      'https://firebasestorage.googleapis.com/v0/b/face-n-fp-recognition.appspot.com/o/Face%20Data%2F' +
          name +
          '_' +
          id +
          '.jpg?alt=media';

  CollectionReference non_fpem =
      FirebaseFirestore.instance.collection('Non_FPEm');

  non_fpem.doc(add_data['ID']).set({
    'ID': add_data['ID'],
  });
  return employee_list
      .doc(add_data['ID'])
      .set({
        'ID': add_data['ID'],
        'Birthday': add_data['Birthday'],
        'Gender': add_data['Gender'],
        'Phone Number': add_data['PhoneNumber'],
        'Name': add_data['Name'],
        'Image Link': update_IL,
      })
      .catchError((error) =>
          Fluttertoast.showToast(msg: '"Failed to create user: $error"'))
      .whenComplete(() => Fluttertoast.showToast(msg: 'Done'));
}

Future<void> deleteEmployee(String id) {
  return employee_list.doc(id).delete();
}
