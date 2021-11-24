class MessageModel {
  String numSender;
  String numReceiver;
  DateTime date;
  String mediaType;
  String texte;
  String urlMedia;

  MessageModel({this.numSender, this.numReceiver, this.date, this.mediaType, this.texte, this.urlMedia});

  Map<String, dynamic> toMap() {
    return {
      "numSender": numSender,
      "numReceiver": numReceiver,
      "date": date.toIso8601String(),
      "mediaType": mediaType,
      "texte": texte,
      "urlMedia": urlMedia
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) => new MessageModel(numSender: map['numSender'],
    numReceiver: map['numReceiver'],
    date: DateTime.parse(map['date']),
    mediaType: map['mediaType'],
    texte: map["texte"],
    urlMedia: map['urlMedia']
  );

  toString(){
    return  'numSender : ' + numSender + ' // numReceiver : ' + numReceiver + 'date : ' + date.toIso8601String() + 'mediaType : ' + mediaType + 'texte : ' + texte + 'urlMedia : ' + urlMedia;
  }
}
