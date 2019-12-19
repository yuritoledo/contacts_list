import 'dart:io';

import 'package:contacts_list/helpers/contact.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactForm extends StatefulWidget {
  final Contact contact;

  ContactForm({this.contact});

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  Contact _contact;
  bool _isDirty = false;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.contact != null) {
      _contact = Contact.fromMap(widget.contact.toMap());

      _nameCtrl.text = _contact.name;
      _emailCtrl.text = _contact.email;
      _phoneCtrl.text = _contact.phone;
    } else {
      setState(() {
        _contact = Contact();
      });
    }
  }

  void _saveContact() {
    final contact = Contact(
        name: _nameCtrl.text, email: _emailCtrl.text, phone: _phoneCtrl.text);

    Navigator.pop(context, contact);
  }

  Future<bool> _checkIsDirty() {
    if (_isDirty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Confirma o cancelamento?"),
              content: Text('Todos os dados editados serão perdidos'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Sim'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('Não'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _checkIsDirty,
      child: Scaffold(
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
              GestureDetector(
                onTap: () async {
                  ImagePicker.pickImage(source: ImageSource.camera)
                      .then((file) {
                    if (file == null) return;

                    setState(() {
                      _contact.img = file.path;
                    });
                  });
                },
                child: Image(
                  image: _contact.img == null
                      ? AssetImage('images/avatar.png')
                      : FileImage(File(_contact.img)),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _nameCtrl,
                  onChanged: (text) {
                    setState(() => _isDirty = true);
                  },
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _emailCtrl,
                  onChanged: (text) {
                    setState(() => _isDirty = true);
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _phoneCtrl,
                  onChanged: (text) {
                    setState(() => _isDirty = true);
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      labelText: 'Telefone', border: OutlineInputBorder()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
