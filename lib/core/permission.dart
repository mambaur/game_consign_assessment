import 'package:permission_handler/permission_handler.dart';

Future<void> initRequestPermission() async {
  var locationStatus = await Permission.location.status;
  if (locationStatus.isDenied) {
    if (await Permission.location.request().isGranted) {
      // Izin diberikan
    } else {
      // Izin ditolak
    }
  }

  // Meminta izin lokasi background jika diperlukan
  if (await Permission.locationAlways.isDenied) {
    if (await Permission.locationAlways.request().isGranted) {
      // Izin lokasi background diberikan
    } else {
      // Izin lokasi background ditolak
    }
  }

  // Meminta izin notifikasi
  var notificationStatus = await Permission.notification.status;
  if (notificationStatus.isDenied) {
    if (await Permission.notification.request().isGranted) {
      // Izin notifikasi diberikan
    } else {
      // Izin notifikasi ditolak
    }
  }
}
