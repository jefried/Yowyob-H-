class Conversation {
  String urlPhoto;
  int numOther;
  int numCurrent;
  String lastMessage;
  DateTime date;
  int lastToWrite;
  int amountMessagesNotRead;

  Conversation({this.urlPhoto, this.numOther, this.numCurrent, this.lastMessage, this.date, this.lastToWrite, this.amountMessagesNotRead});

  Map<String, dynamic> toMap() {
    return {
      "urlPhoto": urlPhoto,
      "numOther": numOther,
      "numCurrent": numCurrent,
      "lastMessage": lastMessage,
      "date": date.toIso8601String(),
      "lastToWrite": lastToWrite,
      "amountMessagesNotRead": amountMessagesNotRead
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) => new Conversation(
    urlPhoto: map["urlPhoto"],
    numOther: map["numOther"],
    numCurrent: map["numCurrent"],
    lastMessage: map["lastMessage"],
    date: DateTime.parse(map["date"]),
    lastToWrite: map["lastToWrite"],
    amountMessagesNotRead: map["amountMessagesNotRead"]
  );
}