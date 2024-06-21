import 'package:game_consign_assessment/features/reminders/repositories/reminder_repository.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase.dart';
import '../../../shared/models/response.dart';

class DeleteReminder implements UseCase<Result<Response>, int> {
  DeleteReminder();

  final ReminderRepository _repository = ReminderRepository();

  @override
  Future<Result<Response>> call(int params) async {
    var result = await _repository.delete(params);

    return result;
  }
}
