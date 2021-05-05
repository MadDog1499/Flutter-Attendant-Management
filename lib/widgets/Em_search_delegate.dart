import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:real_app/models/Employee/employee_info.dart';
import '../style.dart';
import 'package:flutter/cupertino.dart';

class Search extends SearchDelegate {
  @override
  //Khoi tao gia tri tim kiem la ''
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

//Back buttuon
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  final List<String> exampleList, showdata;
  Search(this.exampleList, this.showdata);
  List<String> recentList = [''];

  @override
  Widget buildSuggestions(BuildContext context) {
    //print(exampleList);
    List<String> suggestion = [];
    query.isEmpty
        ? suggestion = recentList
        : suggestion.addAll(exampleList.where(
            (element) => element.toLowerCase().contains(query.toLowerCase())));
    suggestion.toSet().toList();
    List<String> target = [];
    for (int i = 0; i < suggestion.length; i++) {
      for (var item in showdata) {
        if (target.contains(item.split(',').toString())) {
          //Do nothing
        } else {
          if (item.split(',').toList().contains(suggestion[i])) {
            target.add(item.split(',').toString());
          }
        }
      }
    }
    return ListView.builder(
      itemCount: target.length,
      itemBuilder: (context, index) {
        String image_link =
            target[index].split(',')[0].replaceAll('[', '').toString();
        String id = target[index].split(',')[1].toString();
        String name = target[index].split(',')[2].toString();
        String gender = target[index].split(',')[3].toString();
        String birthday = target[index].split(',')[4].toString();
        String phonenumber =
            target[index].split(',')[5].replaceAll(']', '').toString();
        List<String> infolist = [
          image_link,
          id,
          name,
          gender,
          birthday,
          phonenumber
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
                        image_link,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Align(
                  alignment: Alignment.center,
                  child: Text(name + '\n' * 2 + id),
                )),
              ],
            ),
            onTap: () {
              Map<String, String> x = {
                "Image Link": infolist[0],
                'ID': infolist[1],
                "Name": infolist[2],
                'Gender': infolist[3],
                "Birthday": infolist[4],
                'Phone Number': infolist[5],
              };
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Employee_Info(ontap: x)));
              //_showCupertinoDialog(context, infolist);
            },
          ),
        );
      },
    );
  }

  //Must have for change screen but i usr show cuper dialog so it don't need any more
  @override
  Widget buildResults(BuildContext context) {
    String selectedResult;
    return Container(
      child: Center(
        child: Text(selectedResult),
      ),
    );
  }

  _showCupertinoDialog(BuildContext context, List<String> data) {
    //Show list of info widget
    List<Widget> listCard() {
      List<Widget> list = new List();
      list.add(new Image.network(data[0]));
      data.removeAt(0);
      for (var item in data) {
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
                        child: Text(item),
                      )),
                    ],
                  ),
                )))));
      }
      return list;
    }

    //pop-up diaglog
    showDialog(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
              title: new Text(data[2]),
              content: new SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: listCard(),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
}
