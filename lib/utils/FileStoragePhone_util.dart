import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void storeFile(File file, String folder, String fileName) async{
  final BasePath = await _localPath;
  File newFile = await File('$BasePath/$folder/$fileName').create(recursive: true);
  newFile.copy(file.path);
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFileAuthStatut async {
  final path = await _localPath;
  return File('$path/authStatut.txt');
}

Future<File> writeAuthStatut(int auth) async{
  final file = await _localFileAuthStatut;
  return file.writeAsString('$auth');
}

Future<int> readAuthStatut() async {
  try {
    final file = await _localFileAuthStatut;

    // Read the file
    final contents = await file.readAsString();

    return int.parse(contents);
  } catch (e) {
    // If encountering an error, return 0
    return 0;
  }
}