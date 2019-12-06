import 'dart:io';

import 'package:contacts_list/helpers/contact.dart';
import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  final Contact contact;

  ContactForm({this.contact});

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  Contact contact;

  @override
  void initState() {
    super.initState();

    if (widget.contact != null) {
      contact = Contact.fromMap(widget.contact.toMap());
    } else {
      contact = Contact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New contact'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: Column(
          children: <Widget>[
            Image(
                image: contact.img == null
                    ? AssetImage('images/avatar.png')
                    : FileImage(File(contact.img)))
          ],
        ),
      ),
    );
  }
}
