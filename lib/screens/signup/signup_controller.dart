import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

final signupControllerProvider =
    StateNotifierProvider<SignupController, AsyncValue<String?>>(
        (ref) => SignupController());

class SignupController extends StateNotifier<AsyncValue<String?>> {
  SignupController() : super(const AsyncValue.data(null));

  Future<void> signup(String fullname,String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final message = await SignupApiService.signup(fullname,email, password);
      state = AsyncValue.data(message);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
