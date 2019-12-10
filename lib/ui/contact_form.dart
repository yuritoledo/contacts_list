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

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.contact != null) {
      contact = Contact.fromMap(widget.contact.toMap());

      _nameCtrl.text = contact.name;
      _emailCtrl.text = contact.email;
      _phoneCtrl.text = contact.phone;
    } else {
      contact = Contact();
    }
  }

  Future<void> _saveContact() async {
    final contact = Contact(
      name: _nameCtrl.text,
      email: _emailCtrl.text,
      phone: _phoneCtrl.text,
    );
    final c = await ContactHelper().saveContact(contact);
    print(c);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New contact'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveContact,
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(
                image: contact.img == null
                    ? AssetImage('images/avatar.png')
                    : FileImage(File(contact.img))),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                    labelText: 'Nome', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: 'Email', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    labelText: 'Telefone', border: OutlineInputBorder()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
