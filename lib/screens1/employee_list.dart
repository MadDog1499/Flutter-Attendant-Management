import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:real_app/models/Employee/Add_Em.dart';
import '../widgets/Em_search_delegate.dart';
import '../models/Employee/employee_info.dart';

List<String> datalist = new List<String>();
List<String> datashow = new List<String>();

class Employeelist extends StatefulWidget {
  @override
  _EmployeelistState createState() => _EmployeelistState();
}

class _EmployeelistState extends State<Employeelist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('Employee List').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return Hero(
              tag: 'dash',
              child: ListView.builder(
                itemExtent: 120.0,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) => _buildList(context,
                    snapshot.data.documents[index], datalist, datashow),
              ));
        },
      ),
    );
  }

  @override
  Widget _buildList(BuildContext context, DocumentSnapshot document,
      List<String> datalist, List<String> datashow) {
    List<String> templist = [
      document['ID'],
      document['Name'],
      document['Gender'],
      document['Birthday'],
      document['Phone Number']
    ];
    String data =
        '[${document['Image Link'].toString()},${document['ID']},${document['Name']},${document['Gender']},${document['Birthday']},${document['Phone Number']}]';
    datashow.add(data);
    datalist.addAll(templist.toList());

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
                    document['Image Link'],
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            //Text(document['Name']), Text(document['ID'])
            Expanded(
                child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: Text(
                      document['Name'],
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Text(
                      document['ID'],
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            )),
          ],
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Employee_Info(ontap: document)));
        },
      ),
    );
  }
}

class EmList_AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: () {
            showSearch(
                context: context,
                delegate: Search(
                    datalist.toSet().toList(), datashow.toSet().toList()));
          },
          icon: Icon(Icons.search_outlined),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Add_Employee()));
          },
          icon: Icon(Icons.add_box),
        )
      ],
    );
  }
}
