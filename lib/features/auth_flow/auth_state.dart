import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class AuthState extends Equatable {
  const AuthState({
    this.themeMode = ThemeMode.system,
  });

  final ThemeMode themeMode;

  AuthState copyWith({
    ThemeMode? themeMode,
  }) {
    return AuthState(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props =>
      [

      ];
}
