import 'package:game_consign_assessment/features/reminders/repositories/reminder_repository.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase.dart';
import '../models/reminder.dart';

class FindReminder implements UseCase<Result<Reminder?>, int> {
  FindReminder();

  final ReminderRepository _repository = ReminderRepository();

  @override
  Future<Result<Reminder?>> call(int params) async {
    var result = await _repository.find(params);

    return result;
  }
}
