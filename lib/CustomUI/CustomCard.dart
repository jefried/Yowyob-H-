import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_whatsapp/GetContacts/GetContacts.dart';
import 'package:flutter_whatsapp/Model/ConversationModel.dart';
import 'package:flutter_whatsapp/Screens/IndividualPage.dart';
import 'package:flutter_whatsapp/utils/global_variable.dart';
import 'package:flutter_whatsapp/utils/network_util.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({Key key, this.conversationModel,this.name, this.numCurrent, this.urlPhoto}) : super(key: key);
  final ConversationModel conversationModel;
  final String name;
  final String numCurrent;
  final String urlPhoto;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => IndividualPage(chatModel: conversationModel, numCurrent: numCurrent,)));
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: conversationModel.urlPhoto == ""? SvgPicture.asset(
                conversationModel.isGroup ? "assets/group.svg"
                : "assets/person.svg",
                color: Colors.white,
                height: 38,
                width: 38,
              ) : null,
              backgroundImage: conversationModel.urlPhoto != ""? CachedNetworkImageProvider(
                conversationModel.urlPhoto,
              ) : null,
              backgroundColor: Colors.grey,
            ),
            title: Text(name, style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),),
            subtitle: Row(
              children: [
                Icon(Icons.done_all),
                SizedBox(
                  width: 3,
                ),
                Text(
                    conversationModel.currentMessage,
                    style: TextStyle(
                      fontSize: 13,
                    )
                )
              ],
            ),
            trailing: Column(
              children: [
                Text(conversationModel.timeCurrentMessage),
                SizedBox(height: 2,),
                conversationModel.amountNewMessages != 0 ? Container(
                  height: 22,
                  child: Text(conversationModel.amountNewMessages.toString(), style: TextStyle(color: Colors.white),),
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(8)
                  ),
                ): SizedBox(height: 2,),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.only(right: 20, left: 80),
            child: Divider(
              thickness: 1,
            ),)
        ],
      ),
    );
  }
}