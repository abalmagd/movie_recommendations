import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/features/auth_flow/auth_repository.dart';

abstract class AuthService {}

final authServiceProvider = Provider<AuthService>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return TMDBAuthService(authRepository);
});

class TMDBAuthService implements AuthService {
  TMDBAuthService(this._authRepository);

  final AuthRepository _authRepository;
}
