import 'package:game_consign_assessment/features/reminders/repositories/reminder_repository.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase.dart';
import '../../models/reminder.dart';

part 'get_reminder_params.dart';

class GetReminders
    implements UseCase<Result<List<Reminder>>, GetReminderParams> {
  GetReminders();

  final ReminderRepository _repository = ReminderRepository();

  @override
  Future<Result<List<Reminder>>> call(GetReminderParams params) async {
    var result = await _repository.getReminders(params);

    return result;
  }
}
