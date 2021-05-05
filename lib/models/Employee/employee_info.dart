import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../style.dart';
import 'package:real_app/services/Firebase Storage.dart';
import '../../services/Cloud Firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:real_app/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Employee_Info extends StatefulWidget {
  final dynamic ontap;

  Employee_Info({@required this.ontap});

  @override
  _Employee_InfoState createState() => _Employee_InfoState();
}

class _Employee_InfoState extends State<Employee_Info> {
  /////////////////////////////////////////////////////
  ////////////////   KHAI   BAO ///////////////////////
  /////////////////////////////////////////////////////
  Timer _timer;
  List<String> gender = [
    'Man',
    'Woman',
    'Other',
  ];
  //Mapping old data
  Map<String, String> a = {};
  //Entry state
  bool state = false;
  final List data_list = [
    'ID',
    'Name',
    'Phone Number',
    'Birthday',
    'Gender',
  ];
  //Entry Controller
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final birthdayController = TextEditingController();
  final phonenumberController = TextEditingController();
  dynamic controller;
  //Image pick
  File _imagepath, imagefile;
  final picker = ImagePicker();
  PickedFile pickedFile;
  bool check_change_IMG = false;
  //Birthday pick
  DateTime selectedDate = DateTime.now();
  String date;
  DateFormat formatter = DateFormat('dd-MM-yyyy');
  ////////////////////////////////////////////////
  //////////  Giao dien  /////////////////////////////
  ////////////////////////////////////////////////

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
        home: Hero(
            tag: 'dash',
            child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(widget.ontap['Name']),
                  leading: new IconButton(
                    icon: new Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: listCard(),
                  ),
                ))));
  }

  List<Widget> listCard() {
    Widget em_image;

    if (_imagepath == null) {
      em_image = Image.network(widget.ontap['Image Link']);
    } else {
      em_image = Image.file(_imagepath);
    }
    List<Widget> list = new List();
    list.add(
      InkWell(
          onTap: () {
            getImage();
          },
          child: Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0), child: em_image))),
    );
    //Binding TIME
    int maxlength;
    dynamic inputtype;
    final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
    for (var item in data_list) {
      if (item == 'Birthday') {
        if (date == null) {
          date = widget.ontap['Birthday'].toString();
        }
        maxlength = 10;
        controller = birthdayController;

        list.add(new Padding(
            padding: EdgeInsets.symmetric(vertical: 1.0),
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
                            AppLocalizations.of(context).translate('Birthday')),
                      )),
                      Expanded(
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(date),
                                  ButtonTheme(
                                    minWidth: 50,
                                    child: RaisedButton(
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('Select'),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      color: Colors.lightGreen,
                                      onPressed: () => _selectDate(context),
                                    ),
                                  )
                                ],
                              ))),
                    ],
                  ),
                )))));
        continue;
      }
      if (item == 'ID') {
        maxlength = 10;
        controller = idController;
        list.add(new Padding(
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
                      )),
                      Expanded(
                          child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.ontap[item.toString()].toString(),
                        ),
                      ))
                    ],
                  ),
                )))));
        continue;
      }
      if (item == 'Gender') {
        maxlength = 10;
        controller = genderController;
        list.add(new Padding(
            padding: EdgeInsets.symmetric(vertical: 1.0),
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
                            AppLocalizations.of(context).translate('Gender')),
                      )),
                      Expanded(
                          child: Align(
                              alignment: Alignment.center,
                              child: DropDownField(
                                enabled: state,
                                items: gender,
                                controller: controller,
                                hintText:
                                    widget.ontap[item.toString()].toString(),
                              ))),
                    ],
                  ),
                )))));
        continue;
      }
      if (item == 'Name') {
        maxlength = 50;
        controller = nameController;
        inputtype = TextInputType.name;
        list.add(new Padding(
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
                            AppLocalizations.of(context).translate('Name')),
                      )),
                      Expanded(
                          child: Align(
                        alignment: Alignment.center,
                        child: TextField(
                          controller: controller,
                          enabled: state,
                          keyboardType: inputtype,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: widget.ontap[item.toString()].toString(),
                          ),
                          maxLength: maxlength,
                        ),
                      ))
                    ],
                  ),
                )))));
      }
      if (item == 'Phone Number') {
        maxlength = 10;
        controller = phonenumberController;
        inputtype = TextInputType.phone;
        list.add(new Padding(
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
                            .translate('PhoneNumber')),
                      )),
                      Expanded(
                          child: Align(
                        alignment: Alignment.center,
                        child: TextField(
                          controller: controller,
                          enabled: state,
                          keyboardType: inputtype,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: widget.ontap[item.toString()].toString(),
                          ),
                          maxLength: maxlength,
                        ),
                      ))
                    ],
                  ),
                )))));
      }
    }
    list.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: OutlineButton(
                splashColor: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                highlightElevation: 0,
                borderSide: BorderSide(color: Colors.amber),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.settings,
                        size: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          AppLocalizations.of(context).translate('Edit_Info'),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.amber,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                onPressed: () {
                  Fluttertoast.showToast(
                      msg: AppLocalizations.of(context).translate('Edit_mess'));

                  setState(() {
                    state = true;
                  });
                }),
          ),
          Expanded(
            child: OutlineButton(
                splashColor: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                highlightElevation: 0,
                borderSide: BorderSide(color: Colors.green),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.save_sharp,
                        color: Colors.green,
                        size: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          AppLocalizations.of(context).translate('Save_Change'),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                onPressed: () {
                  //Kiểm tra dữ liệu nào thay đổi để còn biết mà cập nhật.
                  setState(() {
                    onUpdate();
                    state = false;
                  });
                }),
          ),
        ],
      ),
    );
    list.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 5.0),
          OutlineButton(
            splashColor: Colors.grey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            highlightElevation: 0,
            borderSide: BorderSide(color: Colors.red),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                    size: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      AppLocalizations.of(context).translate('Delete_Em'),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ),
            onPressed: () {
              return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: new Text(
                          AppLocalizations.of(context).translate('Confirm')),
                      content: new Text(AppLocalizations.of(context)
                          .translate('Delete_Em_Confirm')),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Text(
                              AppLocalizations.of(context).translate('Cancel')),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        new FlatButton(
                          child: new Text(
                              AppLocalizations.of(context).translate('Delete')),
                          onPressed: () {
                            String name = widget.ontap['Name'].toString();
                            String id = widget.ontap['ID'].toString();
                            String filename = '$name' + '_$id.jpg';
                            deleteEmployee(widget.ontap['ID'].toString())
                                .whenComplete(() => deleteFile(filename)
                                    .whenComplete(
                                        () => Navigator.of(context).pop())
                                    .whenComplete(
                                        () => Navigator.of(context).pop()));

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => HomeScreen()),
                            // );
                          },
                        )
                      ],
                    );
                  });
            },
          )
        ],
      ),
    );

    return list;
  }

  ///////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////// Chuc nang /////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1990),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        date = formatter.format(selectedDate);
      });
    }
  }

  Future getImage() async {
    pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        print('Get image');
        check_change_IMG = true;
        _imagepath = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future onUpdate() async {
    //Old data
    a['ImageLink'] = widget.ontap['Image Link'].toString();
    a['ID'] = widget.ontap['ID'].toString();
    a['Name'] = widget.ontap['Name'].toString();
    a['Gender'] = widget.ontap['Gender'].toString();
    a['Birthday'] = widget.ontap['Birthday'].toString();
    a['PhoneNumber'] = widget.ontap['Phone Number'].toString();
    //Document Id To Update or delete
    String document_Id = widget.ontap['ID'].toString();

    for (var key in a.keys) {
      print(key);
      if (key == 'Name') {
        if (nameController.text == '') {
          continue;
        } else {
          a[key] = nameController.text;
        }
      }
      if (key == 'Gender') {
        if (genderController.text == '') {
          continue;
        } else {
          a[key] = genderController.text;
        }
      }
      if (key == 'Birthday') {
        a[key] = date;
        print(date);
      }
      if (key.toString() == 'PhoneNumber') {
        if (phonenumberController.text == '') {
          continue;
        } else {
          a[key] = phonenumberController.text;
        }
      }
    }

    print('------------------');

    ///cHANGE IMAGE if pick new one
    if (document_Id == a['ID']) {
      // return showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       _timer = Timer(Duration(seconds: 2), () {
      //         Navigator.of(context).pop();
      //       });
      //       return SpinKitCircle(
      //         color: Colors.green,
      //         size: 86,
      //       );
      //     }).then((val) {
      //   if (_timer.isActive) {
      //     _timer.cancel();
      //   }
      // })
      //Check if pick new image
      if (check_change_IMG) {
        String name;
        if (nameController.text == '') {
          name = widget.ontap['Name'];
        } else {
          name = nameController.text;
        }
        String filename = '$name' + '_$document_Id.jpg';
        String filename_fixed =
            ('$name' + '_$document_Id').toString().replaceAll(' ', '%20');
        String head = a['ImageLink'].split('%2F')[0] + '%2F';
        String tail = '.' + a['ImageLink'].split('%2F')[1].split('.')[1];
        String updatelink = head + filename_fixed + tail;
        uploadFile(_imagepath, filename)
            .then((value) => updateUserImageLink(document_Id, updatelink));
      }
      //Check if change name
      if (a['Name'].toString() != widget.ontap['Name'].toString()) {
        String old_name = widget.ontap['Name'].toString() +
            '_' +
            widget.ontap['ID'].toString() +
            '.jpg';

        ///New_name
        String new_name =
            a['Name'].toString() + '_' + a['ID'].toString() + '.jpg';

        ///MAGIC IN HERE
        String name;
        if (nameController.text == '') {
          name = widget.ontap['Name'];
        } else {
          name = nameController.text;
        }
        String filename_fixed =
            ('$name' + '_$document_Id').toString().replaceAll(' ', '%20');
        String head = a['ImageLink'].split('%2F')[0] + '%2F';
        String tail = '.' + a['ImageLink'].split('%2F')[1].split('.')[1];
        String updatelink = head + filename_fixed + tail;
        print(old_name);
        // return showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       _timer = Timer(Duration(seconds: 2), () {
        //         Navigator.of(context).pop();
        //       });
        //       return SpinKitCircle(
        //         color: Colors.green,
        //         size: 86,
        //       );
        //     }).then((val) {
        //   if (_timer.isActive) {
        //     _timer.cancel();
        //   }
        // }).then((value) => singleDownload(widget.ontap['Image Link'], new_name)
        //     .then((value) => deleteFile(old_name))
        //     .then((value) => updateUserImageLink(document_Id, updatelink))
        //     .whenComplete(() => Navigator.of(context).pop())
        //     .then((value) =>
        //         Fluttertoast.showToast(msg: 'Add Employee Complete')));

        singleDownload(widget.ontap['Image Link'], new_name, old_name,
            document_Id, updatelink);
      }
      updateUserInfo(a, document_Id);
    }
  }
}
