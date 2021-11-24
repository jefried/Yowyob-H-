class UserModel {
  String number;
  String name;
  String surname;
  String description;
  String urlPhoto;
  UserModel({this.number, this.name, this.surname,this.description, this.urlPhoto});

  Map<String, dynamic> toMap() {
    return {
      "number": number,
      "name": name,
      "surname": surname,
      "description": description,
      "urlPhoto": urlPhoto
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      number: map['number'],
      name: map['name'],
      surname: map['surname'],
      description: map['description'],
      urlPhoto: map['urlPhoto']
    );
  }

  toString(){
    return number + '/' + name + '/' +surname+ '/' +description + '/' +urlPhoto;
  }
}