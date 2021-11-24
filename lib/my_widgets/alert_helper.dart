import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_whatsapp/my_widgets/custom_dialog.dart';
import 'my_text.dart';
import 'my_textfield.dart';

class AlertHelper {
  Future<void> errors(BuildContext context, String error) async {
    MyText title = MyText("Erreur", color: Colors.black,);
    MyText subtitle = MyText(error, color: Colors.black,);
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext ctx) {
        return (Theme.of(context).platform == TargetPlatform.iOS)
            ? CupertinoAlertDialog(title: title, content: subtitle, actions: <Widget>[close(ctx,"OK")])
        : AlertDialog(title: title, content: subtitle, actions: <Widget>[close(ctx,"OK")]);
      }
    );
  }
  Future<void> error(BuildContext context, String error) async {
    MyText title = MyText("Erreur", color: Colors.black,);
    MyText subtitle = MyText(error, color: Colors.black,);
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return CustomDialog(
            title: "Error",
            description: error,
          );
        }
    );
  }
  FlatButton close(BuildContext ctx, String text) {
    return FlatButton(
      onPressed: (() => Navigator.pop(ctx)),
      child: MyText(text, color: Color.fromRGBO(143, 148, 251, 1),),
    );
  }
}