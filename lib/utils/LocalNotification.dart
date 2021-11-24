import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'global_variable.dart';

class LocalNotification{
  Future showNotification(String notifTitle, String notifBody, FlutterLocalNotificationsPlugin localNotif) async {
    var androidDetails = new AndroidNotificationDetails("channelID", "Local Notification", "This is the description of the Notification, you can write anything", importance : Importance.High);
    var iosDetails = new IOSNotificationDetails();
    var generalNotificationDetails = new NotificationDetails(androidDetails,iosDetails);
    await localNotif.show(NotifNumber.countNotif, notifTitle,
        notifBody, generalNotificationDetails);
    NotifNumber.increaseCountNotif();
  }
}