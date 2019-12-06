import 'package:contacts_list/ui/contact_form.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact list',
      home: ContactForm(),
    );
  }
}
