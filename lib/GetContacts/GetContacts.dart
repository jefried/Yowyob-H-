
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_whatsapp/GetContacts/Contacte.dart';

Future<List<Contacte>> getAllContacts() async {
  List<Contacte> contacts = [];
  Iterable<Contact> _contacts = (await ContactsService.getContacts(withThumbnails: false));
  _contacts.forEach((contact) {
    if(contact.phones.toList().length != 0) {
      var number = contact.phones.toList();
      contacts.add(Contacte(name: contact.displayName, number: extractNumber(number[0].value)));
    }
  });
  return contacts;
}

String extractNumber(String number) {
  String extractNumber = "";
  var count = 0;
  var len = number.length - 1;
  var i = len;
  while (count <=7 && i >= 0) {
    if(number[i].compareTo("0") == 0 || number[i].compareTo("1") == 0 || number[i].compareTo("2") == 0 || number[i].compareTo("3") == 0 || number[i].compareTo("4") == 0 || number[i].compareTo("5") == 0 || number[i].compareTo("6") == 0 || number[i].compareTo("7") == 0 || number[i].compareTo("8") == 0 || number[i].compareTo("9") == 0) {
      extractNumber = number[i] + extractNumber;
      count++;
    }
    i--;
  }
  extractNumber = "6" + extractNumber;
  return extractNumber;
}

Future<List<String>> getAllNumberContacts() async{
  List<Contacte> contacts = await getAllContacts();
  List<String> numbers= [];
  contacts.forEach((contact) {
    numbers.add(contact.number);
  });
  return numbers;
}

Future<String> getNameOfNumber(String number) async {
  List<Contacte> contacts = await getAllContacts();
  String name = number;
  for (var contact in contacts) {
    if(contact.number == number) {
      name = contact.name;
    }
  }
  return name;
}

Future<List<String>> getNamesOfListNumbers(List<String> numbers) async {
  List<Contacte> contacts = await getAllContacts();
  List<String> names = numbers;
  for (var contact in contacts) {
    int count = 0;
    for(var number in numbers) {
      if(contact.number == numbers[count]) {
        print(contact.name);
        names[count] = contact.name;
      }
      count ++;
    }
  }
}