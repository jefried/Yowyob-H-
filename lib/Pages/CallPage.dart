import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/Model/UserModel.dart';
import 'package:flutter_whatsapp/Model/messages.dart';
import 'package:flutter_whatsapp/database/MessageDataBase.dart';
import 'package:flutter_whatsapp/database/UserDataBase.dart';
import 'package:flutter_whatsapp/utils/global_variable.dart';
import 'package:flutter_whatsapp/utils/network_util.dart';

class CallPage extends StatefulWidget {
  CallPage({Key key}) : super(key: key);

  @override
  CallPageState createState() => CallPageState();
}

class CallPageState extends State<CallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Calls"),)
    );
  }

}