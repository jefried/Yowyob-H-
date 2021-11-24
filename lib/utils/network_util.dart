import 'dart:async';
import 'dart:convert';
import 'package:flutter_whatsapp/Model/UserModel.dart';
import 'package:flutter_whatsapp/utils/global_variable.dart';
import 'package:http/http.dart' as http;


class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> downloadFile(String url) {
    // cette fonction prend juste en entrée l'url que met à disposition le backend pour download un fichier
    return http.get(url).then((http.Response response) {
      var res = response.bodyBytes;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      //return _decoder.convert(res);
      print("statusCode  = "+ statusCode.toString());
      return res;
    });
  }

  Future<String> uploadFile(filePath, url) async {
    // Cette fonction prend en entrée le chemin du fichier à uploader (file.path si file est un object File)
    // Elle prend aussi en entrée le chemin que met à disposition le backend pour uploader les fichiers
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    var res = await request.send();
    return res.reasonPhrase;
  }

  Future<dynamic> getNewUsers(String numReceiver) {
    return http.get('$url_root/list_new_users_of_receiver/$numReceiver').then((http.Response response) {
      var res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      print("statusCode  = "+ statusCode.toString());
      return _decoder.convert(res);
    });
  }

  Future<dynamic> getMessages(String numReceiver) {
    return http.get('$url_root/list_messages_of_user/$numReceiver').then((http.Response response) {
      var res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      print("statusCode  = "+ statusCode.toString());
      return _decoder.convert(res);
    });
  }

  Future<dynamic> getMessagesGroup(String numReceiver) {
    return http.get('$url_root/list_messagesGroupe_for_receiver/$numReceiver').then((http.Response response) {
      var res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      print("statusCode  = "+ statusCode.toString());
      return _decoder.convert(res);
    });
  }

  Future<dynamic> getStatuts(String numReceiver) {
    return http.get('$url_root/new_statuts_for_user/$numReceiver').then((http.Response response) {
      var res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      print("statusCode  = "+ statusCode.toString());
      return _decoder.convert(res);
    });
  }

  Future<dynamic> getPosts(String numReceiver) {
    return http.get('$url_root/posts_for_user/$numReceiver').then((http.Response response) {
      var res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      print("statusCode  = "+ statusCode.toString());
      return _decoder.convert(res);
    });
  }

  Future<dynamic> getCalls(String numReceiver) {
    return http.get('$url_root/list_calls_of_User/$numReceiver').then((http.Response response) {
      var res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      print("statusCode  = "+ statusCode.toString());
      return _decoder.convert(res);
    });
  }

  Future<dynamic> get(String url) {
    return http.get(url).then((http.Response response) {
      var res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      print("statusCode  = "+ statusCode.toString());
      //return _decoder.convert(res);
      return res;
    });
  }

  Future<UserModel> createUser(String email, String name, String number, String password, String surname, String urlPhoto) async {
    final response = await http.post(
      Uri.parse('$url_root/users/create_user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'name': name,
        'number': number,
        'password': password,
        'surname': surname,
        'urlPhoto': urlPhoto
      }),
    );
    print("---------------------------------");
    print(response.statusCode);
    print("---------------------------------");
    if (response.statusCode < 200 || response.statusCode > 400 || json == null) {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create user.');

    } else {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return UserModel.fromMap(jsonDecode(response.body));
    }
  }

  Future<dynamic> post(String url, dynamic headers, dynamic body, dynamic encoding) {
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }
}