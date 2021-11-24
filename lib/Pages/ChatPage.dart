import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_whatsapp/CustomUI/CustomCard.dart';
import 'package:flutter_whatsapp/GetContacts/GetContacts.dart';
import 'package:flutter_whatsapp/Model/CallModel.dart';
import 'package:flutter_whatsapp/Model/ConversationModel.dart';
import 'package:flutter_whatsapp/Model/PostModel.dart';
import 'package:flutter_whatsapp/Model/StoryModel.dart';
import 'package:flutter_whatsapp/Model/UserModel.dart';
import 'package:flutter_whatsapp/Model/conversations.dart';
import 'package:flutter_whatsapp/Model/conversationsGroup.dart';
import 'package:flutter_whatsapp/Model/messages.dart';
import 'package:flutter_whatsapp/Screens/SelectContact.dart';
import 'package:flutter_whatsapp/database/CallDataBase.dart';
import 'package:flutter_whatsapp/database/ConversationDataBase.dart';
import 'package:flutter_whatsapp/database/ConversationGroupDataBase.dart';
import 'package:flutter_whatsapp/database/MessageDataBase.dart';
import 'package:flutter_whatsapp/database/PostDataBase.dart';
import 'package:flutter_whatsapp/database/StoryDataBase.dart';
import 'package:flutter_whatsapp/database/UserDataBase.dart';
import 'package:flutter_whatsapp/utils/DateHelper.dart';
import 'package:flutter_whatsapp/utils/LocalNotification.dart';
import 'package:flutter_whatsapp/utils/global_variable.dart';
import 'package:flutter_whatsapp/utils/network_util.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';

import 'CameraPage.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key, this.numCurrent}): super(key: key);
  final String numCurrent;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ConversationModel> conversations;
  List<String> urlPhotos;
  StompClient stompClient;
  FlutterLocalNotificationsPlugin localNotification;

  @override
  Future<void> initState() {
    // TODO: implement initState
    conversations = [
      ConversationModel(isGroup: false,numOther: "634586754",currentMessage:"je t'appelle le soir", timeCurrentMessage:"19:02",amountNewMessages: 3, urlPhoto: "https://wallpapercave.com/wp/wp8498412.jpg"),
      ConversationModel(isGroup: false,numOther: "656018148",currentMessage:"comment tu vas?", timeCurrentMessage:"18:34",amountNewMessages: 0, urlPhoto: "https://wallpapercave.com/w/wp5577213.jpg"),
      ConversationModel(isGroup: false,numOther: "677676881",currentMessage:"A demain", timeCurrentMessage:"7:48",amountNewMessages: 0, urlPhoto: "https://wallpapercave.com/w/wp4256046.jpg"),
      ConversationModel(isGroup: false,numOther: "695182328",currentMessage:"Bonjour", timeCurrentMessage:"6:15",amountNewMessages: 1, urlPhoto: "https://wallpapercave.com/w/wp2660250.jpg"),
      ConversationModel(isGroup: false,numOther: "691580279",currentMessage:"Je suis allé chez...", timeCurrentMessage:"5:58",amountNewMessages: 7, urlPhoto: "https://wallpapercave.com/w/wp8906592.jpg"),
      ConversationModel(isGroup: false,numOther: "653237097",currentMessage:"d'accord", timeCurrentMessage:"3:02",amountNewMessages: 2, urlPhoto: "https://wallpapercave.com/w/wp9539290.jpg"),
      ConversationModel(isGroup: false,numOther: "693552204",currentMessage:"c'était hier", timeCurrentMessage:"10:02",amountNewMessages: 3, urlPhoto: "https://wallpapercave.com/w/uwp1349008.jpg"),
      ConversationModel(isGroup: false,numOther: "690269859",currentMessage:"dans 3 minutes", timeCurrentMessage:"10:02",amountNewMessages: 1, urlPhoto: "https://wallpapercave.com/w/uwp1349146.jpg"),
      ConversationModel(isGroup: false,numOther: "691729084",currentMessage:"je t'en prie", timeCurrentMessage:"10:02",amountNewMessages: 0, urlPhoto: "https://wallpapercave.com/w/uwp1354099.jpg"),
      ConversationModel(isGroup: false,numOther: "698200073",currentMessage:"non on a faim", timeCurrentMessage:"10:02",amountNewMessages: 0, urlPhoto: "https://wallpapercave.com/w/uwp1354094.jpg"),
      ConversationModel(isGroup: false,numOther: "699210589",currentMessage:"ta part est où", timeCurrentMessage:"10:02",amountNewMessages: 2, urlPhoto: "https://wallpapercave.com/w/wp9539294.jpg"),
      ConversationModel(isGroup: false,numOther: "657011248",currentMessage:"jtp gars", timeCurrentMessage:"10:02",amountNewMessages: 0, urlPhoto: "https://wallpapercave.com/w/wp9539303.jpg"),
    ];
    super.initState();

    var androidInitialize = new AndroidInitializationSettings("icon");
    var iOSIntialize = new IOSInitializationSettings();
    var initialzationSettings = new InitializationSettings(androidInitialize,iOSIntialize);
    localNotification = new FlutterLocalNotificationsPlugin();
    localNotification.initialize(initialzationSettings);

    stompClient = StompClient(
      config: StompConfig(
        url: '$url_root_ws/ws',
        onConnect: (stomp_client, frame) async{
          print("Connected");
          String numCurrent = widget.numCurrent;
          List<UserModel> users = await UserDataBase.instance.users();
          users.forEach((user) {
            String other = user.number;
            stomp_client.subscribe(
                destination: '/topic/chat/$other/$numCurrent',
                callback: (frame) async{
                  String notifTitle = await getNameOfNumber(other);
                  Map<String, dynamic> message = json.decode(frame.body);
                  MessageDataBase.instance.insertMessage(MessageModel(numSender: message["numSender"].toString(), numReceiver: message["numReceiver"].toString(), date: message["date"], mediaType: message["mediaType"], texte: message["texte"], urlMedia: message["urlMedia"]));
                  LocalNotification().showNotification(notifTitle, message["texte"],localNotification);
                }
            );
            stomp_client.subscribe(
              destination: '/topic/call/$other/$numCurrent',
              callback: (frame) async{
                String notifTitle = await getNameOfNumber(other);
                Map<String, dynamic> call = json.decode(frame.body);
                CallDataBase.instance.insertCall(CallModel(numSender: call["numSender"], numReceiver: call["numReceiver"], date: call["date"], urlPhotoSender: call["urlPhotoSender"], urlPhotoReceiver: call["urlPhotoReceiver"], taken: call["taken"]));
                LocalNotification().showNotification(notifTitle, "appel", localNotification);
              }
            );
            stomp_client.subscribe(
                destination: '/topic/updatedOrNewUser',
                callback: (frame) {
                  Map<String, dynamic> updateOrNewuser = json.decode(frame.body);
                  UserDataBase.instance.insertUser(UserModel(number: updateOrNewuser["number"], name: updateOrNewuser["name"], surname: updateOrNewuser["surname"], urlPhoto: updateOrNewuser["urlPhoto"]));
                }
            );
          });

          List<String> numbersUser = [];
          users.forEach((user) { numbersUser.add(user.number);});
          List<String> contactNumbers = await getAllNumberContacts();
          contactNumbers.removeWhere((element) => !numbersUser.contains(element));

          contactNumbers.forEach((contactNumber) {
            stomp_client.subscribe(
                destination:'/topic/statut/$contactNumber',
                callback: (frame) {
                  Map<String, dynamic> statut = json.decode(frame.body);
                  StoryDataBase.instance.insertStory(StoryModel(numCreator: statut["numCreator"], urlPhoto: null, date: statut["date"], texte: statut["texte"], urlMedia: statut["urlMedia"], mediaType: statut["mediaType"], duration: (statut["mediaType"] == "image")? Duration(seconds: 10): Duration(seconds: 0)));
                }
            );
            stomp_client.subscribe(
                destination:'/topic/post/$contactNumber',
                callback: (frame) {
                  Map<String, dynamic> post = json.decode(frame.body);
                  PostDataBase.instance.insertPost(PostModel(numCreator: post["numCreator"], urlPhoto: null, date: post["date"], texte: post["texte"], urlMedia: post["urlMedia"], mediaType: post["mediaType"], duration: (post["mediaType"] == "image")? Duration(seconds: 10): Duration(seconds: 0), likes: post["likes"]));
                }
            );
          });
        },
        beforeConnect: () async {
          print('waiting to connect...');
          print('to be connect');
          await Future.delayed(Duration(milliseconds: 200));
          print('connecting...');
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
        stompConnectHeaders: {'Authorization': 'Bearer yourToken', 'userId': widget.numCurrent, 'simpUser': widget.numCurrent},
        webSocketConnectHeaders: {'Authorization': 'Bearer yourToken','userId': widget.numCurrent, 'simpUser': widget.numCurrent},
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    stompClient.activate();
    // TODO: implement build
    List<String> numbers = [];
    conversations.forEach((element) { numbers.add(element.numOther);});
    return FutureBuilder(
      future: getNamesOfListNumbers(numbers),
      builder: (context, snapshot) {
        List<String> names;
        if(snapshot.hasData){
          names = snapshot.data;
        } else {names = numbers;}
        return FutureBuilder(
          future: ConversationDataBase.instance.conversations(),
          builder: (context, snapshotConvers) {
            if (snapshotConvers.hasData) {
              List<Conversation> convers = snapshotConvers.data as List;
              convers.forEach((conversation) {
                conversations.add(ConversationModel(isGroup: false, currentMessage: conversation.lastMessage, numOther: conversation.numOther.toString(), numCreatorGroup: null, dateCreationGroup: null, timeCurrentMessage: DateHelper().getDate(conversation.date), amountNewMessages: conversation.amountMessagesNotRead));
              });
              return Scaffold(
                  floatingActionButton: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 48,
                          child: FloatingActionButton(
                            heroTag: "btn1",
                            elevation: 8,
                            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (builder) => CameraPage()));},
                            child: Icon(FontAwesomeIcons.cameraRetro),
                          ),
                        ),
                        SizedBox(
                          height: 11,
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (
                                builder) => SelectContact()));
                          },
                          child: Icon(FontAwesomeIcons.commentAlt),
                        ),
                      ],
              ),
                  body: ListView.builder(
                    itemCount: conversations.length,
                    itemBuilder: (contex, index) =>
                        CustomCard(conversationModel: conversations[index],
                          name: names[index],
                          numCurrent: widget.numCurrent,
                          urlPhoto: "",),
                  )
              );
            } else {
              return Center(child: Text(
                  "Echec dans la récupération des conversations dans la bd du téléphone"),);
            }
          },
        );
      },
    );
  }
}