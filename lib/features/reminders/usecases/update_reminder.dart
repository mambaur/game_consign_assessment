import 'package:game_consign_assessment/features/reminders/repositories/reminder_repository.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase.dart';
import '../../../shared/models/response.dart';

class UpdateReminder
    implements UseCase<Result<Response>, Map<String, dynamic>> {
  UpdateReminder();

  final ReminderRepository _repository = ReminderRepository();

  @override
  Future<Result<Response>> call(Map<String, dynamic> params) async {
    var result = await _repository.update(params);

    return result;
  }
}
