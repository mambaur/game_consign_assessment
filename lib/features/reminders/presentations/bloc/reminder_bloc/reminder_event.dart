part of 'reminder_bloc.dart';

@immutable
sealed class ReminderEvent {}

class ReminderStore extends ReminderEvent {
  final Map<String, dynamic> params;

  ReminderStore({required this.params});
}

class ReminderUpdate extends ReminderEvent {
  final Map<String, dynamic> params;

  ReminderUpdate({required this.params});
}

class ReminderDelete extends ReminderEvent {
  final int params;

  ReminderDelete({required this.params});
}

class ReminderDeleteAll extends ReminderEvent {}
