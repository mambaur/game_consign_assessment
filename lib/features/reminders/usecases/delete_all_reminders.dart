import 'package:game_consign_assessment/features/reminders/repositories/reminder_repository.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase.dart';
import '../../../shared/models/response.dart';

class DeleteAllReminders implements UseCase<Result<Response>, void> {
  DeleteAllReminders();

  final ReminderRepository _repository = ReminderRepository();

  @override
  Future<Result<Response>> call(void params) async {
    var result = await _repository.deleteAll();

    return result;
  }
}
