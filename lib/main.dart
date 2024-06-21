import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';
import 'core/local_notification.dart';

LocalNotification localNotification = LocalNotification();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Local Notification Configuration
  await localNotification.init();

  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  Workmanager().registerPeriodicTask(
    "task-periodic",
    "taskPeriodic",
    initialDelay: const Duration(seconds: 5),
    frequency: const Duration(minutes: 1),
  );

  runApp(const App());

  // runApp(MultiBlocProvider(
  //   providers: BlocSetting.providers(),
  //   child: const App(),
  // ));
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    String prefKey = 'test_data';
    final prefs = await SharedPreferences.getInstance();
    int? testData = prefs.getInt(prefKey);
    int data = (testData ?? 0) + 1;
    prefs.setInt(prefKey, data);

    LocalNotification localNotification = LocalNotification();
    await localNotification.init();
    localNotification.show(
      Random().nextInt(10000),
      'Notifikasi Alert Masuk',
      "Ini Notifikasi $task",
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel?.id ?? '',
          channel?.name ?? '',
          channelDescription: channel?.description ?? '',
          playSound: true,
          // color: Colors.white,
          // icon: notificationIcon,
        ),
      ),
    );

    return Future.value(true);
  });
}
