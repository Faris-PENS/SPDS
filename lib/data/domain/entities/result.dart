import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
class ResultState<T> with _$ResultState<T> {
  const ResultState._();

  const factory ResultState.init() = _init<T>;
  const factory ResultState.loading() = _loading;
  const factory ResultState.success(T data) = _success<T>;
  const factory ResultState.error(Exception exception) = _error;

  bool get isInit => maybeWhen(init: () => true, orElse: () => false);

  bool get isLoading => maybeWhen(loading: () => true, orElse: () => false);

  bool get isSuccess => maybeMap(success: (_) => true, orElse: () => false);

  bool get isError => maybeWhen(error: (_) => true, orElse: () => false);

  T? get data => maybeWhen(success: (data) => data, orElse: () => null);

  Exception? get exception =>
      maybeWhen(error: (exception) => exception, orElse: () => null);
}
