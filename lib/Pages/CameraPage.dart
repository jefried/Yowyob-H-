import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/Screens/CameraScreen.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({Key key, this.from}) : super(key: key);
  final String from;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CameraScreen(from: from);
  }
}