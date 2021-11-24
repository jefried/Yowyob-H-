import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/Model/ProfilModel.dart';
import 'package:flutter_whatsapp/Model/UserModel.dart';
import 'package:flutter_whatsapp/Pages/CallPage.dart';
import 'package:flutter_whatsapp/Pages/ChatPage.dart';
import 'package:flutter_whatsapp/Pages/CameraPage.dart';
import 'package:flutter_whatsapp/Model/ConversationModel.dart';
import 'package:flutter_whatsapp/Pages/Gallery/GalleryPage.dart';
import 'package:flutter_whatsapp/Pages/ProfilPage.dart';
import 'package:flutter_whatsapp/Pages/StatusPage.dart';
import 'package:flutter_whatsapp/Screens/CreateGroup.dart';
import 'package:flutter_whatsapp/database/UserDataBase.dart';
import 'package:flutter_whatsapp/utils/network_util.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Homescreen extends StatefulWidget {
  Homescreen({Key key, this.numCurrent}) : super(key: key);
  final String numCurrent;

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with SingleTickerProviderStateMixin {
  TabController _controller;
  List usersModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: 3, vsync: this, initialIndex: 1);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.pages,size: 30, color: Colors.indigo,),
            Text("Yowyob H!", style: TextStyle(fontFamily: 'DancingScript', fontSize: 30, color: Colors.black),),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.search), color: Colors.indigo, onPressed: () {}),
          PopupMenuButton<String>(
            onSelected: (value) {
              if(value == "Profil"){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilPage(profilModel: ProfilModel(name: "name1", status: "status1", number: int.parse(widget.numCurrent)))));
              }
              if(value=="New group") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGroup(numCurrent: widget.numCurrent)));
              }
            },
            itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(child: Text("New group",), value: "New group",),
              PopupMenuItem(child: Text("Profil"), value: "Profil")
            ];
          },)
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorColor: Colors.indigo,
          labelColor: Colors.black,
          labelStyle: TextStyle(fontFamily: "OpenSans-Bold"),
          tabs: [

            Tab(
              text: 'GALLERY',
            ),
            Tab(
              text: 'CHATS',
            ),
            Tab(
              text: "STATUS",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          Gallery(),
          ChatPage(numCurrent: widget.numCurrent,),
          StatusPage(),
        ],
      ),
    );
  }
}