import 'package:bytebank/contact.dart';
import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  final Contact contact;

  const ContactForm({Key key, this.contact}) : super(key: key);

  @override
  _ContactFormState createState() => _ContactFormState(contact);
}

class _ContactFormState extends State<ContactForm> {
  final ContactDao _contactDao = ContactDao();

  final Contact _contact;

  int _idContact = 0;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();

  _ContactFormState(this._contact);

  @override
  void initState() {
    if (this._contact != null) {
      this._idContact = this._contact.id;
      this._nameController.text = this._contact.name;
      this._accountNumberController.text =
          this._contact.accountNumber.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New contact'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Full name'),
              style: TextStyle(fontSize: 24.0),
              keyboardType: TextInputType.text,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _accountNumberController,
                decoration: InputDecoration(labelText: 'Account number'),
                style: TextStyle(fontSize: 24.0),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  child: Text('Create'),
                  onPressed: () {
                    final int account =
                        int.tryParse(this._accountNumberController.text);
                    final String name = this._nameController.text;
                    final Contact newContact =
                        Contact(this._idContact, name, account);
                    if (newContact.id != 0) {
                      this
                          ._contactDao
                          .update(newContact)
                          .then((id) => Navigator.pop(context));
                    } else {
                      this
                          ._contactDao
                          .save(newContact)
                          .then((id) => Navigator.pop(context));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
