import 'dart:io';

import 'package:contacts_list/helpers/contact.dart';
import 'package:contacts_list/ui/contact_form.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
    _getAllContacts();
  }

  void _getAllContacts() async {
    final allContacts = await helper.getAllContacts();

    if (allContacts != null) {
      setState(() => list = allContacts);
    }
  }

  Future _showContact({Contact contact}) async {
    final Contact callbackContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactForm(
                  contact: contact,
                )));

    if (callbackContact != null) {
      if (contact == null) {
        await helper.saveContact(callbackContact);
      } else {
        callbackContact.id = contact.id;
        await helper.updateContact(callbackContact);
      }
      _getAllContacts();
    }
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
        onPressed: _showContact,
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => _buildCard(list[index]),
      ),
    );
  }

  Widget _buildCard(Contact contact) {
    return GestureDetector(
      onTap: () => _buildBottomModal(contact),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contact.img != null
                          ? FileImage(File(contact.img))
                          : AssetImage('images/avatar.png'))),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    contact.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    contact.email,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    contact.phone,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _buildBottomModal(Contact contact) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.phone),
                        ),
                        Text('Ligar'),
                      ],
                    ),
                    onPressed: () {
                      launch('tel:${contact.phone}');
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showContact(contact: contact);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.edit),
                        ),
                        Text('Editar')
                      ],
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      helper.deleteContact(contact.id);
                      setState(
                          () => list.removeWhere((c) => c.id == contact.id));
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.delete),
                        ),
                        Text('Excluir')
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        });
  }
}
