import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/CustomUI/ContactCard.dart';
import 'package:flutter_whatsapp/Model/ContactModel.dart';
import 'package:flutter_whatsapp/Model/ConversationModel.dart';
import 'package:flutter_whatsapp/CustomUI/ButtomCard.dart';
import 'package:flutter_whatsapp/CustomUI/AvtarCard.dart';
import 'package:flutter_whatsapp/Screens/FeaturesCreateGroup.dart';

class CreateGroup extends StatefulWidget {
  CreateGroup({Key key, this.contact, this.numCurrent}) : super(key: key);
  final ContactModel contact;
  final String numCurrent;


  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
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
  List<ContactModel> groupmember = [];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("New Group", style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              )),
              Text("Add participants", style: TextStyle(
                fontSize: 11,
              ),)
            ],
          ),
          actions: [
            IconButton(icon: Icon(Icons.search, size: 26, color: Colors.indigo,), onPressed: () {},),
          ],
        ),
        body: Stack(
          children: [
            ListView.builder(
                itemCount: contacts.length + 1,
                itemBuilder: (context, index) {
                  if(index == 0) {
                    return Container(
                      height: groupmember.length > 0 ? 90 : 10,
                    );
                  }
                  return InkWell(
                    onTap: () {
                      if(contacts[index - 1].select==false) {
                        setState(() {
                          contacts[index - 1].select = true;
                          groupmember.add(contacts[index - 1]);
                        });
                      } else {
                        setState(() {
                          contacts[index - 1].select = false;
                          groupmember.remove(contacts[index - 1]);
                        });
                      }
                    },
                    child: ContactCard(
                      contact: contacts[index - 1],
                    ),
                  );
                }),
            groupmember.length >0 ?Column(
              children: [
                Container(
                  height: 75,
                  color: Colors.white,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                      itemCount: contacts.length,
                      itemBuilder: (context, index){
                        if (contacts[index].select == true) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                groupmember.remove(contacts[index]);
                                contacts[index].select = false;
                              });
                            },
                            child: AvtarCard(
                              contact: contacts[index],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                  ),
                ),
                Divider(thickness: 1,),
              ],
            )
                : Container(),
            Positioned(
              bottom: 40,
              right: 10,
              child: groupmember.length >0?FloatingActionButton(
                backgroundColor: Colors.indigo,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => FeaturesCreateGroup(participants: groupmember, contactCreator: widget.contact, numCurrent: widget.numCurrent)));
                },
                child: Icon(Icons.arrow_forward, color: Colors.white,),
              ) : Container()
            )
          ]
        )
    );
  }
}