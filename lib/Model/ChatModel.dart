class ChatModel {
  String name;
  String icon;
  bool isGroup;
  String time;
  String currentMessage;
  String status;
  bool select = false;
  int id;
  String urlPhoto;

  ChatModel({this.name,this.icon,this.isGroup,this.time,this.currentMessage,this.status,this.select=false,this.id, this.urlPhoto});
}