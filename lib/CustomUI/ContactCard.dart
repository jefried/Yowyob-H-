import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_whatsapp/Model/ContactModel.dart';
import 'package:flutter_whatsapp/Model/ConversationModel.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({Key key, this.contact}): super(key: key);
  final ContactModel contact;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
        leading: Container(
          height: 53,
          width: 50,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 23,
                child: contact.urlPhoto == ""?SvgPicture.asset(
                  "assets/person.svg",
                  color: Colors.white,
                  height: 30,
                  width: 30,) : null,
                backgroundImage: contact.urlPhoto != ""? CachedNetworkImageProvider(
                  contact.urlPhoto,
                ) : null,
                backgroundColor: Colors.blueGrey[200],
              ),
              contact.select ? Positioned(
                bottom: 4,
                right: 5,
                child: CircleAvatar(
                  backgroundColor: Colors.indigo,
                  radius: 11,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              )
                  : Container(),
            ],
          ),
        ),
        title: Text(contact.name, style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),),
        subtitle: Text(
          contact.status,
          style: TextStyle(
            fontSize: 13,
          ),
        ),
      );
  }
}