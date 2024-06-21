part of 'reminder_bloc.dart';

@immutable
sealed class ReminderEvent {}

class ReminderStore extends ReminderEvent {}

class ReminderUpdate extends ReminderEvent {}

class ReminderDelete extends ReminderEvent {}

class ReminderAll extends ReminderEvent {}
