import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:real_app/services/Cloud%20Firestore.dart';
import 'package:real_app/services/Firebase%20Storage.dart';
import '../../style.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:real_app/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Add_Employee extends StatefulWidget {
  @override
  _Employee_InfoState createState() => _Employee_InfoState();
}

class _Employee_InfoState extends State<Add_Employee> {
  //Timer
  Timer _timer;
  //Gender
  List<String> gender = [
    'Man',
    'Woman',
    'Other',
  ];
  //Mapping old data
  Map<String, String> a = {};
  //Entry state
  dynamic state = false;
  final List datalist = ['ID', 'Name', 'Phone Number', 'Birthday', 'Gender'];
  //Date
  String date;
  DateFormat formatter = DateFormat('dd-MM-yyyy');
  //Entry Controller
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final birthdayController = TextEditingController();
  final phonenumberController = TextEditingController();
  dynamic controller;
  //Birthday select
  DateTime selectedDate = DateTime.now();
  //Image pick
  File _imagepath, imagefile;
  final picker = ImagePicker();
  PickedFile pickedFile;
  bool checkIMG = false;

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
              print(supportedLocale.countryCode);
              print(supportedLocale.languageCode);
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
                  title:
                      Text(AppLocalizations.of(context).translate('Create_Em')),
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
    Widget employeeimage;
    if (_imagepath == null) {
      employeeimage = Image.network(
        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Icons8_flat_add_image.svg/1024px-Icons8_flat_add_image.svg.png',
        height: 200,
      );
    } else {
      employeeimage = Image.file(_imagepath);
    }
    List<Widget> list = new List();
    list.add(
      InkWell(
          onTap: () {
            getImage();
          },
          child: Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: employeeimage))),
    );
    //Binding TIME
    int maxlength;
    dynamic inputtype;
    String label;
    for (var item in datalist) {
      if (item == 'ID') {
        maxlength = 10;
        controller = idController;
        inputtype = TextInputType.number;
        label = AppLocalizations.of(context).translate('ID');
      }
      if (item == 'Gender') {
        maxlength = 10;
        controller = genderController;
        inputtype = TextInputType.text;
        label = AppLocalizations.of(context).translate('Gender');
      }
      if (item == 'Name') {
        maxlength = 30;
        controller = nameController;
        inputtype = TextInputType.name;
        label = AppLocalizations.of(context).translate('Name');
      }
      if (item == 'Birthday') {
        maxlength = 10;
        controller = birthdayController;
        inputtype = TextInputType.number;
        label = AppLocalizations.of(context).translate('Birthday');
      }
      if (item == 'Phone Number') {
        maxlength = 10;
        controller = phonenumberController;
        inputtype = TextInputType.number;
        label = AppLocalizations.of(context).translate('PhoneNumber');
      }
      if (item == 'Birthday') {
        if (date == null) {
          date = formatter.format(selectedDate);
        }
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
                        child: Text(label),
                      )),
                      Expanded(
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(date),
                                  SizedBox(
                                    width: 5,
                                  ),
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
      } else {
        if (item == 'Gender') {
          label = AppLocalizations.of(context).translate('Gender');
          list.add(new Padding(
              padding: EdgeInsets.symmetric(vertical: 1.0),
              child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: DefaultPaddingHorizontal),
                  child: Card(
                      child: ListTile(
                    title: Row(
                      children: [
                        Expanded(
                            child: Align(
                          alignment: Alignment.center,
                          child: Text(label),
                        )),
                        Expanded(
                            child: Align(
                                alignment: Alignment.center,
                                child: DropDownField(
                                  items: gender,
                                  controller: controller,
                                ))),
                      ],
                    ),
                  )))));
        } else {
          list.add(new Padding(
              padding: EdgeInsets.symmetric(vertical: 1.0),
              child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: DefaultPaddingHorizontal),
                  child: Card(
                      child: ListTile(
                    title: Row(
                      children: [
                        Expanded(
                            child: Align(
                          alignment: Alignment.center,
                          child: Text(label),
                        )),
                        Expanded(
                            child: Align(
                          alignment: Alignment.center,
                          child: TextField(
                            keyboardType: inputtype,
                            controller: controller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            maxLength: maxlength,
                          ),
                        )),
                      ],
                    ),
                  )))));
        }
      }
    }

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
            borderSide: BorderSide(color: Colors.green),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.create,
                    color: Colors.green,
                    size: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Create Employee',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                      ),
                    ),
                  )
                ],
              ),
            ),
            onPressed: () {
              a['ID'] = idController.text;
              a['Name'] = nameController.text;
              a['Gender'] = genderController.text;
              a['Birthday'] = date;
              a['PhoneNumber'] = phonenumberController.text;
              a['ImageLink'] = _imagepath.toString();
              String name = a['Name'];
              String id = a['ID'];

              ///Chechk before add
              if (_imagepath == null) {
                showerror(
                    AppLocalizations.of(context).translate('Not_pick_image'));
              } else {
                getIDList().then((value) => {
                      if (value.contains(a['ID']))
                        {
                          showerror(AppLocalizations.of(context)
                              .translate('ID_exist'))
                        }
                      else
                        {
                          a.forEach((key, value) {
                            if (key == 'ID') {
                              if (a[key].length < 10) {
                                showerror(AppLocalizations.of(context)
                                    .translate('ID_error'));
                              }
                            } else {
                              if (key == 'Name') {
                                if (a[key] == '') {
                                  showerror(AppLocalizations.of(context)
                                      .translate('Name_error'));
                                }
                              } else {
                                if (key == 'Birthday') {
                                  if (a[key] == '') {
                                    showerror(AppLocalizations.of(context)
                                        .translate('Birthday_error'));
                                  }
                                } else {
                                  if (key == 'PhoneNumber') {
                                    if (a[key].length < 10) {
                                      showerror(AppLocalizations.of(context)
                                          .translate('Phone_error'));
                                    }
                                  } else {
                                    if (key == 'Gender') {
                                      if (a[key] == '') {
                                        showerror(AppLocalizations.of(context)
                                            .translate('Gender_error'));
                                      }
                                    }
                                    String filename = '$name' + '_$id.jpg';

                                    return showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          _timer =
                                              Timer(Duration(seconds: 2), () {
                                            Navigator.of(context).pop();
                                          });
                                          return SpinKitCircle(
                                            color: Colors.green,
                                            size: 86,
                                          );
                                        }).then((val) {
                                      if (_timer.isActive) {
                                        _timer.cancel();
                                      }
                                    }).whenComplete(() => addUser(a).then(
                                        (value) => uploadFile(
                                                _imagepath, filename)
                                            .whenComplete(() =>
                                                Navigator.of(context).pop())
                                            .then((value) => Fluttertoast.showToast(
                                                msg:
                                                    'Add Employee Complete'))));
                                  }
                                }
                              }
                            }
                          })
                        }
                    });
              }
            },
          )
        ],
      ),
    );
    return list;
  }

  Future getImage() async {
    pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        checkIMG = true;
        _imagepath = File(pickedFile.path);
        print(_imagepath);
      } else {
        print('No image selected.');
      }
    });
  }

  Future showerror(String error) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Center(
              child: Text(AppLocalizations.of(context).translate('Error')),
            ),
            content: new Text('$error'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

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
}
