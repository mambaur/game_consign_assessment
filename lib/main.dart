import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_consign_assessment/core/permission.dart';
import 'package:game_consign_assessment/features/reminders/presentations/bloc/reminder_bloc/reminder_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:math';
import 'package:game_consign_assessment/core/local_notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'app.dart';

LocalNotification localNotification = LocalNotification();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Local Notification Configuration
  await localNotification.init();

  // Work Manager Init
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  initRequestPermission();

  runApp(BlocProvider(
    create: (context) => ReminderBloc(),
    child: const App(),
  ));
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    LocalNotification localNotification = LocalNotification();
    await localNotification.init();

    if (inputData?['type'] == 'LOCATION') {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          double.parse(inputData!['latitude'].toString()),
          double.parse(inputData['longitude'].toString()));

      if (distance < 100) {
        localNotification.show(
            Random().nextInt(10000),
            inputData['title'],
            inputData['description'],
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel?.id ?? '',
                channel?.name ?? '',
                channelDescription: channel?.description ?? '',
                playSound: true,
              ),
            ),
            payload: json.encode(inputData));
      }
    } else {
      localNotification.show(
          Random().nextInt(10000),
          inputData?['title'],
          inputData?['description'],
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel?.id ?? '',
              channel?.name ?? '',
              channelDescription: channel?.description ?? '',
              playSound: true,
            ),
          ),
          payload: json.encode(inputData));
    }

    return Future.value(true);
  });
}
