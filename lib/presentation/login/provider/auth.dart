import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../data/datasource/remote/supabase/user_supabase.dart';
import '../../../data/datasource/local/session.dart';
import '../../../data/domain/entities/result.dart';
import 'package:spds/core/exceptions.dart';
import 'package:spds/data/datasource/remote/supabase/token_supabase.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, ResultState<bool>>((
  ref,
) {
  return LoginNotifier(UserRemoteDatasource(), TokenSupabase());
});

class LoginNotifier extends StateNotifier<ResultState<bool>> {
  final UserRemoteDatasource _remote;
  final TokenSupabase _tokenSupabase;

  LoginNotifier(this._remote, this._tokenSupabase)
    : super(const ResultState.init());

  Future<void> login(String user, String pass) async {
    state = const ResultState.loading();

    try {
      final success = await _remote.login(user, pass);

      if (success) {
        await LocalSession.saveSessionuser(userFlutter: user);

        await _initFCM();

        state = const ResultState.success(true);
      } else {
        state = ResultState.error(
          AppCustomException('PASSWORD_OR_USER_INCORRECT'),
        );
      }
    } catch (e) {
      state = ResultState.error(AppCustomException(e.toString()));
    }
  }

  Future<void> signup(String user, String pass) async {
    state = const ResultState.loading();

    try {
      final success = await _remote.insertUser(user: user, password: pass);

      if (success) {
        state = const ResultState.success(true);
      } else {
        state = ResultState.error(AppCustomException('USER_EXISTS'),
        );
      }
    } catch (e) {
      state = ResultState.error(AppCustomException(e.toString()));
    }
  }

  Future<void> _initFCM() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission();

      print("Permission: ${settings.authorizationStatus}");

      final token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        print("token: $token");
        await _tokenSupabase.saveToken(token);
      } else {
        print("Token NULL");
      }

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        print("Refresh token: $newToken");
        await _tokenSupabase.saveToken(newToken);
      });
    } catch (e) {
      print("FCM Error: $e");
    }
  }

  void reset() {
    state = const ResultState.init();
  }
}
