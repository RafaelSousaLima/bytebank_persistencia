import 'package:bytebank/contact_form.dart';
import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'contact.dart';

class ContactList extends StatefulWidget {
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactList> {
  final ContactDao _contactDao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: FutureBuilder<List<Contact>>(
          initialData: [],
          future: _contactDao.findAll(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;
              case ConnectionState.waiting:
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Text("Loading")
                    ],
                  ),
                );
                break;
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                final List<Contact> contacts = snapshot.data;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return _ContactItem(() {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) =>
                                  ContactForm(contact: contacts[index])))
                          .then((value) => setState(() {}));
                    }, contacts[index]);
                  },
                  itemCount: contacts.length,
                );
                break;
            }
            return Text('Error snapshot.connectionState');
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => ContactForm(),
                ),
              )
              .then(
                (value) => setState(() {}),
              )
        },
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contact _contact;
  final Function _function;

  _ContactItem(this._function, this._contact);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _function,
      child: Card(
        child: ListTile(
          title: Text(
            _contact.name,
            style: TextStyle(fontSize: 24.0),
          ),
          subtitle: Text(
            _contact.accountNumber.toString(),
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
