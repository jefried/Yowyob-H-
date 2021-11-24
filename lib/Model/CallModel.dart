class CallModel {
  String numSender;
  String numReceiver;
  String urlPhotoSender;
  String urlPhotoReceiver;
  DateTime date;
  bool taken;

  CallModel({this.numSender, this.numReceiver, this.urlPhotoSender, this.urlPhotoReceiver, this.date, this.taken});

  Map<String, dynamic> toMap() {
    return {
      "numSender": numSender,
      "numReceiver": numReceiver,
      "urlPhotoSender": urlPhotoSender,
      "urlPhotoReceiver": urlPhotoReceiver,
      "date": date.toIso8601String(),
      "taken": taken? 1:0
    };
  }

  factory CallModel.fromMap(Map<String, dynamic> map) => new CallModel(
      numSender: map['numSender'],
      numReceiver: map['numReceiver'],
      urlPhotoSender: map['urlPhotoSender'],
      urlPhotoReceiver: map['urlPhotoReceiver'],
      date: DateTime.parse(map['date']),
      taken: map['taken'] == 1,
  );
}