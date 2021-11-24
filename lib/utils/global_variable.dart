String url_root = "http://192.168.43.21:8080";
String url_root_ws = "ws://192.168.43.21:8080";

class NotifNumber{
  static int countNotif = 0;

  static void increaseCountNotif() {
    countNotif++;
  }
}