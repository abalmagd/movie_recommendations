import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../environment_variables.dart';

final dioProvider = Provider<Dio>(
  (ref) {
    return Dio(
      BaseOptions(
        baseUrl: 'https://api.themoviedb.org/3/',
        headers: {
          'Authorization': 'Bearer $v4AuthKey',
        },
      ),
    );
  },
);
