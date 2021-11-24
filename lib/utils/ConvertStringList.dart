String listToString(List<String> list) {
  String texte= "";
  list.forEach((element) {
    texte += element;
    texte += "R";
  });
  return texte;
}

List<String> stringToList(String texte) {
  return texte.split("R");
}