class GroupModel {
  String numCreator;
  DateTime dateCreation;
  String nom;
  String description;
  String membres;
  String urlPhoto;

  GroupModel({this.numCreator,this.dateCreation, this.nom, this.description, this.membres, this.urlPhoto});

  Map<String, dynamic> toMap() {
    return {
      "numCreator": numCreator,
      "dateCreation": dateCreation.toIso8601String(),
      "nom": nom,
      "description": description,
      "membres": membres,
      "urlPhoto": urlPhoto
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
        numCreator: map["creator"],
        dateCreation: DateTime.parse(map["date"]),
        nom: map["nom"],
        description: map["description"],
        membres: map["membres"],
        urlPhoto: map["urlPhoto"],
    );
  }
}