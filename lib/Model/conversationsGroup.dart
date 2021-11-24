class ConversationGroup {
  String urlPhoto;
  int numCreatorGroup;
  DateTime dateCreationGroup;
  int numCurrent;
  String lastMessage;
  DateTime date;
  int lastToWrite;
  int amountMessagesNotRead;

  ConversationGroup({this.urlPhoto, this.numCreatorGroup, this.dateCreationGroup, this.numCurrent, this.lastMessage, this.date, this.lastToWrite, this.amountMessagesNotRead});

  Map<String, dynamic> toMap() {
    return {
      "urlPhoto": urlPhoto,
      "numCreatorGroup": numCreatorGroup,
      "dateCreationGroup": dateCreationGroup.toIso8601String(),
      "numCurrent": numCurrent,
      "lastMessage": lastMessage,
      "date": date.toIso8601String(),
      "lastToWrite": lastToWrite,
      "amountMessagesNotRead": amountMessagesNotRead
    };
  }

  factory ConversationGroup.fromMap(Map<String, dynamic> map) => new ConversationGroup(
      urlPhoto: map["urlPhoto"],
      numCreatorGroup: map["numCreatorGroup"],
      dateCreationGroup: DateTime.parse(map["dateCreationGroup"]),
      numCurrent: map["numCurrent"],
      lastMessage: map["lastMessage"],
      date: DateTime.parse(map["date"]),
      lastToWrite: map["lastToWrite"],
      amountMessagesNotRead: map["amountMessagesNotRead"]
  );
}