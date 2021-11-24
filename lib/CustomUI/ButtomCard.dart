import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_whatsapp/Model/ConversationModel.dart';

class ButtonCard extends StatelessWidget {
  const ButtonCard({Key key, this.name,this.icon}): super(key: key);
  final String name;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
        leading: CircleAvatar(
          radius: 23,
          child: Icon(icon,color: Colors.white,),
          backgroundColor: Colors.black,
        ),
        title: Text(name, style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),),
      );
  }
}