import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_whatsapp/CustomUI/AvartarCard.dart';
import 'package:flutter_whatsapp/Model/ContactModel.dart';
import 'package:flutter_whatsapp/Pages/ChatPage.dart';
import 'package:flutter_whatsapp/Screens/Homescreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class FeaturesCreateGroup extends StatefulWidget {
  FeaturesCreateGroup({Key key, this.contactCreator, this.participants, this.numCurrent}): super(key: key);
  final ContactModel contactCreator;
  List<ContactModel> participants ;
  final String numCurrent;

  _FeaturesCreateGroupState createState() => _FeaturesCreateGroupState();
}

class _FeaturesCreateGroupState extends State<FeaturesCreateGroup> {
  File file;
  String name;
  String description;
  bool changed;
  TextEditingController _name;
  TextEditingController _description;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _name = TextEditingController();
    _description = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (builder) => Homescreen(numCurrent: widget.numCurrent),),
            (Route<dynamic> route) => false
          );
        },
        child: Icon(Icons.done, color: Colors.grey,),
      ),
      appBar: AppBar(
        leading: InkWell(
          onTap: (){Navigator.of(context).pop();},
          child: Icon(Icons.arrow_back),
        ),
        title: Text("Create Group"),),
      body: ListView(
        children: [
          Container(
            height: 120,
            child: Center(
              child: Stack(
                children: [
                  CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.blueGrey,
                      child: SvgPicture.asset("assets/group.svg",height: 100, color: Colors.white,),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                          onTap: () {
                            _takePicture(ImageSource.camera);
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.blueGrey[100],
                            radius: 20,
                            child: Icon(
                              Icons.camera_alt,
                              size: 17,
                              color: Colors.blueGrey[900],
                            ),
                          )
                      )
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      child: InkWell(
                          onTap: () {
                            _takePicture(ImageSource.gallery);
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.blueGrey[100],
                            radius: 20,
                            child: Icon(
                              Icons.photo_library,
                              size: 17,
                              color: Colors.blueGrey[900],
                            ),
                          )
                      )
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Group's name", style: TextStyle(fontWeight: FontWeight.bold),),
                TextField(
                    controller: _name,
                    decoration: InputDecoration(hintText: ""),
                    onChanged: (string) {
                      setState(() {
                        name = string;
                      });
                    }
                ),
                Container(height: 1, color: Colors.indigo,)
              ],
            ),
          ),
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Description", style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.indigo)
                  ),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextField(
                      controller: _description,
                      maxLines: 3,
                      decoration: InputDecoration(hintText: ""),
                      onChanged: (string) {
                        setState(() {
                          description = string;
                        });
                      }
                  ),),
              ],
            ),
          ),
          Container(
            height: 30,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              child: Text(
                "participants",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      Container(
        height: 80,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.participants.length,
          itemBuilder: (context, index){
            return AvatarCard(contact: widget.participants[index]);
          },
        ),
      ),
          Container(
            height: 80,
          )
        ],
      ),
    );
  }

  Future<void> _takePicture(ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source, maxWidth: 500.0, maxHeight: 500.0);
    if(!(image == null)){
      setState(() {
        changed = true;
        file = image;
      });
    }
  }
}