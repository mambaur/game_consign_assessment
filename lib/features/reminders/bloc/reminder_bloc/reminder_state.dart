part of 'reminder_bloc.dart';

@immutable
sealed class ReminderState {}

final class ReminderInitial extends ReminderState {}

final class ReminderLoadInProgress extends ReminderState {}

final class ReminderLoadSuccess extends ReminderState {}

final class ReminderLoadFailure extends ReminderState {}
