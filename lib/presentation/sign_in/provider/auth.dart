import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasource/remote/supabase/user_supabase.dart';
import '../../../data/datasource/local/session.dart';
import '../../../data/domain/entities/result.dart';
import 'package:spds/core/exceptions.dart';

final loginProvider =
    StateNotifierProvider<LoginNotifier, ResultState<bool>>((ref) {
  return LoginNotifier(UserRemoteDatasource());
});

class LoginNotifier extends StateNotifier<ResultState<bool>> {
  final UserRemoteDatasource _remote;

  LoginNotifier(this._remote) : super(const ResultState.init());

  Future<void> login(String user, String pass) async {
    state = const ResultState.loading();

    try {
      final success = await _remote.login(user, pass);

      if (success) {
        await LocalSession.saveSessionuser(userFlutter: user);

        state = const ResultState.success(true);
      } else {
        state = ResultState.error(AppCustomException('PASSWORD_OR_USER_INCORRECT'));
      }
    } catch (e) {
      String errorMessage = e.toString();
      state = ResultState.error(AppCustomException(errorMessage));
    }
  }

  void reset() {
    state = const ResultState.init();
  }
}