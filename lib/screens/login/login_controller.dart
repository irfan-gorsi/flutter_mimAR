import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

final loginControllerProvider =
    StateNotifierProvider<LoginController, AsyncValue<String?>>(
        (ref) => LoginController());

class LoginController extends StateNotifier<AsyncValue<String?>> {
  LoginController() : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final token = await LoginApiService.login(email, password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token); // Save token

      state = AsyncValue.data(token);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
