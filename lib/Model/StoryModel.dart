import 'package:flutter_whatsapp/Model/ContactModel.dart';

class StoryModel {
  final String numCreator;
  final String urlPhoto;
  final DateTime date;
  final String texte;
  final String urlMedia;
  final String mediaType;
  final Duration duration;

  StoryModel({this.numCreator, this.urlPhoto, this.date,this.texte,this.urlMedia, this.mediaType,this.duration});

  Map<String, dynamic> toMap() {
    return {
      "numCreator": numCreator,
      "urlPhoto": urlPhoto,
      "date": date.toIso8601String(),
      "texte": texte,
      "urlMedia": urlMedia,
      "mediaType": mediaType,
      "duration": duration.inSeconds
    };
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) => new StoryModel(numCreator: map['numCreator'],
      urlPhoto: map['urlPhoto'],
      date: DateTime.parse(map['date']),
      texte: map['texte'],
      urlMedia: map['urlMedia'],
      mediaType: map["mediaType"],
      duration: Duration(seconds: map["duration"])
  );
}