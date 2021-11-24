import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_whatsapp/GetContacts/GetContacts.dart';
import 'package:flutter_whatsapp/Model/ProfilModel.dart';
import 'package:flutter_whatsapp/Model/UserModel.dart';
import 'package:flutter_whatsapp/Screens/CameraScreen.dart';
import 'package:flutter_whatsapp/Screens/Homescreen.dart';
import 'package:flutter_whatsapp/Screens/TakePhotoView.dart';
import 'package:flutter_whatsapp/database/UserDataBase.dart';
import 'package:flutter_whatsapp/utils/FileStoragePhone_util.dart';
import 'package:flutter_whatsapp/utils/global_variable.dart';
import 'package:flutter_whatsapp/utils/network_util.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';

class ProfilPage extends StatefulWidget {
  ProfilPage({Key key, this.profilModel}) : super(key: key);
  final ProfilModel profilModel;
  ProfilPageState createState() => new ProfilPageState();
}

class ProfilPageState extends State<ProfilPage> {
  String name;
  String status;
  TextEditingController _name;
  TextEditingController _about;
  StompClient stompClient;
  File file;
  bool changed;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _name = TextEditingController();
    _about = TextEditingController();
    name = widget.profilModel.name;
    status = widget.profilModel.status;
    changed = false;
    stompClient = StompClient(
      config: StompConfig(
        url: '$url_root_ws/ws',
        onConnect: (stomp_client, frame) async{
          print("Connected");
          String numCurrent = widget.profilModel.number.toString();
          List<UserModel> users = await UserDataBase.instance.users();
        },
        beforeConnect: () async {
          print('waiting to connect...');
          print('to be connect');
          await Future.delayed(Duration(milliseconds: 200));
          print('connecting...');
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
        stompConnectHeaders: {'Authorization': 'Bearer yourToken', 'userId': widget.profilModel.number.toString(), 'simpUser': widget.profilModel.number.toString()},
        webSocketConnectHeaders: {'Authorization': 'Bearer yourToken','userId': widget.profilModel.number.toString(), 'simpUser': widget.profilModel.number.toString()},
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _name.dispose();
    _about.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    // TODO: implement build
    return FutureBuilder(
      future: getApplicationDocumentsDirectory(),
      builder: (context, DirectoryBaseSnapshot) => FutureBuilder(
        future: UserDataBase.instance.getUser(widget.profilModel.number.toString()),
        builder: (context, userSnapshot){
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.indigo,
              onPressed: () {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (builder) => Homescreen(numCurrent: widget.profilModel.number.toString()),),
                        (Route<dynamic> route) => false
                );
              },
              child: Icon(Icons.done, color: Colors.grey,),
            ),
              appBar: AppBar(
                  leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back),),
                  title: Text("Profile")
              ),
              body: ListView(
                children: [
                  Container(
                    height: 160,
                    child: Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.white,
                              backgroundImage: file == null? userSnapshot.hasData? FileImage(File(DirectoryBaseSnapshot.data.path + '/Profil/' +userSnapshot.data.urlPhoto))
                                  : NetworkImage('https://wallpapercave.com/wp/AYWg3iu.jpg')
                                  : FileImage(file)
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
                                      size: 20,
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
                                      size: 20,
                                      color: Colors.blueGrey[900],
                                    ),
                                  )
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.user, color: Colors.indigo),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name", style: TextStyle(fontWeight: FontWeight.bold),),
                        TextField(
                            controller: _name,
                            decoration: InputDecoration(hintText: "Hugo Sondi"),
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
                    leading: Icon(FontAwesomeIcons.info, color: Colors.indigo,),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("About", style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.indigo)
                          ),
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: TextField(
                              controller: _about,
                              maxLines: 3,
                              decoration: InputDecoration(hintText: "Tout est relatif"),
                              onChanged: (string) {
                                setState(() {
                                  status = string;
                                });
                              }
                          ),),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.phone, color: Colors.indigo,),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Phone", style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(widget.profilModel.number.toString())
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                ],
              )
          );
        },
      ),
    );
  }

  _saveChanges(String directoryBasepath) {
    String number = widget.profilModel.number.toString();
    if(changed){
      if(!(directoryBasepath == "")) {
        storeFile(file, 'Profil', number);
      }
      UserDataBase.instance.insertUser(UserModel(number:number, name : name, surname : "", description: status, urlPhoto: number));
      NetworkUtil().uploadFile(file.path, '$url_root/upload/$number');
    }
    stompClient.send(
        destination: "/app/updatedOrNewUser",
        body: json.encode({
          "number": widget.profilModel.number.toString(),
          "name": _name.text,
          "surname": "",
          "description": _about.text,
          "password": null,
          "urlPhoto": widget.profilModel.number.toString()
        })
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