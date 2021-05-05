import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:real_app/models/Attendant/attend_info.dart';
import 'dart:math';
import '../models/Attendant/AtEm_List.dart';

class Search extends SearchDelegate {
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

  @override
  //Khoi tao gia tri tim kiem la ''
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.sort),
        onPressed: () {
          query = "";
        },
      ),
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

  final List<String> exampleList;
  final String date;
  final String hint;
  @override
  Search(this.exampleList, this.date, this.hint)
      : super(searchFieldLabel: hint);
  List<String> recentList = [''];

  @override
  Widget buildSuggestions(BuildContext context) {
    print(exampleList);
    final orientation = MediaQuery.of(context).orientation;
    List<String> suggestion = [];
    query.isEmpty
        ? suggestion = recentList
        : suggestion.addAll(exampleList.where(
            (element) => element.toLowerCase().contains(query.toLowerCase())));
    suggestion.toSet().toList();
    return GridView.builder(
        itemCount: suggestion.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
        itemBuilder: (context, index) => _gridData(context, suggestion[index]));
  }

  Widget _gridData(BuildContext context, String data) {
    return Card(
      color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      child: ListTile(
          title: Row(
            children: [
              Expanded(
                  child: Align(
                alignment: Alignment.center,
                child: Text(data, style: Theme.of(context).textTheme.headline6),
              )),
            ],
          ),
          onTap: () {
            if (data == '') {
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AttendInfo(
                            employeeID: data,
                            date: date,
                          )));
            }
          }),
    );
  }
}
