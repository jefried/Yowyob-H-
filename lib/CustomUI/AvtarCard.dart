import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_whatsapp/Model/ContactModel.dart';
import 'package:flutter_whatsapp/Model/ConversationModel.dart';

class AvtarCard extends StatelessWidget {
  const AvtarCard({Key key, this.contact}) : super(key: key);
  final ContactModel contact;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 23,
                  child: contact.urlPhoto == ""? SvgPicture.asset(
                    "assets/person.svg",
                    color: Colors.white,
                    height: 30,
                    width: 30,): null,
                  backgroundImage: contact.urlPhoto != ""? CachedNetworkImageProvider(
                    contact.urlPhoto,
                  ) : null,
                  backgroundColor: Colors.blueGrey[200],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 11,
                    child: Icon(
                      Icons.clear,
                      color: Colors.white,
                      size: 13,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 2,
            ),
            Text(contact.name, style: TextStyle(fontSize: 12))
          ]
      ),
    );
  }
}