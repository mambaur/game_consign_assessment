import 'package:intl/intl.dart';

class CustomDate {
  /// DateFormat now in string
  ///
  /// Output : 2022-05-06 12:30:19
  static String timestamp() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
    return formattedDate;
  }

  /// DateFormat now in string
  ///
  /// Output : 2022-05-06
  static String commonDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return formattedDate;
  }
}
