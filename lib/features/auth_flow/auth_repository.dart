import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/core/network/dio.dart';

abstract class AuthRepository {
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return TMDBAuthRepository(dio: ref.watch(dioProvider));
});

class TMDBAuthRepository implements AuthRepository {
  TMDBAuthRepository({required this.dio});

  final Dio dio;
}
