import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InfoProfil extends StatelessWidget {
  InfoProfil({Key key, String nameContact, }): super();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Info profil"),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height*1/3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage('https://wallpapercave.com/w/wp4256046.jpg'),
                      fit: BoxFit.cover
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 20,
                child: Container(color: Colors.black38, child: Text("Ariane", style: TextStyle(color: Colors.white, fontSize: 20),),)
              )
            ],
          ),
          SizedBox(height: 10,),
          ListTile(
            leading: Icon(FontAwesomeIcons.phone, color: Colors.indigo,),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Phone", style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 15,),
                Text("677676881"),
              ],
            ),
          ),
          SizedBox(height: 10,),
          ListTile(
            leading: Icon(FontAwesomeIcons.user, color: Colors.indigo,),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name", style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 15,),
                Text("Ariane Tchemgue"),
              ],
            ),
          ),
          SizedBox(height: 10,),
          ListTile(
            leading: Icon(FontAwesomeIcons.info, color: Colors.indigo,),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("About", style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 15,),
                Container(child: Text("Remet ton sort à l'éternel mon ami, il agira"),),
              ],
            ),
          ),
          SizedBox(height: 7,),
        ],
      )
    );
  }
}