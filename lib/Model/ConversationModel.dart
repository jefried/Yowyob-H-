import 'package:flutter_whatsapp/GetContacts/GetContacts.dart';

class ConversationModel {
  bool isGroup;
  String currentMessage;
  String timeCurrentMessage;
  String numOther;
  String numCreatorGroup;
  String dateCreationGroup;
  int amountNewMessages = 0;
  String urlPhoto;

  ConversationModel({this.isGroup,this.currentMessage,this.timeCurrentMessage,this.numOther, this.numCreatorGroup, this.dateCreationGroup, this.amountNewMessages, this.urlPhoto});

  factory ConversationModel.fromJsonConvers(Map<String, dynamic> json) {
    return ConversationModel(
        isGroup: false,
        currentMessage: json['dernierMessage'],
        timeCurrentMessage: json['date'],
        numOther: json['numOther'],
        numCreatorGroup: null,
        dateCreationGroup: null,
        amountNewMessages: json['amountNewMessages']
    );
  }

  factory ConversationModel.fromJsonGroup(Map<String, dynamic> json) {
    return ConversationModel(
        isGroup: true,
        currentMessage: json['dernierMessage'],
        timeCurrentMessage: json['date'],
        numOther: null,
        numCreatorGroup: json["creator"],
        dateCreationGroup: json["date"],
        amountNewMessages: json['amountNewMessages']
    );
  }
}