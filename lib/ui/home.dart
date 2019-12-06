import 'dart:io';

import 'package:contacts_list/helpers/contact.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final helper = ContactHelper();
  List<Contact> list = [];

  @override
  void initState() {
    super.initState();
    helper.getAllContacts().then((f) {
      setState(() {
        list = f;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de contatos'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          return _buildCard(item);
        },
      ),
    );
  }

  Widget _buildCard(Contact item) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: item.img != null
                        ? FileImage(File(item.img))
                        : AssetImage('images/avatar.png'))),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  item.email,
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  item.phone,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
