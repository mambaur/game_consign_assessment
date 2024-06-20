import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_consign_assessment/core/bloc.dart';

import 'app.dart';
import 'core/local_notification.dart';

LocalNotification localNotification = LocalNotification();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Local Notification Configuration
  await localNotification.init();

  runApp(MultiBlocProvider(
    providers: BlocSetting.providers(),
    child: const App(),
  ));
}
