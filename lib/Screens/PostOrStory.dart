import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/CustomUI/ButtomCard.dart';
import 'package:flutter_whatsapp/Model/ConversationModel.dart';
import 'package:flutter_whatsapp/Pages/ChatPage.dart';
import 'package:flutter_whatsapp/Screens/Homescreen.dart';
import 'package:flutter_whatsapp/utils/global_variable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostOrStory extends StatelessWidget {
  PostOrStory({this.uidCurrent, this.from, this.chatModel, this.media, this.mediaType, this.texte});
  String uidCurrent;
  String from;
  String mediaType;
  String texte;
  File media;
  ConversationModel chatModel;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Post Or Story", style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            )),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.search, size: 26, color: Colors.indigo,), onPressed: () {},),
        ],
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Homescreen(),
                ),
                    (route) => false,
              );
            },
            child: ButtonCard(icon: FontAwesomeIcons.plus, name:"Add Story")
          ),
          InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Homescreen(),
                ),
                    (route) => false,
              );
            },
            child: ButtonCard(icon: FontAwesomeIcons.plus, name:"Add Post")
          )
        ],
      ),
    );
  }
}