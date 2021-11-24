import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/CustomUI/PostCard.dart';
import 'package:flutter_whatsapp/CustomUI/StatusPage/HeadOwnStatus.dart';
import 'package:flutter_whatsapp/CustomUI/StatusPage/OthersStatus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_whatsapp/dataStories.dart';
import 'package:flutter_whatsapp/Model/StoryModel.dart';

class StatusPage extends StatefulWidget {
  StatusPage({Key key}) : super(key: key);

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  List<List<StoryModel>> storyScreens = [
    dataStories0,
    dataStories1,
    dataStories2,
    dataStories3,
    dataStories4,
    dataStories5,
  ];


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 48,
            child: FloatingActionButton(
              heroTag: "btn1",
              elevation: 8,
              onPressed: () {},
              child: Icon(
                FontAwesomeIcons.cameraRetro,
                color: Colors.blueGrey[900],
              ),
            ),
          ),
          SizedBox(
            height: 11,
          ),
          FloatingActionButton(
            heroTag: "btn2",
              onPressed: (){},
            elevation: 5,
            child: Icon(
              Icons.edit,
              color: Colors.blueGrey[900],
            ),
              )
        ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          label("Stories"),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            height: 110,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                HeadOwnStatus(storyScreens: storyScreens),
                OthersStatus(
                  name: "Borex",
                  imageName: "https://wallpapercave.com/w/wp9103005.jpg",
                  time: "01:27",
                  isSeen: false,
                  statusNum: 1,
                  index: 1,
                  storyScreens: storyScreens
                ),
                OthersStatus(
                  name: "Bibiche",
                  imageName: "https://wallpapercave.com/w/wp9418166.jpg",
                  time: "01:27",
                  isSeen: false,
                  statusNum: 1,
                  index: 2,
                  storyScreens: storyScreens
                ),
                OthersStatus(
                  name: "Danielle",
                  imageName: "https://wallpapercave.com/w/wp9418233.jpg",
                  time: "01:27",
                  isSeen: false,
                  statusNum: 1,
                  index: 3,
                  storyScreens: storyScreens
                ),
                OthersStatus(
                  name: "Eken",
                  imageName: "https://wallpapercave.com/w/wp9103127.jpg",
                  time: "01:27",
                  isSeen: false,
                  statusNum: 1,
                  index: 4,
                  storyScreens: storyScreens
                ),
                OthersStatus(
                  name: "Brice",
                  imageName: "https://wallpapercave.com/w/wp3835525.jpg",
                  time: "01:27 ",
                  isSeen: false,
                  statusNum: 1,
                  index: 5,
                  storyScreens: storyScreens
                ),
              ],
            ),
          ),
          SizedBox(height: 5.0),
          label("Posts"),
          PostCard(urlPhoto: 'https://wallpapercave.com/wp/AYWg3iu.jpg', name: "Hugo Sondi", urlMedia: "https://static.videezy.com/system/resources/previews/000/007/536/original/rockybeach.mp4", typeMedia: "video",texte: "Beau paysage !", date: "11:54", likes: 10,),
          PostCard(urlPhoto: 'https://wallpapercave.com/w/wp5419358.jpg', name: "Ange", urlMedia: "https://static.videezy.com/system/resources/previews/000/005/529/original/Reaviling_Sjusj%C3%B8en_Ski_Senter.mp4", typeMedia: "video",texte: "La nature à l'état pure !", date: "10:01", likes: 9,),
          PostCard(urlPhoto: 'https://wallpapercave.com/w/wp9418233.jpg', name: "Danielle", urlMedia: "https://images.unsplash.com/photo-1534103362078-d07e750bd0c4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80", typeMedia: "image",texte: "Belle image !! ", date: "06:43", likes: 9,),
          PostCard(urlPhoto: 'https://wallpapercave.com/w/wp9102999.jpg', name: "Bidjanga", urlMedia: "https://static.videezy.com/system/resources/previews/000/007/536/original/rockybeach.mp4", typeMedia: "texte",texte: "POÊME DU JOUR : Ô jeunes hommes ! notre joie, Vous ne la connaissez point, De voir, comme un bouton rougeoie, Le printemps qui point.", date: "28 Août 2021", likes: 7,),
          PostCard(urlPhoto: 'https://wallpapercave.com/wp/AYWg3iu.jpg', name: "Hugo Sondi", urlMedia: "https://static.videezy.com/system/resources/previews/000/007/536/original/rockybeach.mp4", typeMedia: "texte",texte: " INFO DU JOUR : Avec la volonté affichée de s’adresser à toutes les confessions, le chef de l’Etat a visité le sanctuaire d’Al-Kadhimiya, lieu de pèlerinage important pour les musulmans chiites.", date: "28 Août 2021", likes: 3,),
          PostCard(urlPhoto: 'https://wallpapercave.com/w/wp7221464.jpg', name: "Audrey", urlMedia: "https://static.videezy.com/system/resources/previews/000/007/536/original/rockybeach.mp4", typeMedia: "texte",texte: "INFO DU JOUR : Samedi après-midi, le président américain avait averti qu’une attaque terroriste était probable dans les « vingt-quatre à trente-six heures ». L’ambassade américaine a appelé ses ressortissants à quitter les lieux.", date: "28 Août 2021", likes: 6,),
        ],
      )
    );
  }

  Widget label(String labelname) {
    return Container(
      height: 33,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[300],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        child: Text(
          labelname,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}