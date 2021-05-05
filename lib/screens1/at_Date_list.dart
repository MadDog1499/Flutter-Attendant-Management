import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../style.dart';
import '../models/Attendant/AtEm_List.dart';
import 'dart:math';
import '../widgets/At_search_delegate.dart';

List<String> searchdata = [];

class AttendantList extends StatelessWidget {
  final bool darkTheme;
  AttendantList({this.darkTheme = true});

  /// PROBLEM NEED TO SOLVE HERE descending False
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final color =
        Colors.primaries[Random().nextInt((Colors.primaries.length) - 10)];

    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Attendanted Employee')
              .orderBy(FieldPath.documentId, descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            return GridView.builder(
              itemCount: snapshot.data.documents.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      (orientation == Orientation.portrait) ? 2 : 3),
              itemBuilder: (context, index) => _buildList(
                  context, snapshot.data.documents[index], searchdata),
            );
          }),
    );
  }

  @override
  Widget _buildList(BuildContext context, DocumentSnapshot document,
      List<String> searchdata) {
    final textcolor = this.darkTheme ? TextColorLight : TextColorDark;
    searchdata.add(document.id.toString());
    return Card(
      color: Colors.primaries[Random().nextInt((Colors.primaries.length) - 1)],
      child: ListTile(
          title: Row(
            children: [
              Expanded(
                  child: Align(
                alignment: Alignment.center,
                child: Text(document.id.toString(),
                    style: Theme.of(context).textTheme.headline6),
              )),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EmployeeAttendant(ontap: document.id)));
          }),
    );
  }
}

class AtDate_AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showSearch(
            context: context, delegate: Search(searchdata.toSet().toList()));
      },
      icon: Icon(Icons.search_outlined),
    );
  }
}
