import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/CustomUI/ContactCard.dart';
import 'package:flutter_whatsapp/Model/ContactModel.dart';
import 'package:flutter_whatsapp/Model/ConversationModel.dart';
import 'package:flutter_whatsapp/CustomUI/ButtomCard.dart';
import 'package:flutter_whatsapp/Screens/CreateGroup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SelectContact extends StatefulWidget {
  SelectContact({Key key, this.currentEmail}) : super(key: key);
  String currentEmail;

  @override
  _SelectContactState createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  List<ContactModel> contacts = [
    ContactModel(name: "Ange", status: "Cogito ergo sun", select: false, urlPhoto: "https://wallpapercave.com/w/wp5419358.jpg"),
    ContactModel(name:"Ariane", status: "Remet ton sort à l'éternel mon ami, il agira", select: false, urlPhoto: "https://wallpapercave.com/w/wp4256046.jpg"),
    ContactModel(name: "Arielle Org", status: "Disponible", select: false, urlPhoto: "https://wallpapercave.com/w/wp5175876.jpg"),
    ContactModel(name:"Audrey", status: "One step at a time", select: false, urlPhoto: "https://wallpapercave.com/w/wp7221464.jpg"),
    ContactModel(name: "Bibiche", status: "A chaque pas, je me sentais incompris", select: false, urlPhoto: "https://wallpapercave.com/w/wp9418166.jpg"),
    ContactModel(name:"Bidjanga", status: "Au four et au moulin", select: false, urlPhoto: "https://wallpapercave.com/w/wp9102999.jpg"),
    ContactModel(name: "Borex", status: "disponible", select: false, urlPhoto: "https://wallpapercave.com/w/wp9103005.jpg"),
    ContactModel(name:"Brice ", status: "Online", select: false, urlPhoto: "https://wallpapercave.com/w/wp3835525.jpg"),
    ContactModel(name: "Danielle", status: "La lumière des justes est joyeuse", select: false, urlPhoto: "https://wallpapercave.com/w/wp9418233.jpg"),
    ContactModel(name:"Dany", status: "Je t'aime maman", select: false, urlPhoto: "https://wallpapercave.com/w/uwp1352835.jpg"),
    ContactModel(name: "Eken", status: "", select: false, urlPhoto: "https://wallpapercave.com/w/wp9103127.jpg"),
    ContactModel(name:"Jordan ", status: "Ne neglige pas le don qui est en toi", select: false, urlPhoto: "https://wallpapercave.com/w/wp9103145.jpg"),
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Contact", style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            )),
            Text("12 Contacts", style: TextStyle(
              fontSize: 11,
            ),)
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.search, size: 26, color: Colors.indigo,), onPressed: () {},),
          PopupMenuButton<String>(
            onSelected: (value) {
              print(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(child: Text("Help"), value: "Help"),
              ];
            },)
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length + 2,
        itemBuilder: (context, index) {
          if(index == 0) {
            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder) => CreateGroup()));
              },
              child: ButtonCard(icon: FontAwesomeIcons.users, name:"New group")
            );
          } else if (index == 1) {
            return InkWell(
                onTap: () async{
                  try {
                    Contact contact = await ContactsService.openContactForm();
                    if(contact != null) {
                      setState(() {});
                    }
                  } on FormOperationException catch (e) {
                    switch(e.errorCode) {
                      case FormOperationErrorCode.FORM_OPERATION_CANCELED:
                      case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
                      case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
                        print(e.toString());
                    }
                  }
                },
                child: ButtonCard(icon: Icons.person_add, name:"New contact")
            );
          }
          return ContactCard(
            contact: contacts[index-2],
          );
        })
    );
  }
}