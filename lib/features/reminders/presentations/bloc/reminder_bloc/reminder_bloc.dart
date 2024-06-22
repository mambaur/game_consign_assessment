// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:game_consign_assessment/features/reminders/usecases/delete_all_reminders.dart';
import 'package:game_consign_assessment/features/reminders/usecases/delete_reminder.dart';
import 'package:game_consign_assessment/features/reminders/usecases/store_reminder.dart';
import 'package:game_consign_assessment/features/reminders/usecases/update_reminder.dart';
import 'package:meta/meta.dart';

part 'reminder_event.dart';
part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  ReminderBloc() : super(ReminderInitial()) {
    on<ReminderStore>(_storeReminder);
    on<ReminderUpdate>(_updateReminder);
    on<ReminderDelete>(_deleteReminder);
    on<ReminderDeleteAll>(_deleteAllReminders);
  }

  Future<void> _storeReminder(ReminderStore event, emit) async {
    emit(ReminderLoadInProgress());
    StoreReminder storeReminder = StoreReminder();
    await storeReminder(event.params).then((result) {
      if (result.isSuccess) {
        emit(ReminderLoadSuccess(message: result.resultValue?.message));
      } else {
        emit(ReminderLoadFailure(message: result.errorMessage));
      }
    });
  }

  Future<void> _updateReminder(ReminderUpdate event, emit) async {
    emit(ReminderLoadInProgress());
    UpdateReminder updateReminder = UpdateReminder();
    await updateReminder(event.params).then((result) {
      if (result.isSuccess) {
        emit(ReminderLoadSuccess(message: result.resultValue?.message));
      } else {
        emit(ReminderLoadFailure(message: result.errorMessage));
      }
    });
  }

  Future<void> _deleteReminder(ReminderDelete event, emit) async {
    emit(ReminderLoadInProgress());
    DeleteReminder deleteReminder = DeleteReminder();
    await deleteReminder(event.params).then((result) {
      if (result.isSuccess) {
        emit(ReminderLoadSuccess(message: result.resultValue?.message));
      } else {
        emit(ReminderLoadFailure(message: result.errorMessage));
      }
    });
  }

  Future<void> _deleteAllReminders(ReminderDeleteAll event, emit) async {
    emit(ReminderLoadInProgress());
    DeleteAllReminders deleteAllReminder = DeleteAllReminders();
    await deleteAllReminder(null).then((result) {
      if (result.isSuccess) {
        emit(ReminderLoadSuccess(message: result.resultValue?.message));
      } else {
        emit(ReminderLoadFailure(message: result.errorMessage));
      }
    });
  }
}
