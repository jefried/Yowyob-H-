import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/Animation/FadeAnimation.dart';
import 'package:flutter_whatsapp/CustomUI/ButtomCard.dart';
import 'package:flutter_whatsapp/Model/ConversationModel.dart';
import 'package:flutter_whatsapp/Screens/Homescreen.dart';
import 'package:flutter_whatsapp/my_widgets/Menu_two_items.dart';
import 'package:flutter_whatsapp/my_widgets/alert_helper.dart';
import 'package:flutter_whatsapp/my_widgets/my_text.dart';
import 'package:flutter_whatsapp/my_widgets/my_textfield.dart';
import 'package:flutter_whatsapp/utils/network_util.dart';
import 'package:flutter_whatsapp/utils/global_variable.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.numCurrent}) : super(key: key);
  String numCurrent;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  PageController _pageController;
  TextEditingController _mail;
  TextEditingController _pwd;
  TextEditingController _name;
  TextEditingController _surname;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
    _mail = TextEditingController();
    _pwd = TextEditingController();
    _name = TextEditingController();
    _surname = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    _mail.dispose();
    _pwd.dispose();
    _name.dispose();
    _surname.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          //Notification received
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
            child: InkWell(
              onTap: (() => hideKeyboard()),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SafeArea(
                    child: Column(
                      children: [
                        Container(
                            height: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/background.png'),
                                fit: BoxFit.fill
                              ),
                            ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 30,
                                width: 80,
                                height: 50,
                                child: FadeAnimation(1,Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage('assets/light-1.png')
                                      )
                                  ),
                                ))
                              ),
                              Positioned(
                                  left: 140,
                                  width: 80,
                                  height: 40,
                                  child: FadeAnimation(1.3,Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage('assets/light-2.png')
                                        )
                                    ),
                                  ))
                              ),
                              Positioned(
                                  right: 35,
                                  top: 15,
                                  width: 80,
                                  height: 20,
                                  child: FadeAnimation(1.5,Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage('assets/clock.png')
                                        )
                                    ),
                                  ))
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0),
                          child: Menu2Items(
                              item1: "Connexion",
                              item2: "Création",
                              pageController: _pageController),
                        ),
                        Expanded(
                          flex: 2,
                          child: PageView(
                            controller: _pageController,
                            children: [logView(0), logView(1)],
                          ),
                        )
                      ],
                    )),
              ),
            )
        ),
      ),
    );
  }

  Widget logView(int index) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.0, bottom:10.0, left:20.0, right: 20.0),
          child: Card(
              elevation: 7.5,
              color: Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                margin: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: listItems((index == 0)),
                ),
              )),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0, bottom:15.0),
          child: Container(
            width: 300.0,
            height: 55.0,
            child: Card(
              elevation: 7.5,
              color: Color.fromRGBO(143, 148, 251, 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50/2)),
              child: FlatButton(
                  onPressed: (() => signIn((index == 0))),
                  child: (index == 0)? MyText("Se connecter") : MyText("Créer un compte")
              ),
            )
                ))
      ],
    );
  }



  List<Widget> listItems(bool exists) {
    List<Widget> list = [];
    list.add(MyTextField(
      controller: _mail,
      hint: "Entrez votre adresse mail",
      type: TextInputType.emailAddress,
    ));
    list.add(MyTextField(
      controller: _pwd,
      hint: "Entrez votre mot de passe",
      obscure: true,
    ));
    if (!exists) {
      list.add(MyTextField(controller: _surname, hint: "Entrez votre prénom"));
      list.add(MyTextField(controller: _name, hint: "Entrez votre nom"));
    }
    return list;
  }

  signIn(bool exists) {
    hideKeyboard();
    if(_mail.text !=null && _mail.text !="") {
      if(_pwd.text !=null && _pwd.text !="") {
        if(exists) {
          //Connection avec mail et pwd
          //FireHelper().signIn(_mail.text, _pwd.text);
          var email = _mail.text;
          var password = _pwd.text;
          //Use API to verify if user have account in yowyob shop. If true Navigate to next page, if false display alert(mot de passe ou adresse email incorrecte)
          var stompClient = StompClient(
            config: StompConfig(
              url: '$url_root_ws/ws',
              onConnect: (stomp_client, frame) async{

                stomp_client.send(
                    destination: "/app/updatedOrNewUser",
                    body: json.encode({
                      "number": widget.numCurrent,
                      "name": "", // replace by the name provided by API of yowyob
                      "surname": "", // replace by the name provided by API of Yowyob
                      "description": "",
                      "password": null,
                      "urlPhoto": null
                    })
                );
              },
              beforeConnect: () async {
                print('waiting to connect...');
                await Future.delayed(Duration(milliseconds: 200));
                print('connecting...');
              },
              onWebSocketError: (dynamic error) => print(error.toString()),
              stompConnectHeaders: {'Authorization': 'Bearer yourToken', 'userId': widget.numCurrent, 'simpUser': widget.numCurrent},
              webSocketConnectHeaders: {'Authorization': 'Bearer yourToken', 'userId': widget.numCurrent, 'simpUser': widget.numCurrent},
            ),
          );
          stompClient.activate();
          stompClient.deactivate();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>Homescreen(numCurrent: widget.numCurrent,)), (route) => false);
        } else {
          // verifier nom et prenom puis inscription
          if(_name.text != null && _name.text !="") {
            if(_surname.text != null && _surname.text !="") {
              //Inscription
              //Use API of yowyob H! to create a new user. Use API yowyob shop to create a new user.
              var stompClient = StompClient(
                config: StompConfig(
                  url: '$url_root_ws/ws',
                  onConnect: (stomp_client, frame) async{

                    stomp_client.send(
                        destination: "/app/updatedOrNewUser",
                        body: json.encode({
                          "number": widget.numCurrent,
                          "name": _name.text,
                          "surname": _surname.text,
                          "description": "",
                          "password": null,
                          "urlPhoto": null
                        })
                    );
                  },
                  beforeConnect: () async {
                    print('waiting to connect...');
                    await Future.delayed(Duration(milliseconds: 200));
                    print('connecting...');
                  },
                  onWebSocketError: (dynamic error) => print(error.toString()),
                  stompConnectHeaders: {'Authorization': 'Bearer yourToken', 'userId': widget.numCurrent, 'simpUser': widget.numCurrent},
                  webSocketConnectHeaders: {'Authorization': 'Bearer yourToken', 'userId': widget.numCurrent, 'simpUser': widget.numCurrent},
                ),
              );
              stompClient.activate();
              stompClient.deactivate();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>Homescreen(numCurrent: widget.numCurrent,)), (route) => false);
            } else {
              //Alerte pas de prenom
              AlertHelper().error(context, "Aucun prenom");
            }
          } else {
            //Alerte pas de nom
            AlertHelper().error(context, "Aucun nom");
          }
        }
      }else {
        //Alerte pas de password
        AlertHelper().error(context, "Aucun mot de passe");
      }
    } else {
      //Alerte pas de mail
      AlertHelper().error(context, "Aucune adresse email");
    }
  }

  hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}