import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:contact_list/contact_page.dart';
import 'package:contact_list/utils/contact.dart';
import 'package:contact_list/utils/utils.dart';
import 'dart:io';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ContactUtils utils = ContactUtils();
  List<Contact> _contacts = [];

  void iniState() {
    super.initState();
    setState(() {
      _getAllContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Agenda de Contatos"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContact();
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
      ),
    );
  }

  void _getAllContacts() {
    utils.getAllContacts().then((value) => {
          setState(() {
            _contacts = value;
          })
        });
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _showOptions(context, index);
      },
      child: Card(
        child: Row(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _contacts[index].img != null
                        ? FileImage(File(_contacts[index].img))
                        : AssetImage("images/default-image.jpg"),
                  )),
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextDefault(_contacts[index].name),
                    TextDefault(_contacts[index].email),
                    TextDefault(_contacts[index].phone),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  void _showContact({Contact contact}) async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact)));
    if (recContact != null) {
      if (contact != null) {
        await utils.updateContact(recContact);
      } else {
        await utils.saveContact(recContact);
      }
    }
    _getAllContacts();
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        onPressed: () {
                          launch("Tel: ${_contacts[index].phone}");
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Ligar",
                          style: TextStyle(color: Colors.green, fontSize: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showContact(contact: _contacts[index]);
                        },
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.green, fontSize: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        onPressed: () {
                          utils.deleteContact(_contacts[index].id);
                          setState(() {
                            _getAllContacts();
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Deletar",
                          style: TextStyle(color: Colors.green, fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }
}
