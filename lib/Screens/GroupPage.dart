import 'dart:convert';

import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_whatsapp/CustomUI/ReplyCardGroup.dart';
import 'package:flutter_whatsapp/GetContacts/GetContacts.dart';
import 'package:flutter_whatsapp/Model/ConversationModel.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_whatsapp/CustomUI/OwnMessageCard.dart';
import 'package:flutter_whatsapp/CustomUI/ReplyCard.dart';
import 'package:flutter_whatsapp/Model/UserModel.dart';
import 'package:flutter_whatsapp/Model/messages.dart';
import 'package:flutter_whatsapp/database/UserDataBase.dart';
import 'package:flutter_whatsapp/utils/DateHelper.dart';
import 'package:flutter_whatsapp/utils/LocalNotification.dart';
import 'package:flutter_whatsapp/utils/global_variable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';


class GroupPage extends StatefulWidget {
  GroupPage({Key key, this.chatModel, this.numCurrent}): super(key: key);
  final ConversationModel chatModel;
  final String numCurrent;

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;
  List<MessageModel> messages = [
    MessageModel(numReceiver: "654871038", numSender: "634586754", date: DateTime.now(), mediaType: "texte", urlMedia: null, texte: "bonjour hugo comment tu vas?"),
    MessageModel(numReceiver: "654871038", numSender: "634586754", date: DateTime.now(), mediaType: "texte", urlMedia: null, texte: "envoi moi la photo dont tu me parlais."),
    MessageModel(numReceiver: "634586754", numSender: "654871038", date: DateTime.now(), mediaType: "image", urlMedia: "https://images.unsplash.com/photo-1534103362078-d07e750bd0c4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80", texte: "bonjour Ariane voilà la photo en question"),
    MessageModel(numReceiver: "654871038", numSender: "634586754", date: DateTime.now(), mediaType: "texte", urlMedia: null, texte: "merci, très beau paysage !"),
    MessageModel(numReceiver: "654871038", numSender: "634586754", date: DateTime.now(), mediaType: "texte", urlMedia: null, texte: "Tu n'aurais pas d'autres images ou vidéos de ce type, j'aime bien"),
    MessageModel(numReceiver: "634586754", numSender: "654871038", date: DateTime.now(), mediaType: "texte", urlMedia: null, texte: "oui j'en ai d'autres"),
    MessageModel(numReceiver: "654871038", numSender: "634586754", date: DateTime.now(), mediaType: "texte", urlMedia: null, texte: "s'il te plaît envoi moi ça"),
    MessageModel(numReceiver: "634586754", numSender: "654871038", date: DateTime.now(), mediaType: "texte", urlMedia: null, texte: "okay je t'envoi une vidéo"),
    MessageModel(numReceiver: "634586754", numSender: "654871038", date: DateTime.now(), mediaType: "video", urlMedia: "https://static.videezy.com/system/resources/previews/000/005/529/original/Reaviling_Sjusj%C3%B8en_Ski_Senter.mp4", texte: "le soleil et la neige 👌"),
    MessageModel(numReceiver: "654871038", numSender: "634586754", date: DateTime.now(), mediaType: "texte", urlMedia: null, texte: "Waouh merci!"),
    MessageModel(numReceiver: "634586754", numSender: "654871038", date: DateTime.now(), mediaType: "texte", urlMedia: null, texte: "A demain"),
  ];
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  FlutterLocalNotificationsPlugin localNotification;
  int countNotif = 0;
  StompClient stompClient;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var androidInitialize = new AndroidInitializationSettings("ic_launcher");
    var iOSIntialize = new IOSInitializationSettings();
    var initialzationSettings = new InitializationSettings(androidInitialize,iOSIntialize);
    localNotification = new FlutterLocalNotificationsPlugin();
    localNotification.initialize(initialzationSettings);

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });

    stompClient = StompClient(
      config: StompConfig(
        url: '$url_root_ws/ws',
        onConnect: (stomp_client, frame) async{
          String numOther = widget.chatModel.numOther;
          String numCurrent = widget.numCurrent;
          stomp_client.subscribe(
            destination: '/topic/chat/$numOther/$numCurrent',
            callback: (frame) {
              Map<String, dynamic> message = json.decode(frame.body);
              setState(() {
                messages.add(MessageModel(numSender: message["numSender"], numReceiver: message["numReceiver"], date: message["date"], texte: message["texte"], mediaType: message["mediaType"], urlMedia: message["urlMedia"]));
              });

            },
          );
          List<UserModel> users = await UserDataBase.instance.users();
          users.forEach((user) {
            String other = user.number;
            if(user.number != numOther) {
              stomp_client.subscribe(
                  destination: '/topic/chat/$other/$numCurrent',
                  callback: (frame) async{
                    String notifTitle = await getNameOfNumber(other);
                    Map<String, dynamic> message = json.decode(frame.body);
                    LocalNotification().showNotification(notifTitle, message["texte"], localNotification);
                  }
              );
            }
          });
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
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        Image.asset("assets/whatsapp_Back.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              leadingWidth: 90,
              titleSpacing: 0,
              leading: InkWell(
                onTap: () {
                  stompClient.deactivate();
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back, color: Colors.indigo,),
              ),
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if(value=="Info Profil") {}
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(child: Text("Info Profil"), value: "Info Profil")
                    ];
                  },)
              ],
              title: Center(
                  child: InkWell(
                    onTap: () async{
                      String notifTitle = await getNameOfNumber(widget.chatModel.numOther);
                      LocalNotification().showNotification(notifTitle, "nouveau message", localNotification);
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          child: SvgPicture.asset(
                            widget.chatModel.isGroup ? "assets/group.svg"
                                : "assets/person.svg",
                            color: Colors.white,
                            height: 28,
                            width: 28,
                          ),
                          backgroundColor: Colors.grey,
                        ),
                        Container(
                          margin: EdgeInsets.all(6),
                          child: FutureBuilder(
                            future: getNameOfNumber(widget.chatModel.numOther),
                            builder: (context, snapshot) {
                              if(snapshot.hasData) {
                                return Text(snapshot.data, style: TextStyle(
                                  fontSize: 18.5,
                                  fontWeight: FontWeight.bold,
                                ),);
                              } else {
                                return Text(widget.chatModel.numOther);
                              }
                            },
                          ),
                        ),
                      ],),
                  )
              ),
            ),),
          body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: WillPopScope(
                child: Column(
                  children: [
                    Expanded(
                      //height: MediaQuery.of(context).size.height - 140,
                      child: ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: messages.length+1,
                        itemBuilder: (context, index) {
                          if(index == messages.length) {
                            return Container(
                              height: 70,
                            );
                          }
                          if(messages[index].numSender == widget.numCurrent) {
                            return OwnMessageCard(message: messages[index].texte, time: DateHelper().getDate(messages[index].date),);
                          } else {
                            return ReplyCardGroup(message: messages[index].texte, time: DateHelper().getDate(messages[index].date),name: messages[index].numSender,);
                          }
                        },
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                      margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                      child: TextFormField(
                                        controller: _controller,
                                        focusNode: focusNode,
                                        textAlignVertical: TextAlignVertical.center,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 5,
                                        minLines: 1,
                                        onChanged: (value){
                                          if(value.length>0){
                                            setState(() {
                                              sendButton = true;
                                            });
                                          }
                                          else {
                                            setState(() {
                                              sendButton = false;
                                            });
                                          }
                                        },
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Type a message",
                                          prefixIcon: IconButton(icon: Icon(Icons.emoji_emotions, color: Colors.lightGreen,), onPressed: (){
                                            focusNode.unfocus();
                                            focusNode.canRequestFocus = false;
                                            setState(() {
                                              show = !show;
                                            });
                                          },),
                                          suffixIcon: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(icon: Icon(Icons.attach_file, color: Colors.indigo,),
                                                color: Colors.blueGrey,
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                      backgroundColor: Colors.transparent,
                                                      context: context,
                                                      builder: (builder) => bottomsheet());
                                                },
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 0,
                                                    right: 5,
                                                    left: 2),
                                                child: IconButton(
                                                  icon: Icon(
                                                    FontAwesomeIcons.paperPlane,
                                                    color: Colors.indigo,),
                                                  onPressed: () {
                                                    if(sendButton) {
                                                      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                                                      String numOther = widget.chatModel.numOther;
                                                      String numCurrent = widget.numCurrent;
                                                      String texte = _controller.text;
                                                      stompClient.send(
                                                          destination: "/app/chat/$numCurrent/$numOther",
                                                          body: json.encode({
                                                            'numSender': numCurrent,
                                                            'numReceiver': numOther,
                                                            'date': DateTime.now(),
                                                            'texte': _controller.text,
                                                            "mediaType": "texte",
                                                            "urlMedia": null
                                                          })
                                                      );
                                                      _controller.clear();
                                                      setState(() {
                                                        sendButton = false;
                                                        messages.add(MessageModel(numSender: numCurrent, numReceiver: numOther, date: DateTime.now(), texte: texte, urlMedia: null, mediaType: "texte"));
                                                      });
                                                    }
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                          contentPadding: EdgeInsets.all(5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              show?emojiSelect() : Container(),
                            ],
                          ),
                        )
                    )
                  ],
                ),
                onWillPop: () {
                  if(show) {
                    setState(() {
                      show = false;
                    });
                  }
                  else {
                    stompClient.deactivate();
                    Navigator.pop(context);
                  }
                  return Future.value(false);
                },
              )
          ),
        )
      ],
    );
  }

  Widget bottomsheet() {
    return Container(
      height: 160,
      child: Card(
          margin: EdgeInsets.all(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                iconcreation(Icons.insert_drive_file, Colors.indigo, "Document"),
                SizedBox(width: 40,),
                iconcreation(Icons.camera_alt, Colors.pink, "Camera"),
                SizedBox(width: 40,),
                iconcreation(Icons.insert_photo, Colors.purple, "Gallery"),
              ],
            ),
          )
      ),
    );
  }

  Widget iconcreation(IconData icon, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
              radius: 30,
              backgroundColor: color,
              child: Icon(
                icon,
                color: Colors.white,
                size: 29,
              )
          ),
          SizedBox(height: 5,),
          Text(text, style: TextStyle(
            fontSize: 12,
          ),),
        ],
      ),
    );
  }

  Widget emojiSelect() {
    return EmojiPicker(
        rows: 4,
        columns: 7,
        onEmojiSelected: (emoji, category) {
          print(emoji);
          setState(() {
            _controller.text = _controller.text + emoji.emoji;
          });
        } );
  }
}