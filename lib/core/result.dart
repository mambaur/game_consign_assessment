sealed class Result<T> {
  const Result({this.statusCode});

  final int? statusCode;

  const factory Result.success(T value, {int? statusCode}) = Success;
  const factory Result.failed(String? message, {int? statusCode}) = Failed;

  bool get isSuccess => this is Success<T>;
  bool get isFailed => this is Failed<T>;

  T? get resultValue => isSuccess ? (this as Success<T>).value : null;
  String? get errorMessage => isFailed ? (this as Failed<T>).message : null;
}

class Success<T> extends Result<T> {
  final T value;
  // final int? statusCode;

  const Success(this.value, {super.statusCode});
}

class Failed<T> extends Result<T> {
  final String? message;

  const Failed(this.message, {super.statusCode});
}
