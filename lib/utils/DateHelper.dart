import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
class DateHelper {

  String getDate(DateTime datePost) {
    initializeDateFormatting();
    DateTime now = DateTime.now();
    DateFormat format;
    if(now.difference(datePost).inDays > 0) {
      format = new DateFormat.yMMMd("fr_FR");
    } else {
      format = new DateFormat.Hm("fr_FR");
    }
    return format.format(datePost).toString();
  }

  String getDate2(String timestamp) {
    initializeDateFormatting();
    DateTime now = DateTime.now();
    DateTime datePost = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    DateFormat format;
    if(now.difference(datePost).inDays > 0) {
      format = new DateFormat.yMMMd("fr_FR");
    } else {
      format = new DateFormat.Hm("fr_FR");
    }
    return format.format(datePost).toString();
  }
}