import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/Screens/PostOrStory.dart';
import 'dart:io';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CameraViewPage extends StatelessWidget {
  const CameraViewPage({Key key, this.path, this.from}): super(key: key);
  final String path;
  final String from;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: Icon(Icons.crop_rotate, size: 27,),
          onPressed: () {},),
          IconButton(icon: Icon(Icons.emoji_emotions_outlined, size: 27,),
            onPressed: () {},),
          IconButton(icon: Icon(Icons.title, size: 27,),
            onPressed: () {},),
          IconButton(icon: Icon(Icons.edit, size: 27,),
            onPressed: () {},)
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 150,
              child: Image.file(
                File(path),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 7,
                left: 10,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 50,
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.indigo)
                      ),
                      child: TextFormField(
                        style: TextStyle(
                            color: Colors.white,
                            backgroundColor: Colors.transparent,
                            fontSize: 17
                        ),
                        maxLines: 6,
                        minLines: 1,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Type a message",
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 17
                            ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    from == "IndividualPage"?
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.paperPlane,
                        color: Colors.indigo,),
                      onPressed: () {},
                    )
                        :from == "GroupPage"?
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.paperPlane,
                        color: Colors.indigo,),
                      onPressed: () {},
                    )
                        :InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (builder) => PostOrStory(from: from, media: File(path), mediaType: "image")));
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.indigo,
                        child: Icon(Icons.check, color: Colors.white, size: 27,),
                      ),
                    )
                  ],
                )
            )
          ],
        )
      ),
    );
  }
}