import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/features/auth_flow/auth_service.dart';
import 'package:movie_recommendations/features/auth_flow/auth_state.dart';

final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, AuthState>(
  (ref) {
    return AuthController(
      AuthState(),
      ref.watch(authServiceProvider),
    );
  },
);

class AuthController extends StateNotifier<AuthState> {
  AuthController(AuthState state, this._authService) : super(state) {
  }

  final AuthService _authService;

  @override
  void dispose() {
    super.dispose();
  }

}
